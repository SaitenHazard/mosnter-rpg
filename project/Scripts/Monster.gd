extends Node2D

var health_max : int
var health_current : int

enum actions {action1, action2, action3, action4}

var type_weakness

func set_name(name : String):
	self.name = name
	return 0
	
func set_type(type_weakness):
	self.type_weakness = type_weakness
	
func set_health(health : int):
	self.health_max = health
	self.health_current = health
	
func set_actions(actions):
	actions = actions
	
func get_health_max() -> int :
	return health_max
	
func get_health_current() -> int :
	return health_current
