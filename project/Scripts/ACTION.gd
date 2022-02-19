extends Node

class_name Action

var action_name
var status_effect
var action_range : int
var cost : int
var damage: int
var elemental_type
var swap = null 

func _init(
	action_name , damage : int, cost : int, status_effect, action_range : int, 
	elemental_type, swap):
	 self.action_name = action_name
	 self.status_effect = status_effect
	 self.action_range = action_range
	 self.cost = cost
	 self.damage = damage
	 self.elemental_type = elemental_type
	 self.swap = swap
