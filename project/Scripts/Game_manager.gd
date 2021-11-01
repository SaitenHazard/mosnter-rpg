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
		
#	func _init(name : String):
#		self.name = name

class Action:
	var name : String
	var status_effect : Status_effect
	var _range : String
	var cost : int
	var damage: int
	func _init(
		name : String, status_effect : Status_effect, _range : String, cost : int, damage : int):
		 self.name = name
		 self.status_effect = status_effect
		 self._range = _range
		 self.cost = cost
		 self.damage = damage

class Monster:
	var name : String
	var health_max : int
	var health_current : int
	var Action1 : Action
	var Action2 : Action
	var Action3 : Action
	var Action4 : Action
	
	func _init(name : String, health_max: int, Action1 : Action, Action2 : Action, Action3: Action, Action4: Action):
		self.name = name
		self.health_max = health_max
		self.health_current = health_max

var Actions
var status_effects
var TeamA
var TeamB

var x = My_Class.new(8,8)

func _ready():
	_set_status_effects()
#	_set_actions()
#	_set_monsters()
#	_assign_actions()
	
func _set_monsters():
	var Monster = Monster.new('Mon1', 25, Actions[0], Actions[0], Actions[0], Actions[0])
	TeamA.Append(Monster)
	TeamA.Append(Monster)
	TeamA.Append(Monster)
	TeamB.Append(Monster)
	TeamB.Append(Monster)
	TeamB.Append(Monster)
	
func _assign_actions():
	pass
	
func _set_status_effects():
	var status_effect = Status_effect.new('null', 0)
	status_effects.append(Status_effect)
	
func _set_actions():
	var Action = Action.new('Fire Ball', status_effects[0], 'adjacent_foe', 3, 3)
	Actions.append(Action)
