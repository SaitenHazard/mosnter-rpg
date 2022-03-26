extends VBoxContainer

onready var panel_controllers : Array = get_children() 
onready var control = get_node('/root/Control')

onready var action_manager = get_node('/root/Control/ActionManager')
onready var game_manager = get_node('/root/Control/GameManager')

onready var style_selected = load("res://styles/ActionsSelected.tres")
onready var style_unselected = load("res://styles/ActionsNotSelected.tres")

var action_texts : Array

var b = false

func _process(delta):
	action_texts.append(panel_controllers[0].get_child(0))
	action_texts.append(panel_controllers[1].get_child(0))
	action_texts.append(panel_controllers[2].get_child(0))
	action_texts.append(panel_controllers[3].get_child(0))
	action_texts.append(panel_controllers[4].get_child(0))
	
#	action_texts[0] = panel_controllers[0].get_child(0)
#	action_texts[1] = panel_controllers[1].get_child(0)
#	action_texts[2] = panel_controllers[2].get_child(0)
#	action_texts[3] = panel_controllers[3].get_child(0)
#	action_texts[4] = panel_controllers[7].get_child(0)
	
	for action_text in action_texts:
		action_text.visible = false
		
	_set_team_a()
#	_set_stylebox()

func get_action_name(var action_name):
	if action_name == ACTION_NAMES.Fire_Ball:
		return 'Fire Ball'
		
	if action_name == ACTION_NAMES.Fire_Blitz:
		return 'Fire Blitz'
		
	if action_name == ACTION_NAMES.Sticky_Seeds:
		return 'Sticky Seeds'
		
	if action_name == ACTION_NAMES.Bamboo_Bash:
		return 'Bamboo Bash'
		
	if action_name == ACTION_NAMES.Bonfire:
		return 'Bonfire'
		
	if action_name == ACTION_NAMES.Natural_Remedy:
		return 'Natural Remedy'
		
	if action_name == ACTION_NAMES.Healing_Pulse:
		return 'Healing Pulse'
		
	if action_name == ACTION_NAMES.Icicle_Drop:
		return 'Icicle Drop'
		
	if action_name == ACTION_NAMES.Swift_Surf:
		return 'Swift Surf'
		
	if action_name == ACTION_NAMES.Swap:
		return 'Swap'
		
	if action_name == ACTION_NAMES.Skip:
		return 'Skip'

func _set_team_a():
	self.visible = false
	if game_manager.is_team_b_turn():
		return
		
	if control.get_lock_inputs():
		return

	self.visible = true
	var index : int = control.get_index_ally()
	var actions : Array = action_manager.get_selected_ally_actions()

	for i in 5:
		action_texts[i].text = get_action_name(actions[i].action_name)
		action_texts[i].visible = true
		
#func _set_stylebox():
#	for panel_controller in panel_controllers:
#		panel_controller.visible = false
#
#	var input_group = control.get_input_group()
#
#	for panel_controller in panel_controllers:
#		panel_controller.set('custom_styles/panel', style_unselected)
#		panel_controller.visible = true
#
#	if input_group == INPUT_GROUP.ALLY:
#		return
#
#	if not game_manager.is_team_a_turn():
#		return
#
#	var index_action = control.get_index_action()
#	panel_controllers[index_action].set('custom_styles/panel', style_selected)
