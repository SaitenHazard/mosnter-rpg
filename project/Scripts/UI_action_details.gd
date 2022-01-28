extends PanelContainer

onready var labels : Array = get_node("HBoxContainer").get_children()
onready var control = get_node('/root/Control')
onready var action_manager = get_node('/root/Control/ActionManager')
onready var game_manager = get_node('/root/Control/GameManager')
onready var ai = get_node('/root/Control/AI')

const STATUS_EFFECT =  preload('res://Scripts/Status_effect.gd')

var label_damage
var label_cost
var label_type
var label_swap
var label_status

var type_name = {
	0 : 'Fire',
	1 : 'Water',
	2 : 'Grass'
}

func _ready():
	label_damage = labels[0]
	label_cost = labels[1]
	label_type = labels[2]
	label_swap = labels[3]
	label_status = labels[4]

func _process(delta):
	label_damage.visible = false
	label_cost.visible = false
	label_type.visible = false
	label_swap.visible = false
	label_status.visible = false
	
	_set_team_a()
	_set_team_b()
		
func _set_team_a():
	if not game_manager.get_team_a_turn():
		return
		
	if control.get_input_group() == INPUT_GROUP.ALLY:
		return
		
	label_damage.visible = true
	label_cost.visible = true
	label_swap.visible = true
	label_status.visible = true
		
	var action = action_manager.get_selected_action()
	
	if action.damage >= 0:
		label_damage.text = "Damage: " + String(action.damage)
	else:
		label_damage.text = "Heal: " + String(action.damage * -1)
		
	label_cost.text = "Cost: " + String(action.cost)
	
	if not action.elemental_type == null:
		label_type.visible = true
		label_type.text = "Type: " + type_name[action.elemental_type]
	
	if action.damage == 0:
		label_damage.visible = false
		
	if action.elemental_type == 0:
		label_type.visible = false
		
	if action.swap == null:
		label_swap.visible = false
	elif action.swap == ACTION_RANGE.ALLY:
		label_swap.text = "Swap with Ally"
	else:
		label_swap.text = "Force Swap Foe"
		
	if action.status_effect == 0:
		label_status.visible = false
	elif action.status_effect == STATUS_EFFECT.BLEED:
		label_status.text = "Apply Bleed Status"
	else:
		label_status.text = "Apply Paralyze Status"
		
	
func _set_team_b():
	if game_manager.get_team_a_turn():
		return

	label_damage.visible = true

	var ai_action_user_target = ai.get_ai_action_user_target()

	var action_name = ai_action_user_target.action.name
	var user_name = ai_action_user_target.user.name
	var target_name = ai_action_user_target.targets[0].name

	var text = user_name + ' used ' + action_name;

	if ai_action_user_target.targets.size() == 1:
		text = text + ' on ' + target_name;
		
	label_damage.text = text
