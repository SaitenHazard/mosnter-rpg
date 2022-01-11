extends PanelContainer

onready var labels : Array = get_node("HBoxContainer").get_children()
onready var control = get_node('/root/Control')
onready var action_manager = get_node('/root/Control/ActionManager')

const STATUS_EFFECT =  preload('res://Scripts/Status_effect.gd')

var label_damage
var label_cost
var label_type
var label_swap
var label_status

var type_name = {
	0 : 'Null',
	1 : 'Fire',
	2 : 'Water',
	3 : 'Grass'
}

func _ready():
	label_damage = labels[0]
	label_cost = labels[1]
	label_type = labels[2]
	label_swap = labels[3]
	label_status = labels[4]


func _process(delta):
	if control.get_input_group() == INPUT_GROUP.ALLY:
		label_damage.visible = false
		label_cost.visible = false
		label_type.visible = false
		label_swap.visible = false
		label_status.visible = false
		return
		
	label_damage.visible = true
	label_cost.visible = true
	label_type.visible = true
	label_swap.visible = true
	label_status.visible = true
		
	var action = action_manager.get_selected_action()
	
	if action.damage >= 0:
		label_damage.text = "Damage: " + String(action.damage)
	else:
		label_damage.text = "Heal: " + String(action.damage * -1)
		
	label_cost.text = "Cost: " + String(action.cost)
	label_type.text = "Type: " + type_name[action.elemental_type]
	
#	print(action.cost)
#	print(action.name)
	
	if action.damage == 0:
		label_damage.visible = false
		
	if action.elemental_type == 0:
		label_type.visible = false
		
	if action.swap == null:
		label_swap.visible = false
	elif action.swap == ACTION_RANGE.ALLY:
		label_swap.text = "Swap Ally"
	else:
		label_swap.text = "Swap Foe"
		
	if action.status_effect == 0:
		label_status.visible = false
	elif action.status_effect == STATUS_EFFECT.BLEED:
		label_status.text = "Apply Bleed Status"
	else:
		label_status.text = "Apply Paralyze Status"
		
