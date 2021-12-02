extends Control

onready var arrow : Sprite = get_node('/root/Control/Arrow')

onready var teamA : Array = get_node('/root/Control/TeamA').get_children()
onready var teamB : Array = get_node('/root/Control/TeamB').get_children()
onready var actions : Array = get_node('/root/Control/Actions').get_children()
onready var ActionManager = get_node('ActionManager')

#onready var Target_manager = load('res://Scripts/Target_manager.gd')

#const INPUT_GROUP_ =  preload('res://Scripts/INPUT_GROUP.gd')

var input_group

var input_index : int
var monster_index : int
var action_index : int
var targets = null
var targets_team = null
var lock_inputs : bool = false 
	
func _ready():
#	print(INPUT_GROUP_)
	input_group = INPUT_GROUP.ALLY
	
func reset():
	while not input_group ==  INPUT_GROUP.ALLY:
		_input_group_increment(false)
	
func _process(delta):
	_inputs()
	_set_monster_index()
	_set_action_index()
	_manage_selection_arrow()

func get_input_group():
	return input_group
	
func get_input_index():
	return input_index

func _manage_selection_arrow():
	if not input_group == INPUT_GROUP.ALLY and not input_group == INPUT_GROUP.ACTION:
		return
	
	var global_position
	
	if input_group == INPUT_GROUP.ALLY:
		global_position = teamA[input_index].global_position
		arrow.scale = Vector2(0.5,0.5)
		
	if input_group == INPUT_GROUP.ACTION:
		global_position = actions[input_index].get_global_transform().origin
		global_position.y = global_position.y + 13
		arrow.scale = Vector2(1,1)
		
#	if input_group == INPUT_GROUP.TARGET:
#		global_position = teamB[input_index].global_position
#		arrow.scale = Vector2(0.5,0.5)
	
	arrow.global_position = global_position
	arrow.global_position.x = arrow.global_position.x - 50

func _inputs():
	if Input.is_action_just_pressed("down"):
		_input_index_increment(true)
		
	if Input.is_action_just_pressed("up"):
		_input_index_increment(false)
		
	if Input.is_action_just_pressed("accept"):
		_input_group_increment(true)
		
	if Input.is_action_just_pressed("reject"):
		_input_group_increment(false)
	
func _input_index_increment(var increment : bool):
	if increment:
		input_index = input_index + 1
		
	if not increment:
		input_index = input_index -1
		
	_input_corrections(increment)
	
func _input_corrections(var increment : bool):
	var index_min = 0
	var index_max = 2
	var actions_count = 4
	
	if input_group == INPUT_GROUP.ACTION:
		index_max = actions_count - 1
	
	if input_index < index_min:
		input_index = index_max
		
	if input_index > index_max:
		input_index = index_min
		
	if input_group == INPUT_GROUP.TARGET:
		var targets = ActionManager.get_targets();
		
		if not targets.indexes.has(input_index):
			_input_index_increment(increment)
	
func _set_monster_index():
	if input_group == INPUT_GROUP.ALLY:
		monster_index = input_index
		
func _set_action_index():
	if input_group == INPUT_GROUP.ACTION:
		action_index = input_index
		
func get_action_index() -> int:
	return action_index	
		
func get_monster_index() -> int:
	return monster_index
		
func _input_group_increment(var accept : bool):
	if accept:
		if (input_group == INPUT_GROUP.TARGET):
			get_node('ActionManager').do_action()
			
		if (input_group == INPUT_GROUP.ACTION):
			input_group = INPUT_GROUP.TARGET
			
		if (input_group == INPUT_GROUP.ALLY):
			input_group = INPUT_GROUP.ACTION
			
		_reset_index()
			
	if not accept:
		if (input_group == INPUT_GROUP.ACTION):
			input_group = INPUT_GROUP.ALLY
			
		if (input_group == INPUT_GROUP.TARGET):
			input_group = INPUT_GROUP.ACTION
			
		_reset_index()

func _reset_index():
	input_index = -1
	_input_index_increment(true)
