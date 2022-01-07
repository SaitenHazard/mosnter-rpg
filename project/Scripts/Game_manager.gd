extends Node2D

class Action:
	var name : String
	var status_effect : int
	var action_range : int
	var cost : int
	var damage: int
	var elemental_type
	var swap = null 
	
	func _init(
		name : String, damage : int, cost : int, status_effect : int, action_range : int, 
		elemental_type : int, swap):
		 self.name = name
		 self.status_effect = status_effect
		 self.action_range = action_range
		 self.cost = cost
		 self.damage = damage
		 self.elemental_type = elemental_type
		 self.swap = swap

var action_swap : Action

var actions : Array

onready var game_manager = get_node("/root/Control/GameManager").get_children()
onready var teamAlly : Array = get_node("/root/Control/TeamAlly").get_children()
onready var teamFoe : Array = get_node('/root/Control/TeamFoe').get_children()
onready var control = get_node('/root/Control')

var action_points_max = 10
var action_points
var team_a_turn = true 

func _process(var delta):
	_manage_turns()
	
func _manage_turns():
	for monster in teamAlly:
		if monster.get_turn_available():
			team_a_turn = true
			return
	
	control.lock_inputs()
	team_a_turn = false
	
func _end_all_ally_turns():
	for monster in teamAlly:
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
#	teamA[0].set_name('Mon1')
	teamAlly[0].set_type(ELEMENTAL_TYPE.FIRE)
	
#	teamA[1].set_name('Mon2')
	teamAlly[1].set_type(ELEMENTAL_TYPE.WATER)
	
#	teamA[2].set_name('Mon3')
	teamAlly[2].set_type(ELEMENTAL_TYPE.GRASS)
	
	for i in teamAlly.size():
		teamAlly[i].set_position_index(i)
		teamAlly[i].set_team(TEAM.ALLY)
	
func _set_teamFoe():
#	teamB[0].set_name('Mon1')
	teamFoe[0].set_type(ELEMENTAL_TYPE.FIRE)
	
#	teamB[1].set_name('Mon2')
	teamFoe[1].set_type(ELEMENTAL_TYPE.WATER)
	
#	teamB[2].set_name('Mon3')
	teamFoe[2].set_type(ELEMENTAL_TYPE.GRASS)
	
	for i in teamFoe.size():
		teamFoe[i].set_position_index(i)
		teamFoe[i].set_team(TEAM.FOE)
		
func _assign_health():
	for monster in teamAlly:
		monster.set_health(10)
		
	for monster in teamFoe:
		monster.set_health(10)

func _assign_actions():
	var action1 : Action
	var action2 : Action
	var action3 : Action
	var rand_index : int
	
	for i in teamAlly.size():
		rand_index = randi() % actions.size()
		action1 = actions[rand_index]
		actions.remove(rand_index)
	
		rand_index = randi() % actions.size()
		action2 = actions[rand_index]
		actions.remove(rand_index)
	
		rand_index = randi() % actions.size()
		action3 = actions[rand_index]
		actions.remove(rand_index)
		teamAlly[i].set_actions(action1, action2, action3, action_swap)
		
func _set_actions():
	var action
	
	action = Action.new('Fire Ball', 3, 3, Status_effect.NULL, ACTION_RANGE.FOE, ELEMENTAL_TYPE.FIRE, null)
	actions.append(action)
	action = Action.new('Fire Blitz', 1, 6, Status_effect.NULL, ACTION_RANGE.FOE_ALL, ELEMENTAL_TYPE.FIRE, null)
	actions.append(action)
	
	action = Action.new('Sticky Sticks', 1, 3, Status_effect.PARALYZE, ACTION_RANGE.FOE, ELEMENTAL_TYPE.GRASS, null)
	actions.append(action)
	action = Action.new('Bamboo Bash', 1, 3, Status_effect.NULL, ACTION_RANGE.FOE, ELEMENTAL_TYPE.GRASS, TEAM.FOE)
	actions.append(action)
	
	action = Action.new('Bonfire', -1, 2, Status_effect.NULL, ACTION_RANGE.ALLY, ELEMENTAL_TYPE.FIRE, TEAM.ALLY)
	actions.append(action)
	action = Action.new('Natural Remedy', -5, 5, Status_effect.NULL, ACTION_RANGE.ALLY, ELEMENTAL_TYPE.GRASS, null)
	actions.append(action)
	action = Action.new('Healing Pulse', -2, 6, Status_effect.NULL, ACTION_RANGE.ALLY_ALL, ELEMENTAL_TYPE.WATER, null)
	actions.append(action)
	
	action = Action.new('Icicle Blade', 1, 3, Status_effect.BLEED, ACTION_RANGE.FOE, ELEMENTAL_TYPE.WATER, null)
	actions.append(action)
	action = Action.new('Swift Surf', 1, 3, Status_effect.NULL, ACTION_RANGE.FOE, ELEMENTAL_TYPE.WATER, TEAM.ALLY)
	actions.append(action)
	
	action_swap = Action.new('Swap', 0, 1, Status_effect.NULL, ACTION_RANGE.ALLY, ELEMENTAL_TYPE.NULL, TEAM.ALLY)
