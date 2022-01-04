extends Node2D

onready var team_ally = get_node('/root/Control/TeamAlly').get_children()
onready var team_foe = get_node('/root/Control/TeamFoe').get_children()

onready var control = get_node('/root/Control')
onready var action_manager = get_node('/root/Control/ActionManager')

var team_ally_positions : Array = [Vector2(290,230), Vector2(380,312), Vector2(290,420)]
var team_foe_positions : Array = [Vector2(660,230), Vector2(580,312), Vector2(660,420)]
	
func _process(var delta):
	_set_position_()

func get_target():
	var index_target = control.get_index_target()
	return get_target_team_monster(index_target)
	
func get_actioner():
	var index_ally = control.get_index_ally()
	return get_allies()[index_ally]
	
func get_target_team_monster(var index):
	var team = get_target_team()
	
	for monster in team:
		if monster.get_position_index() == index:
			return monster
			
func get_targettwo():
	var index_targettwo = control.get_index_targettwo()
	return get_action_swap_team()[index_targettwo]
			
func get_action_swap_team():
	var action = action_manager.get_selected_action()
	if action.swap == TEAM.ALLY:
		return get_allies()
	else:
		return get_foes()
		
func get_targettwo_indexes():
	var targets : Array = [0,1,2]
	var action = action_manager.get_selected_action()
	
	if action.swap == TEAM.ALLY:
		var index_ally = control.get_index_ally()
		var position_index = get_allies()[index_ally].get_position_index()
		targets.remove(index_ally)
	else:
		var index_target = control.get_index_target()
		var position_index = get_foes()[index_target].get_position_index()
		targets.remove(index_target)
		
	return targets
		
func get_action_swap_targets():
	if get_target_team() == team_ally:
		var index_ally = control.get_index_ally()
		return Targets.new(index_ally, ACTION_RANGE.ALLY, team_ally, team_foe)
	else:
		var index_target = control.get_index_target()
		return Targets.new(index_target, ACTION_RANGE.ALLY, team_ally, team_foe)
	
func get_selected_action_targets():
	var action = action_manager.get_selected_action()
	var index_ally = control.get_index_ally()
		
	return Targets.new(index_ally, action.action_range, team_ally, team_foe)
	
func get_target_team():
	var targets = get_selected_action_targets()
		
	if targets.ally:
		return get_allies()
	else:
		return get_foes()
	
func get_allies():
	return team_ally
	
func get_foes():
	return team_foe
	
func get_selected_foe():
	var index_target = control.get_index_target()
	return team_foe[index_target]
	
func get_selected_ally():
	var index_ally = control.get_index_ally()
	return get_ally(index_ally)

func get_ally(var index : int):
	for monster in team_ally:
		if monster.get_position_index() == index:
			return monster
	
func get_foe(var index : int):
	for monster in team_foe:
		if monster.get_position_index() == index:
			return monster
	
func _set_position_():
	for ally in team_ally:
		var index = ally.get_position_index()
		ally.position = team_ally_positions[index]
		
	for foe in team_foe:
		var index = foe.get_position_index()
		foe.position = team_foe_positions[index]
		
