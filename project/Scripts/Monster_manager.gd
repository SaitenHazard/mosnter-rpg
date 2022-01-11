extends Node2D

onready var team_a = get_node('/root/Control/TeamA').get_children()
onready var team_b = get_node('/root/Control/TeamB').get_children()

onready var control = get_node('/root/Control')
onready var action_manager = get_node('/root/Control/ActionManager')

var team_a_positions : Array = [Vector2(290,230), Vector2(380,312), Vector2(290,420)]
var team_b_positions : Array = [Vector2(660,230), Vector2(580,312), Vector2(660,420)]
	
func _process(var delta):
	_set_position_()

func get_target():
	var index_target = control.get_index_target()
	var team =  get_target_team()
	return get_monster(team, index_target)
	
func get_user():
	var index_ally = control.get_index_ally()
	return get_monster(get_team_a(), index_ally)
			
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
		return get_team_a()
	else:
		return get_team_b()
		
func get_action_target_team(var action, var user):
	if action.action_range == ACTION_RANGE.ALLY or ACTION_RANGE.ALLY_ALL:
		if user.get_team() == TEAM.A:
			return get_team_a()
		else:
			return get_team_b()
	else:
		if user.get_team() == TEAM.A:
			return get_team_b()
		else:
			return get_team_a()
			
func get_action_target_team_monster(var action, var user):
	var team = get_action_target_team(action, user)
	var index = user.get_index()
	return get_monster(team, index)
		
func get_targettwo_indexes():
	var targets : Array = [0,1,2]
	var action = action_manager.get_selected_action()
	
	if action.swap == ACTION_RANGE.ALLY:
		var index_ally = control.get_index_ally()
		var position_index = get_team_a()[index_ally].get_position_index()
		targets.remove(index_ally)
	else:
		var index_target = control.get_index_target()
		var position_index = get_team_b()[index_target].get_position_index()
		targets.remove(index_target)
		
	return targets
		
func get_action_swap_targets():
	if get_target_team() == team_a:
		var index_ally = control.get_index_ally()
		return Targets.new(index_ally, ACTION_RANGE.ALLY, team_a, team_b)
	else:
		var index_target = control.get_index_target()
		return Targets.new(index_target, ACTION_RANGE.ALLY, team_a, team_b)
		
func get_action_swap_target_to():
	var team = get_action_swap_team()
	var index = control.get_index_targettwo()
	return get_monster(team, index)
	
func get_target_team():
	var targets = get_selected_action_targets()
		
	if targets.ally:
		return get_team_a()
	else:
		return get_team_b()
	
func get_team_a():
	return team_a
	
func get_team_b():
	return team_b
	
func get_selected_b():
	var index_target = control.get_index_target()
	return team_b[index_target]
	
func get_selected_ally():
	var index_ally = control.get_index_ally()
	var ally = get_team_a()
	var monster = get_monster(ally ,index_ally)
	return monster
	
func get_monster(var team, var index):
	for monster in team:
		if monster.get_position_index() == index:
			return monster

func get_team_a_monster(var index : int):
	return get_monster(team_a, index)
	
func get_team_b_monster(var index : int):
	return get_monster(team_b, index)
	
func _set_position_():
	for monster in team_a:
		var index = monster.get_position_index()
		monster.position = team_a_positions[index]
		
	for monster in team_b:
		var index = monster.get_position_index()
		monster.position = team_b_positions[index]
		
func get_selected_action_targets():
	var team_user = get_team_a()
		
	var team_target = get_team_b()
	
	var action = action_manager.get_selected_action()
	var index_ally = control.get_index_ally()
	
	return get_targets(index_ally, team_user,  team_target, action)
	
func get_targets(user_idnex, team_user, team_target, action):
	return Targets.new(user_idnex, action.action_range, team_user, team_target)
	
func get_team_a_monsters_with_turn_remaining():
	return get_team_monsters_with_turn_remaining(get_team_a())
		
func get_team_b_monsters_with_turn_remaining():
	return get_team_monsters_with_turn_remaining(get_team_b())
	
func get_team_monsters_with_turn_remaining(var team):
	var turn_remaining_monsters : Array
	
	for monster in team:
		if monster.is_turn_available():
			turn_remaining_monsters.append(monster)
			
	return turn_remaining_monsters
	
