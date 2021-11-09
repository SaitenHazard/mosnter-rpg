extends VBoxContainer

onready var panel_controllers : Array = get_children() 

onready var monsters : Array = get_node('/root/Control/TeamA').get_children()

onready var control = get_node('/root/Control')

var b = false

func _process(delta):
	_set_texts()

func _set_texts():
	var index : int = control.get_monster_index()
	var actions : Array = monsters[index].get_actions()
	
	for i in 4:
		panel_controllers[i].get_child(0).text = actions[i].get_name()
