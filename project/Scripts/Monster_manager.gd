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
#	print(get_target_team_monster(index_target))
	return get_target_team_monster(index_target)
	
func get_target_team_monster(var index):
	var team = get_target_team()
	
	for monster in team:
		if monster.get_position_index() == index:
			return monster
	
func get_selected_action_targets():
	var action = action_manager.get_selected_action()
	var index_ally = control.get_index_ally()
		
	return Targets.new(index_ally, action.action_range, team_ally, team_foe)
	
func get_target_team():
	var targets = get_selected_action_targets()
	
#	if targets == null:
#		return
	
#	print(targets.ally)
		
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
#		if ally.name == 'Ally1':
#			print(ally.position)
#			print(team_ally_positions[index])
		ally.position = team_ally_positions[index]
		
	for foe in team_foe:
#		if foe.name == 'Ally1':
#			print('in')
		var index = foe.get_position_index()
		foe.position = team_foe_positions[index]
		
