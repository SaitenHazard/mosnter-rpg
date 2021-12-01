extends Node

onready var target_selection_arrows : Array = get_parent().get_node('/root/Control/TargetSelectArrows').get_children()
onready var target_arrows : Array = get_parent().get_node('/root/Control/TargetArrows').get_children()
onready var ActionManager = get_parent().get_node('ActionManager')
onready var control = get_parent()

var input_group
var input_index
var targets
var team

func _process(delta):
	_set_variables()
	_manage_target_selection_arrows()
	_manage_target_arraows()

func _set_variables():
	input_group = control.get_input_group()
	input_index = control.get_input_index()
	targets = ActionManager.get_targets()
	team = ActionManager.get_target_team()

func _manage_target_selection_arrows():
	for arrow in target_selection_arrows:
		arrow.set_visible(false)
	
	if not input_group == INPUT_GROUP.TARGET:
		return
		
	if targets.all == true:
		for i in targets.indexes:
			target_selection_arrows[i].global_position = team[i].global_position
			target_selection_arrows[i].global_position.x = target_selection_arrows[i].global_position.x + 50
			target_selection_arrows[i].set_visible(true)
		return
	
	var global_position = team[input_index].global_position
		
	target_selection_arrows[0].global_position = global_position
	target_selection_arrows[0].global_position.x = target_selection_arrows[0].global_position.x + 50
	target_selection_arrows[0].set_visible(true)

func _manage_target_arraows():
	for arrow in target_arrows:
		arrow.set_visible(false)
		
	if not input_group == INPUT_GROUP.ACTION and not input_group == INPUT_GROUP.TARGET:
		return
		
	for i in targets.indexes:
		target_arrows[i].global_position = team[i].global_position
		target_arrows[i].global_position.x = target_arrows[i].global_position.x + 50
		target_arrows[i].set_visible(true)
