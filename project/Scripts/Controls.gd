extends Control

onready var arrow : Sprite = get_node('/root/Control/Arrow')

onready var actions : Array = get_node('/root/Control/Actions').get_children()

onready var monster_manager = get_node('/root/Control/MonsterManager')
onready var action_manager = get_node('/root/Control/ActionManager')
onready var game_manager = get_node('/root/Control/GameManager')
onready var AI = get_node('/root/Control/AI')
onready var action_points = get_node('/root/Control/ActionPoints/Label')
onready var sound_manager = get_node('/root/Control/SoundManager')

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
	index_action = 0
	if monster_manager.is_team_a_turn_available():
		input_group = INPUT_GROUP.ALLY
		input_allies_increment(true)
	else:
		input_group = INPUT_GROUP.AIAction
		
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
		
func _do_action():
	var action = action_manager.get_selected_action()
	var user = monster_manager.get_selected_team_a()
	var targets = monster_manager.get_action_target_team(action, user)
	var target2 = monster_manager.get_targettwo()
	
	if not action_manager.selected_action_has_two_targets():
		target2 = null
	
	if action.action_range == ACTION_RANGE.ALLY or action.action_range == ACTION_RANGE.FOE:
		var index = get_index_target()
		targets =  [monster_manager.get_action_target_team_monster(action, user, index)]
		
	action_manager.do_action(action, user, targets, target2)

func _input_groups():
	_input_accept()
	_input_reject()

func _input_reject():
	if Input.is_action_just_pressed("reject"):
		if get_input_group() == INPUT_GROUP.ACTION:
			sound_manager.play_cancel()
			input_group = INPUT_GROUP.ALLY
			return
			
		if get_input_group() == INPUT_GROUP.TARGET:
			sound_manager.play_cancel()
			input_group = INPUT_GROUP.ACTION
			return
			
		if get_input_group() == INPUT_GROUP.TARGETTWO:
			sound_manager.play_cancel()
			input_group = INPUT_GROUP.TARGET
			return
			
func _action_skip():
	lock_inputs()
	var user = monster_manager.get_selected_team_a().set_turn_availabale(false)
	yield(get_tree().create_timer(0.5), "timeout")
	reset_inputs()
			
func _input_accept():
	if Input.is_action_just_pressed("accept"):
#		if get_input_group() == INPUT_GROUP.AIAction:
#			AI.unset_ai_action_user_target_object()
#			return

		if not action_manager.selected_action_has_two_targets():
			if action_manager.get_selected_action().action_name == ACTION_NAMES.Skip:
				sound_manager.play_accept()
				_action_skip()
				return
		
		if get_input_group() == INPUT_GROUP.TARGETTWO:
			if not action_manager.enough_points_for_action():
				action_points.get_child(0).play('New Anim')
				sound_manager.play_not_allowed()
				return
				
			sound_manager.play_accept()
			_do_action()
			return
		
		if get_input_group() == INPUT_GROUP.TARGET:
			if not action_manager.selected_action_has_two_targets():
				if not action_manager.enough_points_for_action():
					action_points.get_child(0).play('New Anim')
					sound_manager.play_not_allowed()
					return
					
				sound_manager.play_accept()
				_do_action()
				return
			else:
				sound_manager.play_accept()
				input_group = INPUT_GROUP.TARGETTWO
				return
			
		if get_input_group() == INPUT_GROUP.ACTION:
			sound_manager.play_accept()
			input_group = INPUT_GROUP.TARGET
			_input_targets_increment(true)
			return
			
		if get_input_group() == INPUT_GROUP.ALLY:
			sound_manager.play_accept()
			input_group = INPUT_GROUP.ACTION
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
	sound_manager.play_select()
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
	sound_manager.play_select()
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
			
		var candidate_monster =  monster_manager.get_team_a_monster(candidate_index)
			
		if candidate_monster.is_turn_available() and not candidate_monster.is_dead():
			index_is_valid = true
		else:
			number_monsters_turn_not_available = number_monsters_turn_not_available +1
			
		if number_monsters_turn_not_available == 3:
			index_is_valid = true
		
	index_ally = candidate_index

func _input_actions_increment(var increment):
	var min_index = 0
	var max_index = 4
	
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
	sound_manager.play_select()
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
