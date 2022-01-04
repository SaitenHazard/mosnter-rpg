extends Node

onready var control = get_parent()

onready var monster_manager = get_node('/root/Control/MonsterManager')

#func _get_action():
#	var action_index = control.get_index_action()
#	var monster_index = control.get_index_ally()
#	var monster = monster_manager.get_selected_ally()
#	var action = monster.get_action(action_index)
#
#	return action

#func _get_action_range():
#	return _get_action().action_range

func _set_targets():
	var input_group = control.get_input_group()
	var targets_team = monster_manager.get_target_team()
	var targets = monster_manager.get_selected_action_targets()
	
	if not input_group == INPUT_GROUP.TARGET or not input_group == INPUT_GROUP.ACTION:
		targets_team = null
		targets = null
		return
		
#var targets : Array
#var attacker
#var action
#var action_range
#var team
#var target

func do_action():
	control.lock_inputs()
	var targets = _get_effected_targets()
	_do_damage(targets)
	_do_status_effect(targets)
	_do_swap()
	control.reset_inputs()
	
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
	
func _do_damage(var targets):
	for target in targets:
		var damage = _get_damage(target)
		target.do_damage(damage)
		
func _do_status_effect(var targets):
	var action = get_selected_action()
	var status_effect = action.status_effect
	if status_effect != Status_effect.NULL:
		for target in targets:
			target.set_status(status_effect)
		
func _get_damage(var target):
	var action = get_selected_action()
	var damage = action.damage
	
	if _is_type_advantage(target):
		if _is_action_healing():
			damage = damage - 2
		else:
			damage = damage + 1
		
	if _is_position_advantage(target):
		damage = damage + 1
		
	return damage

func _is_position_advantage(var target):
	if _is_action_healing():
		return false
		
	var attacker = monster_manager.get_selected_ally()
	var attacker_position = attacker.get_position_index()
	var target_position = target.get_position_index()
	
	if attacker_position == target_position:
		return true
		
	return false

func _is_type_advantage(var target):
	var action = get_selected_action()
	var action_type = action.get_type()
	var target_type_weakness = target.get_type_weakness()
	
	if action_type == target_type_weakness:
		return true
		
	return false
	
func _is_action_healing():
	var action = get_selected_action()
	
	if action.damage < 0:
		return true;
		
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
