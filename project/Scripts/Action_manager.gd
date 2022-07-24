extends Node

onready var control = get_parent()

onready var monster_manager = get_node('/root/Control/MonsterManager')
onready var game_manager = get_node('/root/Control/GameManager')
onready var action_animations = get_node('/root/Control/ActionAnimation')

var type_advantage : bool = false
var position_advantage : bool = false
var critical : bool = false
var boosted : bool = false
var status_effect = Status_effect.NULL

#onready var last_action_used

#var animation_playing : bool = false
var delay_time : float

#func _set_targets():
#	var input_group = control.get_input_group()
#	var targets_team = monster_manager.get_target_team()
#	var targets = monster_manager.get_selected_action_targets()
#
#	if not input_group == INPUT_GROUP.TARGET or not input_group == INPUT_GROUP.ACTION:
#		targets_team = null
#		targets = null
#		return

func _reset_attributes():
	type_advantage = false
	position_advantage = false
	critical = false
	boosted = false
	status_effect = Status_effect.NULL

func do_action(var action : Action, var user : Monster, var targets : Array, var target2 : Monster):
	control.lock_inputs()
	action_animations.do_animations(action, targets, user)
	user.set_turn_availabale(false)
	targets[0].set_status(action.status_effect)
	
	game_manager.deduct_action_points(action.cost)
	_do_status_effect(action, targets)
	_do_damage(action, user, targets)
	_do_swap(action, user, targets, target2)
	_set_delay_time(action)
	
	yield(get_tree().create_timer(delay_time), "timeout")
	
	var force_swaped = monster_manager.manage_forced_pos_change(targets[0].team)
	
	if force_swaped:
		yield(get_tree().create_timer(2.5), "timeout")
	
	control.reset_inputs()
	
func get_delay_time():
	return delay_time
	
func _set_delay_time(var action):
	if action.action_name == ACTION_NAMES.Bamboo_Bash: 
		delay_time = 3
		
	if action.action_name == ACTION_NAMES.Bonfire: 
		delay_time = 2
		
	if action.action_name == ACTION_NAMES.Fire_Ball: 
		delay_time = 1.5
		
	if action.action_name == ACTION_NAMES.Fire_Blitz: 
		delay_time = 2
		
	if action.action_name == ACTION_NAMES.Healing_Pulse: 
		delay_time = 1.5
		
	if action.action_name == ACTION_NAMES.Icicle_Drop: 
		delay_time = 1
		
	if action.action_name == ACTION_NAMES.Natural_Remedy: 
		delay_time = 1.5
		
	if action.action_name == ACTION_NAMES.Sticky_Seeds: 
		pass
		
	if action.action_name == ACTION_NAMES.Swift_Surf: 
		pass
		
	if action.action_name == ACTION_NAMES.Swap: 
		delay_time = 1

func enough_points_for_action():
	var action = get_selected_action()
	
	if game_manager.get_action_points() < action.cost:
		return false
	
	return true

#func get_last_action_used():
#	return last_action_used
	
func _do_swap(var action : Action, var user: Monster, var targets : Array, var target2: Monster):
	var swap_one
	var swap_two
	
	if action.swap == null:
		return
		
	if action.action_name == ACTION_NAMES.Bamboo_Bash: 
		yield(get_tree().create_timer(3), "timeout")
		
	if action.action_name == ACTION_NAMES.Bonfire: 
		yield(get_tree().create_timer(2), "timeout")
		
	if action.action_name == ACTION_NAMES.Swift_Surf: 
		pass
	
	if not target2 == null:
		swap_one = target2
		if action.swap == ACTION_RANGE.ALLY:
			swap_two = user
		else:
			swap_two = targets[0]
	else:
		swap_one = user
		swap_two = targets[0]
		
	var position_index_swap_one = swap_one.get_position_index()
	var position_index_swap_two = swap_two.get_position_index()
	
	action_animations.do_swap_animations(swap_one, swap_two)
	
	swap_one.set_position_index(position_index_swap_two)
	swap_two.set_position_index(position_index_swap_one)
	
func _get_effected_targets():
	var action = get_selected_action()
	var action_range = action.action_range

	var targets : Array

	if action_range == ACTION_RANGE.ALLY_ALL:
		targets = monster_manager.get_allies()
	elif action_range == ACTION_RANGE.FOE_ALL:
		targets = monster_manager.get_team_a()
	else:
		var target_index = control.get_index_target()
		var target = monster_manager.get_target()
		targets.append(target)
		
	return targets
	
