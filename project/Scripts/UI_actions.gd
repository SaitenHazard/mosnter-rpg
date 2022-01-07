extends VBoxContainer

onready var panel_controllers : Array = get_children() 
onready var control = get_node('/root/Control')

onready var action_manager = get_node('/root/Control/ActionManager')
onready var game_manager = get_node('/root/Control/GameManager')

var b = false

func _process(delta):
	_set_texts()
	
func _set_texts():
	if not game_manager.get_team_a_turn():
		for i in 4:
			panel_controllers[i].get_child(0).visible = false
			
		return
	
	var index : int = control.get_index_ally()
	var actions : Array = action_manager.get_selected_ally_actions()

	for i in 4:
		panel_controllers[i].get_child(0).text = actions[i].name
		panel_controllers[i].get_child(0).visible = true
