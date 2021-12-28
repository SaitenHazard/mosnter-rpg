extends PanelContainer

onready var labels : Array = get_node("HBoxContainer").get_children()
onready var control = get_node('/root/Control')
onready var monsters : Array = get_node('/root/Control/TeamA').get_children()

const STATUS_EFFECT =  preload('res://Scripts/Status_effect.gd')

var type_name = {
	0 : 'Fire',
	1 : 'Water',
	2 : 'Grass',
	3 : 'None'
}

func _process(delta):
	return
	var action_index = control.get_action_index()
	
	if action_index == -1:
		return
		
	var monster_index = control.get_monster_index()
	
	var action = monsters[monster_index].get_action(action_index)
	
#	labels[0] = "DAMAGE " + String(action.get_damage());
#	labels[1] = "COST " + String(action.get_cost());
#	labels[2] = "TYPE " + String(action.get_type());
	
#	print(action.get_type())
	
	if action.get_damage() >= 0:
		labels[0].text = "DAMAGE: " + String(action.get_damage())
	else:
		labels[0].text = "HEAL: " + String(action.get_damage() * -1)
		
	labels[1].text = "COST: " + String(action.get_cost());
	labels[2].text = "TYPE: " + type_name[action.get_type()];
	
