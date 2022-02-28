extends PanelContainer

onready var labels : Array = get_node("HBoxContainer").get_children()
onready var control = get_node('/root/Control')
onready var action_manager = get_node('/root/ActionManager')

var label_name
var label_type
var label_status_one
var label_status_two
	
func _ready():
	label_name = labels[0]
	label_type = labels[1]
	label_status_one = labels[2]
	label_status_two = labels[3]

func _process(delta):
	var input_group = control.get_input_group()
	
	if input_group == INPUT_GROUP.ALLY:
		pass
	
	if input_group == INPUT_GROUP.TARGETTWO:
		return
		
	var action = action_manager.get_selected_action()
	
	if action.all == true:
		return
		
	if input_group == INPUT_GROUP.TARGET:
		pass
		
func _target_two(var monster):
	pass
