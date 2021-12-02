extends Node

onready var control = get_parent()

onready var teamA : Array = get_node('/root/Control/TeamA').get_children()
onready var teamB : Array = get_node('/root/Control/TeamB').get_children()

func _get_action():
	var action_index = control.get_action_index()
	var monster_index = control.get_monster_index()
	var monster = teamA[monster_index]
	var action = monster.get_action(action_index)
	
	return action

func _get_action_range():
	return _get_action().action_range

func get_targets():
	var monster_index = control.get_monster_index()
	var action_range = _get_action_range();
	var targets = Targets.new(monster_index, action_range, teamA, teamB)
	
	return targets

func _set_targets():
	var input_group = control.get_input_group()
	var targets_team = get_target_team()
	var targets = get_targets()
	
	if not input_group == INPUT_GROUP.TARGET or not input_group == INPUT_GROUP.ACTION:
		targets_team = null
		targets = null
		return

func get_target_team():
	var targets = get_targets()
	
	if targets.ally:
		return teamA
	else:
		return teamB
		
var target
var attacker
var action
var targets

func do_action():
	_set_action_variables()
	_do_damage()
	control.reset_and_unlock_inputs()
	
func _set_action_variables():
	action = _get_action()
	
	var target_index = control.get_input_index() 
	target = teamB[target_index]
	
	var attacker_index = control.get_monster_index()
	attacker = teamA[attacker_index]
	
func _do_damage():
	var damage = _get_damage()
	target.do_damage(damage)

func _get_damage():
	var damage = action.damage
	
	if _is_type_advantage():
		damage = damage + 1
		
	if _is_position_advantage():
		damage = damage + 1
		
	return damage

func _is_position_advantage():
	var attacker_position = attacker.get_position_index()
	var target_position = target.get_position_index()
	
	if attacker_position == target_position:
		return true
		
	return false

func _is_type_advantage():
	var action_type = action.get_type()
	var target_type_weakness = target.get_type_weakness()
	
	if action_type == target_type_weakness:
		return true
		
	return false
