extends Control

onready var arrow : Sprite = get_node('/root/Control/Arrow')

onready var target_arrows : Array = get_node('/root/Control/TargetArrows').get_children()
onready var target_selection_arrows : Array = get_node('/root/Control/TargetSelectArrows').get_children()
onready var teamA : Array = get_node('/root/Control/TeamA').get_children()
onready var teamB : Array = get_node('/root/Control/TeamB').get_children()
onready var actions : Array = get_node('/root/Control/Actions').get_children()

#onready var Target_manager = load('res://Scripts/Target_manager.gd')

enum INPUT_GROUP {ALLY, ACTION, FOE}

var input_index : int = 0
var input_group = INPUT_GROUP.ALLY

var monster_index : int = 0
var action_index : int = 0
	
func _process(delta):
	_inputs()
	_manage_selection_arrow()
	_manage_target_arraows()
	_manage_target_selection_arrows()
	
func _manage_target_selection_arrows():
	for arrow in target_selection_arrows:
		arrow.set_visible(false)
	
	if not input_group == INPUT_GROUP.FOE:
		return
		
	var targets = _get_target()
	var team = _get_target_team(targets)
		
#	if targets.all == true:
#		for i in targets.indexes:
#			target_selection_arrows[i].global_position = team[i].global_position
#			target_selection_arrows[i].global_position.x = target_arrows[i].global_position.x + 50
#			target_selection_arrows[i].set_visible(true)
#		return
		
#	print(team[0].parent.name)
	
	var global_position = team[input_index].global_position
		
	target_selection_arrows[0].global_position = global_position
	target_selection_arrows[0].global_position.x = target_selection_arrows[0].global_position.x + 50
#	target_selection_arrows[0].global_position.x = arrow.global_position.x + 50
	target_selection_arrows[0].set_visible(true)

func _manage_target_arraows():
	for arrow in target_arrows:
		arrow.set_visible(false)
		
	if not input_group == INPUT_GROUP.ACTION and not input_group == INPUT_GROUP.FOE:
		return
		
	var targets = _get_target();
	var team = _get_target_team(targets)
	
	for i in targets.indexes:
		target_arrows[i].global_position = team[i].global_position
		target_arrows[i].global_position.x = target_arrows[i].global_position.x + 50
		target_arrows[i].set_visible(true)
		
#	if input_group == INPUT_GROUP.FOE:
#		target_arrows[input_index].set_visible(false)
		
func _get_target_team(targets):
	if targets.ally:
		return teamA
	else:
		return teamB
	
func _get_target():
	var action_range = teamA[monster_index].get_action(action_index).action_range;
	var targets = Targets.new(monster_index, action_range, teamA, teamB)
	
	return targets
	
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
		
#	if input_group == INPUT_GROUP.FOE:
#		global_position = teamB[input_index].global_position
#		arrow.scale = Vector2(0.5,0.5)
	
	arrow.global_position = global_position
	arrow.global_position.x = arrow.global_position.x - 50

func _inputs():
	if Input.is_action_just_pressed("down"):
		_input_index_increment(true)
		
	if Input.is_action_just_pressed("up"):
		_input_index_increment(false)
		
	_input_group()
	_set_monster_index()
	_set_action_index()
	
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
		
	var targets = _get_target();
	
	if input_group == INPUT_GROUP.FOE:
		if not targets.indexes.has(input_index):
			_input_index_increment(increment)

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
			
		_reset_index()
			
	if Input.is_action_just_pressed("reject"):
		if (input_group == INPUT_GROUP.ACTION):
			input_group = INPUT_GROUP.ALLY
			
		if (input_group == INPUT_GROUP.FOE):
			input_group = INPUT_GROUP.ACTION
			
		_reset_index()

func _reset_index():
	input_index = -1
	_input_index_increment(true)
