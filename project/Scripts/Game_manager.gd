extends Node2D

class Action:
	var name : String
	var status_effect : int
	var action_range : int
	var cost : int
	var damage: int
	var elemental_type
	
	func _init(
		name : String, damage : int, cost : int, status_effect : int, action_range : int, elemental_type : int):
		 self.name = name
		 self.status_effect = status_effect
		 self.action_range = action_range
		 self.cost = cost
		 self.damage = damage
		 self.elemental_type = elemental_type
		
	func get_name() -> String:
		return name
		
	func get_damage() -> int:
		return damage
		
	func get_type():
		return elemental_type
		
	func get_cost() -> int:
		return cost
		
var action_swap : Action

#const ELEMENTAL_TYPE =  preload('res://Scripts/Elemental_type.gd')
#const ACTION_RANGE =  preload('res://Scripts/Action_range.gd')
#const STATUS_EFFECT =  preload('res://Scripts/Status_effect.gd')

var actions : Array

onready var teamA : Array = get_node("/root/Control/TeamA").get_children()
onready var teamB : Array = get_node('/root/Control/TeamB').get_children()

func _ready():
	Status_effect.BLEED
	_set_actions()
	_set_monsters()
	
func _set_monsters():
	_set_teamA()
	_set_teamB()
	_assign_health()
	_assign_actions()

func _set_teamA():
#	teamA[0].set_name('Mon1')
	teamA[0].set_type(ELEMENTAL_TYPE.FIRE)
	
#	teamA[1].set_name('Mon2')
	teamA[1].set_type(ELEMENTAL_TYPE.WATER)
	
#	teamA[2].set_name('Mon3')
	teamA[2].set_type(ELEMENTAL_TYPE.GRASS)
	
	for i in teamA.size():
		teamA[i].set_position_index(i) 
	
func _set_teamB():
#	teamB[0].set_name('Mon1')
	teamB[0].set_type(ELEMENTAL_TYPE.FIRE)
	
#	teamB[1].set_name('Mon2')
	teamB[1].set_type(ELEMENTAL_TYPE.WATER)
	
#	teamB[2].set_name('Mon3')
	teamB[2].set_type(ELEMENTAL_TYPE.GRASS)
	
	for i in teamB.size():
		teamB[i].set_position_index(i)
	
func _assign_health():
	for monster in teamA:
		monster.set_health(10)
		
	for monster in teamB:
		monster.set_health(10)

func _assign_actions():
	var action1 : Action
	var action2 : Action
	var action3 : Action
	var rand_index : int
	
	for i in teamA.size():
		rand_index = randi() % actions.size()
		action1 = actions[rand_index]
		actions.remove(rand_index)
	
		rand_index = randi() % actions.size()
		action2 = actions[rand_index]
		actions.remove(rand_index)
	
		rand_index = randi() % actions.size()
		action3 = actions[rand_index]
		actions.remove(rand_index)
		teamA[i].set_actions(action1, action2, action3, action_swap)
		
#	for monster in teamB:
#		monster.set_actions(action_set)
	
func _set_actions():
	var action
	
#	STATUS_EFFECT.NULL
	
	action = Action.new('Fire Ball', 3, 3, Status_effect.NULL, ACTION_RANGE.FOE, ELEMENTAL_TYPE.FIRE)
	actions.append(action)
	action = Action.new('Fire Blitz', 1, 6, Status_effect.NULL, ACTION_RANGE.FOE_ALL, ELEMENTAL_TYPE.FIRE)
	actions.append(action)
	
	action = Action.new('Sticky Sticks', 1, 3, Status_effect.PARALYZE, ACTION_RANGE.FOE, ELEMENTAL_TYPE.GRASS)
	actions.append(action)
	action = Action.new('Bamboo Bash', 1, 3, Status_effect.NULL, ACTION_RANGE.FOE, ELEMENTAL_TYPE.GRASS)
	actions.append(action)
	
	action = Action.new('Protect', 0, 2, Status_effect.NULL, ACTION_RANGE.ALLY, ELEMENTAL_TYPE.NULL)
	actions.append(action)
	action = Action.new('Heal', -5, 5, Status_effect.NULL, ACTION_RANGE.ALLY, ELEMENTAL_TYPE.NULL)
	actions.append(action)
	action = Action.new('Healing Wave', -2, 6, Status_effect.NULL, ACTION_RANGE.ALLY_ALL, ELEMENTAL_TYPE.NULL)
	actions.append(action)
	
	action = Action.new('Ice Punch', 1, 3, Status_effect.BLEED, ACTION_RANGE.FOE, ELEMENTAL_TYPE.WATER)
	actions.append(action)
	action = Action.new('Swift Surf', 1, 3, Status_effect.NULL, ACTION_RANGE.FOE, ELEMENTAL_TYPE.WATER)
	actions.append(action)
	
	action_swap = Action.new('Swap', 0, 1, Status_effect.NULL, ACTION_RANGE.ALLY, ELEMENTAL_TYPE.NULL)
	
#	print('in')
#	print(actions[0])
	
