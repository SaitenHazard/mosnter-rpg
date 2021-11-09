extends Control

onready var arrow : Sprite = get_node('/root/Control/Arrow')

onready var allies : Array = get_node('/root/Control/TeamA').get_children()
onready var foes : Array = get_node('/root/Control/TeamB').get_children()
onready var actions : Array = get_node('/root/Control/Actions').get_children()

enum INPUT_GROUP {ALLY, ACTION, FOE}

var input_index : int = 0
var input_group = INPUT_GROUP.ALLY

var monster_index : int = 0
var action_index : int = 0

#func _ready():
#	print(actions[0].get_global_transform().origin)
	
func _process(delta):
	_inputs()
	_manage_arrow()
	
func _manage_arrow():
	var global_position
	
	if input_group == INPUT_GROUP.ALLY:
		global_position = allies[input_index].global_position
		
	if input_group == INPUT_GROUP.ACTION:
		global_position = actions[input_index].get_global_transform().origin
		global_position.y = global_position.y + 13
		
	if input_group == INPUT_GROUP.FOE:
		global_position = foes[input_index].global_position
	
	arrow.global_position = global_position
	arrow.global_position.x = arrow.global_position.x - 50

func _inputs():
	_input_index()
	_input_group()
	_set_monster_index()
	_set_action_index()
	
func _input_index():
	var index_min = 0
	var index_max = 2
	var actions_count = 4
	
	if input_group == INPUT_GROUP.ACTION:
		index_max = actions_count - 1
	
	if Input.is_action_just_pressed("down"):
		input_index = input_index + 1
		
	if Input.is_action_just_pressed("up"):
		input_index = input_index -1
		
	if input_index < index_min:
		input_index = index_max
		
	if input_index > index_max:
		input_index = index_min
		
func _set_monster_index():
	if input_group == INPUT_GROUP.ALLY:
		monster_index = input_index
		
func _set_action_index():
	action_index = -1
	
	if input_group == INPUT_GROUP.ACTION:
		action_index = input_index
		
func get_action_index() -> int:
	return action_index	
		
func get_monster_index() -> int:
	return monster_index
		
func _input_group():
	if Input.is_action_just_pressed("accept"):
		if (input_group == INPUT_GROUP.ACTION):
			input_group = INPUT_GROUP.FOE
			
		if (input_group == INPUT_GROUP.ALLY):
			input_group = INPUT_GROUP.ACTION
			
		input_index = 0
			
	if Input.is_action_just_pressed("reject"):
		if (input_group == INPUT_GROUP.ACTION):
			input_group = INPUT_GROUP.ALLY
			
		if (input_group == INPUT_GROUP.FOE):
			input_group = INPUT_GROUP.ACTION

		input_index = 0
