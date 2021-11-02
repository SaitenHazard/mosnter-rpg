extends Node2D

class My_Class:
	 var a : int
	 var b : int
	 func _init(b, a):
		 self.b = b
		 self.a = a

class Status_effect:
	var name : String
	var turns : int
	func _init(name : String, turns : int):
		self.name = name
		self.turns = turns

class Action:
	var name : String
	var status_effect : Status_effect
	var _range : String
	var cost : int
	var damage: int
	var elemental_type
	
	func _init(
		name : String, status_effect : Status_effect, _range : String, cost : int, 
		damage : int, elemental_type):
		 self.name = name
		 self.status_effect = status_effect
		 self._range = _range
		 self.cost = cost
		 self.damage = damage

enum elemental_type {fire, water, grass, none}

var actions : Array
var status_effects : Array

onready var teamA : Array = get_node("/root/Control/TeamA").get_children()
onready var teamB : Array = get_node('/root/Control/TeamB').get_children()

enum action_set {action1, action2, action3, action4}

func _ready():
	_set_status_effects()
	_set_actions()
	_set_monsters()
	
	
func _set_monsters():
	_set_teamA()
	_set_teamB()
	_assign_health()
	_assign_actions()

func _set_teamA():
	teamA[0].set_name('Mon1')
	teamA[0].set_type(elemental_type.fire)
	
	teamA[1].set_name('Mon2')
	teamA[1].set_type(elemental_type.water)
	
	teamA[2].set_name('Mon3')
	teamA[2].set_type(elemental_type.grass)
	
func _set_teamB():
	teamB[0].set_name('Mon1')
	teamB[0].set_type(elemental_type.fire)
	
	teamB[1].set_name('Mon2')
	teamB[1].set_type(elemental_type.water)
	
	teamB[2].set_name('Mon3')
	teamB[2].set_type(elemental_type.grass)
	
func _assign_health():
	for monster in teamA:
		monster.set_health(10)
		
	for monster in teamB:
		monster.set_health(10)

func _assign_actions():
	action_set.action1 = actions[0]
	action_set.action2 = actions[0]
	action_set.action3 = actions[0]
	action_set.action4 = actions[0]
	
	for monster in teamA:
		monster.set_actions(action_set)
		
	for monster in teamB:
		monster.set_actions(action_set)
	
func _set_status_effects():
	var status_effect = Status_effect.new('null', 0)
	status_effects.append(status_effect)
	
func _set_actions():
	var action = Action.new('Fire Ball', status_effects[0], 'adjacent_foe', 3, 3, elemental_type.fire)
	
	actions.append(action)
