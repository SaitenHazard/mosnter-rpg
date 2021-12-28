extends Control

onready var arrow : Sprite = get_node('/root/Control/Arrow')

onready var teamA : Array = get_node('/root/Control/TeamA').get_children()
onready var teamB : Array = get_node('/root/Control/TeamB').get_children()
onready var actions : Array = get_node('/root/Control/Actions').get_children()
onready var ActionManager = get_node('ActionManager')

#onready var Target_manager = load('res://Scripts/Target_manager.gd')

#const INPUT_GROUP_ =  preload('res://Scripts/INPUT_GROUP.gd')

var input_group

var index_ally : int
var index_target : int
var index_action : int

var ally_min_index : int = 0
var ally_max_index : int = 2

var target_min_index : int = 0
var target_max_index : int = 2

var action_min_index : int = 0
var action_max_index : int = 3

var targets = null
var targets_team = null
var lock_inputs : bool = false 
	
func _ready():
	input_group = INPUT_GROUP.ALLY
	
func lock_inputs():
	lock_inputs = true
	
func unlock_inputs():
	lock_inputs = false
	
func _process(delta):
	_inputs()

func get_input_group():
	return input_group

func _inputs():
	if lock_inputs():
		return
	
	_input_groups()
	_input_allies()
	_input_actions()
	_input_targets()

func _input_groups():
	if Input.is_action_just_pressed("accept"):
		if get_input_group() == INPUT_GROUP.ACTION:
			input_group = INPUT_GROUP.TARGET
			
		if get_input_group() == INPUT_GROUP.ALLY:
			input_group = INPUT_GROUP.ACTION
			
		if get_input_group() == INPUT_GROUP.ACTION:
			ActionManager.do_action()
			
	if Input.is_action_just_pressed("reject"):
		if get_input_group() == INPUT_GROUP.TARGET:
			input_group = INPUT_GROUP.ACTION
			
		if get_input_group() == INPUT_GROUP.ACTION:
			input_group = INPUT_GROUP.ALLY
			
		print(input_group)

func _input_allies():
	if get_input_group() != INPUT_GROUP.ALLY:
		return
		
	if Input.is_action_just_pressed("down"):
		_input_allies_increment(true)
		
	if Input.is_action_just_pressed("up"):
		_input_allies_increment(false)
	
func _input_actions():
	if get_input_group() != INPUT_GROUP.ACTION:
		return
	
	if Input.is_action_just_pressed("down"):
		_input_actions_increment(true)
		
	if Input.is_action_just_pressed("up"):
		_input_actions_increment(false)
	
func _input_targets():
	if get_input_group() != INPUT_GROUP.TARGET:
		return
	
	if Input.is_action_just_pressed("down"):
		_input_targets_increment(true)
		
	if Input.is_action_just_pressed("up"):
		_input_targets_increment(false)
	
func _input_allies_increment(var increment):
	var min_index = 0
	var max_index = 2
	
	var candidate_index = index_ally
	
	if increment:
		candidate_index = candidate_index + 1
	else:
		candidate_index = candidate_index -1
		
	if candidate_index < min_index:
		candidate_index = max_index
		
	if candidate_index > max_index:
		candidate_index = min_index
		
	index_ally = candidate_index
	
func _input_actions_increment(var increment):
	var min_index = 0
	var max_index = 3
	
	var candidate_index = index_action
	
	if increment:
		candidate_index = candidate_index + 1
	else:
		candidate_index = candidate_index -1
		
	if candidate_index < min_index:
		candidate_index = max_index
		
	if candidate_index > max_index:
		candidate_index = min_index
		
	index_action = candidate_index
	
func _input_targets_increment(var increment):
	var min_index = 0
	var max_index = 2
	
	if increment:
		index_target = index_target + 1
	else:
		index_target = index_target -1
		
	if index_target < min_index:
		index_target = max_index
		
func get_index_action() -> int:
	return index_action
		
func get_index_ally() -> int:
	return index_ally
	
func get_index_target() -> int:
	return index_target
