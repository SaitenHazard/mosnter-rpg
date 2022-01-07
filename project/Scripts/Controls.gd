extends Control

onready var arrow : Sprite = get_node('/root/Control/Arrow')

onready var actions : Array = get_node('/root/Control/Actions').get_children()

onready var monster_manager = get_node('/root/Control/MonsterManager')
onready var action_manager = get_node('/root/Control/ActionManager')
onready var game_manager = get_node('/root/Control/GameManager')

var input_group

var index_ally : int
var index_target : int
var index_action : int
var index_targettwo : int

var targets = null
var targets_team = null
var lock_inputs : bool = false
	
func _ready():
	input_group = INPUT_GROUP.ALLY
	
func lock_inputs():
	lock_inputs = true

func unlock_inputs():
	lock_inputs = false
	
func get_lock_inputs():
	return lock_inputs
	
func _process(delta):
	_inputs()

func get_input_group():
	return input_group

func reset_inputs():
	input_group = INPUT_GROUP.ALLY
	unlock_inputs()

func _inputs():
	if lock_inputs:
		return
	
	_input_groups()
	_input_allies()
	_input_actions()
	_input_targets()
	_input_targetstwo()
	_end_turn()
	
func _end_turn():
	if Input.is_action_just_pressed("end_turn"):
		game_manager._end_all_ally_turns()

func _input_groups():
	if Input.is_action_just_pressed("accept"):
		if get_input_group() == INPUT_GROUP.TARGETTWO:
			
			if not action_manager.enough_points_for_action():
				return
			
			action_manager.do_action()
			return
		
		if get_input_group() == INPUT_GROUP.TARGET:
			if not action_manager.selected_action_has_two_targets():
				if not action_manager.enough_points_for_action():
					return
					
				action_manager.do_action()
				return
			else:
				input_group = INPUT_GROUP.TARGETTWO
				return
			
		if get_input_group() == INPUT_GROUP.ACTION:
			input_group = INPUT_GROUP.TARGET
			_input_targets_increment(true)
			return
			
		if get_input_group() == INPUT_GROUP.ALLY:
			input_group = INPUT_GROUP.ACTION
			return
			
	if Input.is_action_just_pressed("reject"):
		if get_input_group() == INPUT_GROUP.ACTION:
			input_group = INPUT_GROUP.ALLY
			return
			
		if get_input_group() == INPUT_GROUP.TARGET:
			input_group = INPUT_GROUP.ACTION
			return
			
		if get_input_group() == INPUT_GROUP.TARGETTWO:
			input_group = INPUT_GROUP.TARGET
			return
			
func _input_allies():
	if get_input_group() != INPUT_GROUP.ALLY:
		return
		
	if Input.is_action_just_pressed("down"):
		input_allies_increment(true)
		
	if Input.is_action_just_pressed("up"):
		input_allies_increment(false)
	
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
		
func _input_targetstwo():
	if Input.is_action_just_pressed("down"):
		_input_targetstwo_increment(true)
		
	if Input.is_action_just_pressed("up"):
		_input_targetstwo_increment(false)
		
func _input_targetstwo_increment(var increment):
	var min_index = 0
	var max_index = 2
	
	var target_indexes = monster_manager.get_targettwo_indexes()
	
	var candidate_index = index_targettwo
	var index_is_valid = false
	
	while index_is_valid == false:
		if increment:
			candidate_index = candidate_index + 1
		else:
			candidate_index = candidate_index -1
			
		if candidate_index < min_index:
			candidate_index = max_index

		if candidate_index > max_index:
			candidate_index = min_index
		
		for index in target_indexes:
			if index == candidate_index:
				index_is_valid = true
		
	index_targettwo = candidate_index
	
func input_allies_increment(var increment):
	var min_index = 0
	var max_index = 2
	
	var candidate_index = index_ally
	var number_monsters_turn_not_available = 0
	var index_is_valid = false
	
	while index_is_valid == false:
		if increment:
			candidate_index = candidate_index + 1
		else:
			candidate_index = candidate_index -1
			
		if candidate_index < min_index:
			candidate_index = max_index

		if candidate_index > max_index:
			candidate_index = min_index
		
		if monster_manager.get_ally(candidate_index).get_turn_available():
			index_is_valid = true
		else:
			number_monsters_turn_not_available = number_monsters_turn_not_available +1
			
		if number_monsters_turn_not_available == 3:
			index_is_valid = true
		
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
	
	var target_indexes = monster_manager.get_selected_action_targets().indexes
	
	var candidate_index = index_target
	var index_is_valid = false
	
	while index_is_valid == false:
		if increment:
			candidate_index = candidate_index + 1
		else:
			candidate_index = candidate_index -1
			
		if candidate_index < min_index:
			candidate_index = max_index

		if candidate_index > max_index:
			candidate_index = min_index
		
		for index in target_indexes:
			if index == candidate_index:
				index_is_valid = true
		
	index_target = candidate_index

func get_index_action() -> int:
	return index_action
		
func get_index_ally() -> int:
	return index_ally
	
func get_index_target() -> int:
	return index_target
	
func get_index_targettwo() -> int:
	return index_targettwo
