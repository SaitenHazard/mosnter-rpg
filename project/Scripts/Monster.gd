extends Node2D

var health_max : int
var health : int
var type_weakness
var position_index : int

var actions : Array

func get_position_index() -> int:
	return position_index
	
func set_position_index(position_index):
	self.position_index = position_index

func get_type_weakness():
	return type_weakness

func set_type(type_weakness):
	self.type_weakness = type_weakness
	
func set_health(health : int):
	self.health_max = health
	self.health = health
	
func set_actions(action1, action2, action3, action4):
	actions = [action1, action2, action3, action4]
	
func get_health_max() -> int :
	return health_max
	
func get_health() -> int :
	return health
	
func get_actions() -> Array :
	return actions
	
func get_action(i : int) :
	return actions[i]
	
func do_damage(var damage : int):
	health = health - damage 
