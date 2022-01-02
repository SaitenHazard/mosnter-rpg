extends VBoxContainer

onready var panel_controllers : Array = get_children() 
onready var control = get_node('/root/Control')

onready var monster_manager = get_node('/root/Control/MonsterManager')

var b = false

func _process(delta):
	_set_texts()
	
func _set_texts():
	var index : int = control.get_index_ally()
	var actions : Array = monster_manager.get_selected_ally_actions()

	for i in 4:
		panel_controllers[i].get_child(0).text = actions[i].get_name()
