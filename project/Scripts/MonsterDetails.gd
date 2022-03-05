extends HBoxContainer

onready var labels : Array = get_children()
onready var control = get_node('/root/Control')
onready var action_manager = get_node('/root/ActionManager')
onready var monster_manager = get_node('/root/Control/MonsterManager')
onready var game_manager = get_node('/root/Control/GameManager')

var label_name
var label_type
var label_status_one
var label_status_two

var type_name = {
	0 : 'Fire',
	1 : 'Water',
	2 : 'Grass'
}
	
func _ready():
	label_name = labels[0]
	label_type = labels[1]
	label_status_one = labels[2]
	label_status_two = labels[3]

func _process(delta):
	if not game_manager.is_team_a_turn():
		return
	
	if control.get_lock_inputs():
		return
	
	var input_group = control.get_input_group()
	
	if input_group == INPUT_GROUP.TARGETTWO:
		var monster = monster_manager.get_action_swap_target_to()
		_set_details(monster)
		return
		
	if input_group == INPUT_GROUP.TARGET:
		var targets = monster_manager.get_selected_action_targets()
		if targets.all == null:
			return
			
		var monster = monster_manager.get_target()
		_set_details(monster)
		return
		
	if input_group == INPUT_GROUP.ALLY:
		var monster = monster_manager.get_selected_team_a()
		_set_details(monster)
		return
		
func _set_details(var monster):
	label_name.text = monster.name
	label_type.text = 'Weakness: ' + type_name[monster.type_weakness]
	
	label_status_one.visible = false
	label_status_two.visible = false
