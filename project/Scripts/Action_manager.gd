extends Node

onready var control = get_parent()

onready var monster_manager = get_node('/root/Control/MonsterManager')

func _get_action():
	var action_index = control.get_index_action()
	var monster_index = control.get_index_ally()
	var monster = monster_manager.get_selected_ally()
	var action = monster.get_action(action_index)
	
	return action

func _get_action_range():
	return _get_action().action_range



func _set_targets():
	var input_group = control.get_input_group()
	var targets_team = monster_manager.get_target_team()
	var targets = monster_manager.get_selected_action_targets()
	
	if not input_group == INPUT_GROUP.TARGET or not input_group == INPUT_GROUP.ACTION:
		targets_team = null
		targets = null
		return
		
var targets : Array
var attacker
var action
var action_range
var team
var target

func do_action():
	control.lock_inputs()
	_set_action_variables()
	_do_damage()
	_do_status_effect()
	_do_swap()
	control.reset_inputs()
	
func _do_swap():
	if not _get_action().name == 'Swap':
		return
		
	var targets_team = monster_manager.get_target_team()
		
	var index_ally = control.get_index_ally()
	var index_target = control.get_index_target()
	
	var ally = monster_manager.get_selected_ally()
	var target = monster_manager.get_target()
	
	var position_index_ally = ally.get_position_index()
	var position_index_target = target.get_position_index()
	
	ally.set_position_index(position_index_target)
	target.set_position_index(position_index_ally)
	
func _set_action_variables():
	action = _get_action()
	action_range = _get_action_range()
	
	targets.clear()
	
	if action_range == ACTION_RANGE.ALLY_ALL:
		targets = monster_manager.get_allies()
	elif action_range == ACTION_RANGE.FOE_ALL:
		targets = monster_manager.get_foes()
	else:
		var target_index = control.get_index_target()
		targets.append(monster_manager.get_target())
	
	var attacker_index = control.get_index_ally()
	attacker = monster_manager.get_selected_ally()
	
func _do_damage():
	for target in targets:
		self.target = target
		var damage = _get_damage()
		target.do_damage(damage)
		
func _do_status_effect():
	var status_effect = action.status_effect
	if status_effect != Status_effect.NULL:
		for target in targets:
			target.set_status(status_effect)
		
func _get_damage():
	var damage = action.damage
	
	if _is_type_advantage():
		damage = damage + 1
		
	if _is_position_advantage():
		damage = damage + 1
		
	return damage

func _is_position_advantage():
	if _is_action_healing():
		false
		
	var attacker_position = attacker.get_position_index()
	var target_position = target.get_position_index()
	
	if attacker_position == target_position:
		return true
		
	return false

func _is_type_advantage():
	if _is_action_healing():
		return false
	
	var action_type = action.get_type()
	var target_type_weakness = target.get_type_weakness()
	
	if action_type == target_type_weakness:
		return true
		
	return false
	
func _is_action_healing():
	if action.damage < 0:
		return true;
		
	return false

