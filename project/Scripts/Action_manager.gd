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

func do_action():
	control.lock_inputs()
	_set_turn_available()
	_deduct_action_points()
	_do_damage()
	_do_status_effect()
	_do_swap()
	control.input_allies_increment(true)
	control.reset_inputs()
	
func _set_turn_available():
	var monster = monster_manager.get_selected_ally()
	monster.set_turn_availabale(false)

	
func _deduct_action_points():
	var action = get_selected_action()
#	print('_deduct_action_points')
#	print(action.cost)
	game_manager.deduct_action_points(action.cost)
	
func enough_points_for_action():
	var action = get_selected_action()
	
#	print('enough_points_for_action')
#	print(action.cost)
#	print(action.name)
	
	if game_manager.get_action_points() < action.cost:
		return false
	
	return true
	
func _do_swap():
	var action = get_selected_action()
	
	if action.swap == null:
		return
		
	var target_one
	var target_two
	
	var position_index_target_one
	var position_index_target_two
	
	if not selected_action_has_two_targets():
		target_one = monster_manager.get_selected_ally()
		target_two = monster_manager.get_target()
	elif action.swap == TEAM.ALLY or action.name == "Bonfire":
		target_one = monster_manager.get_actioner()
		target_two = monster_manager.get_targettwo()
	else:
		target_one = monster_manager.get_target()
		target_two = monster_manager.get_targettwo()
		
	position_index_target_one = target_one.get_position_index()
	position_index_target_two = target_two.get_position_index()
		
	target_one.set_position_index(position_index_target_two)
	target_two.set_position_index(position_index_target_one)
	
func _get_effected_targets():
	var action = get_selected_action()
	var action_range = action.action_range

	var targets : Array

	if action_range == ACTION_RANGE.ALLY_ALL:
		targets = monster_manager.get_allies()
	elif action_range == ACTION_RANGE.FOE_ALL:
		targets = monster_manager.get_foes()
	else:
		var target_index = control.get_index_target()
		var target = monster_manager.get_target()
		targets.append(target)
		
	return targets
	
func _do_damage():
	var targets = _get_effected_targets()
	for target in targets:
		var damage = _get_damage(target)
#		print(damage)
		target.do_damage(damage)
		
func _do_status_effect():
	var action = get_selected_action()
	var status_effect = action.status_effect
	var targets = _get_effected_targets()
	
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
		
	if _is_position_advantage(target):
		damage = damage + 1
		
	return damage

func _is_position_advantage(var target = null, var action = null, var user = null):
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
	
func selected_action_has_two_targets():
	var action = get_selected_action()
	
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
