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
		
func do_action():
#	var action = _get_action()
	_do_damage()
	
func _do_damage():
	var target_index = control.get_input_index() 
	var target = teamB[target_index]
	
	var attacker_index = control.get_monster_index()
	var attacker = teamA[attacker_index]
	
	var action = _get_action()
	
	var damage = _get_damage(action, target, attacker)
	
	target.do_damage(damage)

func _get_damage(var action, var target, var attacker):
	var damage = action.damage
	
	if _is_type_advantage(action.get_type(), target.get_type_weakness()):
		damage = damage + 1
		
	if _is_position_advantage(attacker.get_position_index(), target.get_position_index()):
		damage = damage + 1
		
	return damage

func _is_position_advantage(var attacker_position, var target_position):
	if attacker_position == target_position:
		return true
	return false

func _is_type_advantage(var action_type, var target_type_weakness):
	if action_type == target_type_weakness:
		return true
		
	return false
