extends Node2D

var action_swap : Action
var actions : Array

onready var team_a : Array = get_node("/root/Control/TeamA").get_children()
onready var team_b : Array = get_node('/root/Control/TeamB').get_children()
onready var monster_manager = get_node("/root/Control/MonsterManager")

onready var control = get_node('/root/Control')

var action_points_max = 8
var action_points

var team_a_turn = true
var turn_has_been_reset = false

func _process(var delta):
	_manage_turns()

func _manage_turns():
	if team_a_turn and not monster_manager.is_team_a_turn_available():
		monster_manager.set_team_b_turn_available()
		team_a_turn = false
		
	if not team_a_turn and not monster_manager.is_team_b_turn_available():
		monster_manager.set_team_a_turn_available()
		team_a_turn = true
		control.reset_inputs()
		
func is_team_a_turn():
	return team_a_turn
	
func is_team_b_turn():
	return not team_a_turn

func _set_team_turn(var team):
	for monster in team:
		monster.set_turn_availabale(true)

func _end_all_ally_turns():
	for monster in team_a:
		monster.set_turn_availabale(false)

func _ready():
	_set_action_points()
	_set_actions()
	_set_monsters()
	
func set_team_a_turn(var b):
	team_a_turn = b
	
func get_team_a_turn():
	return team_a_turn
	
func _set_action_points():
	action_points = action_points_max
	
func deduct_action_points(var point):
	action_points = action_points - point
	
func get_action_points():
	return action_points
	
func _set_monsters():
	_set_teamAlly()
	_set_teamFoe()
	_assign_health()
	_assign_actions()

func _set_teamAlly():
#	teamA[0].set_namename('Mon1')
	team_a[0].set_type(ELEMENTAL_TYPE.FIRE)
	
#	teamA[1].set_name('Mon2')
	team_a[1].set_type(ELEMENTAL_TYPE.WATER)
	
#	teamA[2].set_name('Mon3')
	team_a[2].set_type(ELEMENTAL_TYPE.GRASS)
	
	for i in team_a.size():
		team_a[i].set_position_index(i)
		team_a[i].set_team(TEAM.A)
	
func _set_teamFoe():
#	teamB[0].set_name('Mon1')
	team_b[0].set_type(ELEMENTAL_TYPE.FIRE)
	
#	teamB[1].set_name('Mon2')
	team_b[1].set_type(ELEMENTAL_TYPE.WATER)
	
#	teamB[2].set_name('Mon3')
	team_b[2].set_type(ELEMENTAL_TYPE.GRASS)
	
	for i in team_b.size():
		team_b[i].set_position_index(i)
		team_b[i].set_team(TEAM.B)
		team_b[i].set_turn_availabale(false)
		
func _assign_health():
	for monster in team_a:
		monster.set_health(10)
		
	for monster in team_b:
		monster.set_health(10)

func _assign_actions():
	var action1 : Action
	var action2 : Action
	var action3 : Action
	
	var rng = RandomNumberGenerator.new()
	
	var action_left = actions.duplicate()
	
	var rand_index : int = 0
	
	for monster in team_a:
		rand_index = rng.randi_range(0, action_left.size()-1)
		action1 = action_left[rand_index]
		action_left.remove(rand_index)
	
		rand_index = rng.randi_range(0, action_left.size()-1)
		action2 = action_left[rand_index]
		action_left.remove(rand_index)
	
		rand_index = rng.randi_range(0, action_left.size()-1)
		action3 = action_left[rand_index]
		action_left.remove(rand_index)
		
		monster.set_actions(action1, action2, action3, action_swap)
		
	action_left = actions.duplicate()
	
	for monster in team_b:
		rand_index = rng.randi_range(0, action_left.size()-1)
		action1 = action_left[rand_index]
		action_left.remove(rand_index)
	
		rand_index = rng.randi_range(0, action_left.size()-1)
		action2 = action_left[rand_index]
		action_left.remove(rand_index)
	
		rand_index = rng.randi_range(0, action_left.size()-1)
		action3 = action_left[rand_index]
		action_left.remove(rand_index)
		
		monster.set_actions(action1, action2, action3, action_swap)
		
func _set_actions():
	var action
	
	action = Action.new(ACTION_NAMES.Fire_Ball, 3, 3, null, ACTION_RANGE.FOE, ELEMENTAL_TYPE.FIRE, null)
	actions.append(action)
	action = Action.new(ACTION_NAMES.Fire_Blitz, 1, 6, null, ACTION_RANGE.FOE_ALL, ELEMENTAL_TYPE.FIRE, null)
	actions.append(action)
	
	action = Action.new(ACTION_NAMES.Sticky_Sticks, 1, 3, Status_effect.PARALYZE, ACTION_RANGE.FOE, ELEMENTAL_TYPE.GRASS, null)
	actions.append(action)
	action = Action.new(ACTION_NAMES.Bamboo_Bash, 1, 3, null, ACTION_RANGE.FOE, ELEMENTAL_TYPE.GRASS, ACTION_RANGE.FOE)
	actions.append(action)
	
	action = Action.new(ACTION_NAMES.Bonfire, -1, 2, null, ACTION_RANGE.ALLY, ELEMENTAL_TYPE.FIRE, ACTION_RANGE.ALLY)
	actions.append(action)
	action = Action.new(ACTION_NAMES.Natural_Remedy, -5, 5, null, ACTION_RANGE.ALLY, ELEMENTAL_TYPE.GRASS, null)
	actions.append(action)
	action = Action.new(ACTION_NAMES.Healing_Pulse, -2, 6, null, ACTION_RANGE.ALLY_ALL, ELEMENTAL_TYPE.WATER, null)
	actions.append(action)
	
	action = Action.new(ACTION_NAMES.Icicle_Blade, 1, 3, null, ACTION_RANGE.FOE, ELEMENTAL_TYPE.WATER, null)
	actions.append(action)
	action = Action.new(ACTION_NAMES.Swift_Surf, 1, 3, null, ACTION_RANGE.FOE, ELEMENTAL_TYPE.WATER, ACTION_RANGE.ALLY)
	actions.append(action)
	
	action_swap = Action.new(ACTION_NAMES.Swap, 0, 1, null, ACTION_RANGE.ALLY, null, ACTION_RANGE.ALLY)