func _do_damage(var action : Action, var user : Monster, var targets : Array):
	if action.damage == null:
		return
		
	for monster in targets:
		_reset_attributes()
		var damage = _get_damage(action, user, monster)
		monster.do_damage(damage)
		monster.do_floating_damage(damage, type_advantage, position_advantage, critical, status_effect, boosted)
		
func _do_status_effect(var action : Action, var targets : Array):
	status_effect = action.status_effect
	
	if status_effect != Status_effect.NULL:
		for target in targets:
			target.set_status(status_effect)
			
func _get_damage(var action : Action, var user : Monster, var target : Monster):
	var damage = action.damage
	
	if damage == 0:
		return damage
		
	if is_type_advantage(action, target):
		type_advantage = true
		if is_action_healing(action):
			damage = damage - 2
		else:
			damage = damage + 1
		
	if is_position_advantage(action, user, target):
		position_advantage = true
		damage = damage + 1
		
	if _is_critical():
		critical = true
		if is_action_healing(action):
			damage = damage - 1
		else:
			damage = damage + 1
			
	if _is_boosted(action, user, target):
		boosted = true
		if is_action_healing(action):
			damage = damage - 1
		else:
			damage = damage + 1
		
	return damage
	
func _is_boosted(var action : Action, var user : Monster, var target : Monster):
	var user_team = user.get_team()
	var target_team = target.get_team()
	
	if action_has_two_targets(action):
		if user_team == TEAM.A:
			if is_action_healing(action):
				if monster_manager.only_one_survivor_teamA():
					return true
			else:
				if monster_manager.only_one_survivor_teamB():
					return true
		else:
			if is_action_healing(action):
				if monster_manager.only_one_survivor_teamB():
					return true
			else:
				if monster_manager.only_one_survivor_teamA():
					return true
			
	return true
	
func _is_critical():
	var rng = game_manager.get_randomizer()
	var roll = rng.randi_range(0,3)
	if roll == 0:
		return true
	else:
		return false
	
func selected_action_has_two_targets():
	var action = get_selected_action()
#	var user = monster_manager.get_selected_team_a()
	return action_has_two_targets(action)

func action_has_two_targets(var action : Action):
	if action.action_name == ACTION_NAMES.Bonfire:
		return false
		
	if action.damage == null or action.swap == null:
		return false
		
#	var only_survivor : bool
#
#	if user.team == TEAM.A:
#		if action.action_range == ACTION_RANGE.ALLY:
#			only_survivor = monster_manager.only_one_survivor_teamA()
#		else:
#			only_survivor = monster_manager.only_one_survivor_teamB()
#	else:
#		if action.action_range == ACTION_RANGE.ALLY:
#			only_survivor = monster_manager.only_one_survivor_teamB()
#		else:
#			only_survivor = monster_manager.only_one_survivor_teamA()
#
#	if only_survivor:
#		return false
	
	return true
	
func is_position_advantage(var action : Action, var user : Monster, var target : Monster):
	if _is_action_range_ally(action):
		return false
		
	if is_action_healing(action):
		return false
		
	var user_position = user.get_position_index()
	
	var target_position = target.get_position_index()
		
	if target_position == user_position:
		return true
		
	return false
	
func _is_action_range_ally(var action : Action):
	if action.action_range == ACTION_RANGE.ALLY:
		return true
		
	if action.action_range == ACTION_RANGE.ALLY_ALL:
		return true
		
	return false

func is_type_advantage(var action : Action, var target : Monster):
	var action_type = action.elemental_type
	var target_type_weakness = target.get_type_weakness()
	
	if action_type == target_type_weakness:
		return true
		
	return false
	
func is_action_healing(var action : Action):
	if action.damage == null:
		return false
		
	if action.damage < 0:
		return true
		
	return false
	
#func action_has_two_targets(var action):
#	if action.name == "Bonfire":
#		return false
#
#	if not action.damage == 0 and not action.swap == null:
#		return true
#
#	return false
	
func get_selected_action():
	var index_action = control.get_index_action()
	return get_selected_ally_actions()[index_action]

func get_selected_ally_actions():
	return monster_manager.get_selected_team_a().get_actions()
