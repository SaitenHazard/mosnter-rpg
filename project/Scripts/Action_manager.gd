extends Node

onready var control = get_parent()

onready var teamA : Array = get_node('/root/Control/TeamA').get_children()
onready var teamB : Array = get_node('/root/Control/TeamB').get_children()

func _get_action():
	var action_index = control.get_index_action()
	var monster_index = control.get_index_ally()
	var monster = teamA[monster_index]
	var action = monster.get_action(action_index)
	
	return action

func _get_action_range():
	return _get_action().action_range

func get_candidate_targets():
	var ally_index = control.get_index_ally()
	var action_range = _get_action_range();
	var targets = Targets.new(ally_index, action_range, teamA, teamB)
	
	return targets

func _set_targets():
	var input_group = control.get_input_group()
	var targets_team = get_target_team()
	var targets = get_candidate_targets()
	
	if not input_group == INPUT_GROUP.TARGET or not input_group == INPUT_GROUP.ACTION:
		targets_team = null
		targets = null
		return

func get_target_team():
	var targets = get_candidate_targets()
	
	if targets.ally:
		return teamA
	else:
		return teamB
		
var targets : Array
var attacker
var action
var action_range
var team
var target

func do_action():
	return
	_set_action_variables()
	_do_damage()
	_do_status_effect()
	control.reset_and_unlock_inputs()
	
func _set_action_variables():
	return
	action = _get_action()
	action_range = _get_action_range()
	
	if action_range == ACTION_RANGE.ALLY_ALL:
		targets.append(teamA[0])
		targets.append(teamA[1])
		targets.append(teamA[2])
	elif action_range == ACTION_RANGE.FOE_ALL:
		targets.append(teamB[0])
		targets.append(teamB[1])
		targets.append(teamB[2])
	else:
		var target_index = control.get_input_index()
		targets.append(teamB[target_index])
	
	var attacker_index = control.get_monster_index()
	attacker = teamA[attacker_index]
	
func _do_damage():
	for target in targets:
		self.target = target
		var damage = _get_damage()
		target.do_damage(damage)
		
func _do_status_effect():
	return
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

