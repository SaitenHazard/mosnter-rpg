extends Node

onready var control = get_parent()

onready var monster_manager = get_node('/root/Control/MonsterManager')
onready var game_manager = get_node('/root/Control/GameManager')

func _set_targets():
	var input_group = control.get_input_group()
	var targets_team = monster_manager.get_target_team()
	var targets = monster_manager.get_selected_action_targets()
	
	if not input_group == INPUT_GROUP.TARGET or not input_group == INPUT_GROUP.ACTION:
		targets_team = null
		targets = null
		return

func do_action(var action, var user, var targets, var target2):
	control.lock_inputs()
	user.set_turn_availabale(false)
	game_manager.deduct_action_points(action.cost)
	
	_do_damage(action, user, targets)
	_do_status_effect(action, targets)
	_do_swap(action, user, targets, target2)
	
	control.input_allies_increment(true)
	control.reset_inputs()
	
func enough_points_for_action():
	var action = get_selected_action()
	
	if game_manager.get_action_points() < action.cost:
		return false
	
	return true
	
func _do_swap(var action, var user, var targets, var target2):
	
	if action.swap == null:
		return
		
	if user.team == TEAM.A:
		_do_player_swap(action, user, targets, target2)
	else:
		_do_ai_swap(action, user, targets, target2)
	
func _do_player_swap(var action, var user, var targets, var target2):
	var swap_one
	var swap_two
	
	if target2 != null:
		swap_one = target2
		if action.swap == TEAM.A:
			swap_two = user
		else:
			swap_two = targets
	else:
		if action.swap == TEAM.A:
			swap_one = user
			swap_two = targets
			

			
	return
			
	var position_index_swap_one = swap_one.get_position_index()
	var position_index_swap_two = swap_two.get_position_index()
		
	swap_one.set_position_index(position_index_swap_two)
	swap_two.set_position_index(position_index_swap_one)
	
func _do_ai_swap(var action, var user, var targets, var target2):
	pass
	
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
	
func _do_damage(var action, var user, var targets):
#	var targets = _get_effected_targets()
	for target in targets:
		var damage = _get_damage(target)
#		print(damage)
		target.do_damage(damage)
		
func _do_status_effect(var action, var targets):
#	var action = get_selected_action()
	var status_effect = action.status_effect
#	var targets = _get_effected_targets()
	
	if status_effect != Status_effect.NULL:
		for target in targets:
			target.set_status(status_effect)
		
func _get_damage(var target):
	var action = get_selected_action()
	var damage = action.damage
	
	if damage == 0:
		return damage
		
	if is_type_advantage(target):
		if is_action_healing():
			damage = damage - 2
		else:
			damage = damage + 1
		
	if is_position_advantage(target):
		damage = damage + 1
		
	return damage
	
func selected_action_has_two_targets():
	var action = get_selected_action()
	
	if action.name == "Bonfire":
		return false
		
	if not action.damage == 0 and not action.swap == null:
		return true
	
	return false

func is_position_advantage(var target = null, var action = null, var user = null):
	if action == null:
		action = get_selected_action()
	
	if _is_action_range_ally(action):
		return false
		
	if is_action_healing(action):
		return false
		
	if user == null:
		user = monster_manager.get_selected_ally()
		
	var user_position = user.get_position_index()
	
	if target == null:
		target = monster_manager.get_target()
	
	var target_position = target.get_position_index()
	
	if target_position == user_position:
		return true
		
	return false
	
func _is_action_range_ally(var action = null):
	if action == null:
		action = get_selected_action()
		
	if action.action_range == ACTION_RANGE.ALLY:
		return true
		
	if action.action_range == ACTION_RANGE.ALLY_ALL:
		return true
		
	return false

func is_type_advantage(var target, var action = null):
	if action == null:
		action = get_selected_action()
		
	var action_type = action.elemental_type
	var target_type_weakness = target.get_type_weakness()
	
	if action_type == target_type_weakness:
		return true
		
	return false
	
func is_action_healing(var action = null):
	if action == null:
		action = get_selected_action()
	
	if action.damage < 0:
		return true
		
	return false
	
func action_has_two_targets(var action):
	if action.name == "Bonfire":
		return false
		
	if not action.damage == 0 and not action.swap == null:
		return true
	
	return false
	
func get_selected_action():
	var index_action = control.get_index_action()
	return get_selected_ally_actions()[index_action]

func get_selected_ally_actions():
	return monster_manager.get_selected_ally().get_actions()
