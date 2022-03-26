extends Node2D

onready var monsters_team_a = get_node('/root/Control/TeamA').get_children()
onready var monsters_team_b = get_node('/root/Control/TeamB').get_children()

onready var control = get_node('/root/Control')
onready var action_manager = get_node('/root/Control/ActionManager')
onready var action_animations = get_node('/root/Control/ActionAnimation')

var team_a_positions : Array = [Vector2(290,230), Vector2(380,312), Vector2(290,420)]
var team_b_positions : Array = [Vector2(720,230), Vector2(640,310), Vector2(720,410)]
	
func _process(var delta):
	_set_position_()
	
func _initiate_turn_team_a():
	for monster in monsters_team_a:
		monster.initiate_turn()
	
#func set_team_a_turn_available():
#	set_team_turn_available(team_a)
#
#func set_team_b_turn_available():
#	set_team_turn_available(team_b)
	
func manage_forced_pos_change(var team):
	var solo_survivor : Monster
	
	if team == TEAM.A:
		solo_survivor = _get_solo_survivor_teamA()
	else:
		solo_survivor = _get_solo_survivaor_teamB()
		
	if solo_survivor == null:
		return false
		
#	print(solo_survivor.get_health())
		
	if solo_survivor.get_position_index() == 1:
		return false
		
	yield(get_tree().create_timer(1.5), "timeout")
	
	if team == TEAM.A:
		_force_swap_team_a(solo_survivor)
	else:
		_force_swap_team_b(solo_survivor)
		
	return true
		
func _force_swap_team_a(var survivor : Monster):
	var center_mon : Monster = _get_center_monster_team_a()
	force_swap(survivor, center_mon)
	
func _force_swap_team_b(var survivor : Monster):
	var center_mon : Monster = _get_center_monster_team_b()
	force_swap(survivor, center_mon)
	
func force_swap(var survivor, var center_mon):
	var position_index_swap_one = survivor.get_position_index()
	var position_index_swap_two = center_mon.get_position_index()
	
	action_animations.do_swap_animations(survivor, center_mon)
	
	survivor.set_position_index(position_index_swap_two)
	center_mon.set_position_index(position_index_swap_one)
	
func _get_center_monster_team_a():
	return get_monster(monsters_team_a, 1)
	
func _get_center_monster_team_b():
	return get_monster(monsters_team_b, 1)
	
func only_one_survivor_teamB():
	if _get_solo_survivaor_teamB() == null:
		return false
	else:
		return true
	
func only_one_survivor_teamA():
	if _get_solo_survivor_teamA() == null:
		return false
	else:
		return true
		
func _get_solo_survivor_teamA():
	return _get_solo_survivor(monsters_team_a)
	
func _get_solo_survivaor_teamB():
	return _get_solo_survivor(monsters_team_b)
	
func _get_solo_survivor(var team):
	var survivor : Monster
	var number_of_survivors : int = 0
	
	for monster in team:
		if monster.health > 0:
			survivor = monster
			number_of_survivors = number_of_survivors + 1
	
	if number_of_survivors == 1:
		return survivor
	else:
		return null
	
func set_team_turn_available(team):
	for monster in team:
		monster.set_turn_availabale(true)

func is_team_a_turn_available():
	return _is_team_turn_available(monsters_team_a)
	
func is_team_b_turn_available():
	return _is_team_turn_available(monsters_team_b)
	
func _is_team_turn_available(var team):
	for monster in team:
		if monster.is_turn_available():
			return true
			
	return false

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
	
	if action.swap == ACTION_RANGE.ALLY:
		return get_team_a()
	else:
		return get_team_b()
		
func get_action_target_team(var action, var user):
	if action.action_range == ACTION_RANGE.ALLY or action.action_range == ACTION_RANGE.ALLY_ALL:
		if user.get_team() == TEAM.B:
			return get_team_b()
		else:
			return get_team_a()
	else:
		if user.get_team() == TEAM.B:
			return get_team_a()
		else:
			return get_team_b()
			
func get_action_target_team_monster(var action, var user, var index):
	var team = get_action_target_team(action, user)
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
	if get_target_team() == monsters_team_a:
		var index_ally = control.get_index_ally()
		return Targets.new(
			index_ally, ACTION_RANGE.ALLY, monsters_team_a, monsters_team_b)
	else:
		var index_target = control.get_index_target()
		return Targets.new(
			index_target, ACTION_RANGE.ALLY, monsters_team_a, monsters_team_b)
		
func get_action_swap_target_to():
	var team = get_action_swap_team()
	var index = control.get_index_targettwo()
	
	return get_monster(team, index)
	
func get_target_team():
	var targets = get_selected_action_targets()
		
	if targets.team_a:
		return get_team_a()
	else:
		return get_team_b()
	
func get_team_a():
	return monsters_team_a
	
func get_team_b():
	return monsters_team_b
	
func get_selected_b():
	var index_target = control.get_index_target()
	return monsters_team_b[index_target]
	
func get_selected_team_a():
	var index_ally = control.get_index_ally()
	var ally = get_team_a_monster(index_ally)
	return ally
	
func get_monster(var team, var index):
	for monster in team:
		if monster.get_position_index() == index:
			return monster

func get_team_a_monster(var index : int):
	return get_monster(monsters_team_a, index)
	
func get_team_b_monster(var index : int):
	return get_monster(monsters_team_b, index)
	
func _set_position_():
	for monster in monsters_team_a:
		var index = monster.get_position_index()
		monster.position = team_a_positions[index]
		
	for monster in monsters_team_b:
		var index = monster.get_position_index()
		monster.position = team_b_positions[index]
		
func get_selected_action_targets():
	var action = action_manager.get_selected_action()
	var user = get_selected_team_a()
	
	return get_targets(user, action)
	
func get_targets(user, action):
	var team_target = get_action_target_team(action, user)
	return Targets.new(user.get_position_index(), action.action_range, user, team_target)
	
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
	
func get_target_team_lowest_hp(action, user):
	var team = get_action_target_team(action, user)
	return get_lowest_hp(team)
	
func get_lowest_hp_a():
	return get_lowest_hp(get_team_a())

func get_lowest_hp_b():
	return get_lowest_hp(get_team_b())

func get_lowest_hp(var team):
	var monster_one = team[0]
	var monster_two = team[1]
	var monster_three = team[2]

	if monster_one.health < monster_two.health and monster_one.health < monster_three.health:
		return monster_one

	if monster_two.health < monster_one.health and monster_two.health < monster_three.health:
		return monster_two

	if monster_three.health < monster_one.health and monster_three.health < monster_two.health:
		return monster_three

	return null
	
