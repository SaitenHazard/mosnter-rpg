extends Node

onready var control = get_parent()

onready var monster_manager = get_node('/root/Control/MonsterManager')
onready var game_manager = get_node('/root/Control/GameManager')
onready var selection_arrows : Array = get_node('/root/Control/SelectionArrows').get_children()
onready var targets_selected_arrows : Array = get_node('/root/Control/TargetsSelectArrows').get_children()
onready var targets_candidate_arrows : Array = get_node('/root/Control/TargetCandidateArrows').get_children()
onready var targetstwo_candidate_arrows : Array = get_node('/root/Control/TargetTwoCandidateArrows').get_children()

onready var selection_arrow_ally = selection_arrows[0]
onready var selection_arrow_action = selection_arrows[1]
onready var selection_arrow_targettwo = selection_arrows[2]

onready var actions : Array = get_node('/root/Control/Actions').get_children()

func _process(delta):
	_set_selected_ally()
	_set_selected_action()
	_set_candidate_targets()
	_set_selected_targets()
	_set_candidate_targetstwo()
	_set_selected_targetstwo()
	
func _set_selected_action():
	var input_group = control.get_input_group()
	selection_arrow_action.visible = false
	
	if input_group == INPUT_GROUP.ALLY:
		return
		
	if not game_manager.is_team_a_turn():
		return
		
	if control.get_input_group() != INPUT_GROUP.ACTION:
		selection_arrow_action.get_node('AnimationPlayer').seek(0.6)
	else:
		selection_arrow_action.get_node('AnimationPlayer').play()
		selection_arrow_action.get_node('AnimationPlayer').play()
		
	var index_action = control.get_index_action()
		
	var origin_y = 265
	var y_increment = 43
		
	selection_arrow_action.visible = true
	selection_arrow_action.position.y = origin_y + (index_action * y_increment)
	
func _set_selected_targetstwo():
	selection_arrow_targettwo.visible = false
	
	if not game_manager.is_team_a_turn():
		return
	
	if control.get_lock_inputs():
		return
	
	var input_group = control.get_input_group()
	
	if not input_group == INPUT_GROUP.TARGETTWO:
		return
		
	var targettwo = monster_manager.get_action_swap_target_to()
	
	selection_arrow_targettwo.global_position = targettwo.global_position
	selection_arrow_targettwo.global_position.y = selection_arrow_targettwo.global_position.y - 60
	selection_arrow_targettwo.visible = true

func _set_selected_targets():
	for arrow in targets_selected_arrows:
		arrow.visible = false
		
	if not game_manager.is_team_a_turn():
		return
		
	if control.get_lock_inputs():
		return
		
	var index_target = control.get_index_target()
	
	var input_group = control.get_input_group()
		
	if input_group != INPUT_GROUP.TARGET and input_group != INPUT_GROUP.TARGETTWO:
		return
		
	var targets = monster_manager.get_selected_action_targets()
	var target_team = monster_manager.get_target_team()
		
	if targets.all:
		for i in targets_selected_arrows.size():
			if not target_team[i].get_health() == 0:
				targets_selected_arrows[i].visible = true
				targets_selected_arrows[i].global_position = target_team[i].global_position
				targets_selected_arrows[i].global_position.y = targets_selected_arrows[i].global_position.y - 60
			
	if not targets.all:
		var target = monster_manager.get_target()
		targets_selected_arrows[index_target].visible = true
		targets_selected_arrows[index_target].global_position = target.global_position
		targets_selected_arrows[index_target].global_position.y = targets_selected_arrows[index_target].global_position.y - 60
	
func _set_selected_ally():
	selection_arrow_ally.visible = false
	
	if control.get_lock_inputs():
		return
		
	if not game_manager.is_team_a_turn():
		return
		
	if control.get_input_group() != INPUT_GROUP.ALLY:
		selection_arrow_ally.get_node('AnimationPlayer').seek(0)
	else:
		selection_arrow_ally.get_node('AnimationPlayer').play()
		
	selection_arrow_ally.visible = true
	
	selection_arrow_ally.global_position = monster_manager.get_selected_team_a().global_position
	selection_arrow_ally.global_position.y = selection_arrow_ally.global_position.y - 60

func _set_candidate_targets():
	var input_group = control.get_input_group()
	
	for arrow in targets_candidate_arrows:
		arrow.visible = false
		
	if input_group == INPUT_GROUP.ALLY:
		return
		
	if input_group == INPUT_GROUP.TARGETTWO:
		return
		
	if not game_manager.is_team_a_turn():
		return
		
	if control.get_input_group() != INPUT_GROUP.ACTION:
		_set_candidate_targets_animation_all(true)
	else:
		_set_candidate_targets_animation_all(false)
		
	var targets = monster_manager.get_selected_action_targets()
	
	for i in targets.indexes:
		var target = monster_manager.get_target_team_monster(i)
		targets_candidate_arrows[i].visible = true
		targets_candidate_arrows[i].global_position = target.global_position
		targets_candidate_arrows[i].global_position.y = targets_candidate_arrows[i].global_position.y - 60

	var index_target = control.get_index_target()
	
	if control.get_input_group() == INPUT_GROUP.TARGET:
		if targets.all:
			_set_candidate_targets_animation_visible(false)
		else:
			targets_candidate_arrows[index_target].visible = false
		
	if control.get_input_group() == INPUT_GROUP.TARGETTWO:
		targets_candidate_arrows[index_target].visible = false
		

func _set_candidate_targets_animation_visible(var visible : bool):
	for index in targets_candidate_arrows.size():
		targets_candidate_arrows[index].visible = visible

func _set_candidate_targets_animation_all(var set):
	for index in targets_candidate_arrows.size():
		_set_candidate_targets_animation(set, index)
			
func _set_candidate_targets_animation(var set : bool, var index):
	if set:
		targets_candidate_arrows[index].get_node('AnimationPlayer').play()
	if not set:
		targets_candidate_arrows[index].get_node('AnimationPlayer').seek(0.6)

func _set_candidate_targetstwo():
	var input_group = control.get_input_group()
	
	for arrow in targetstwo_candidate_arrows:
		arrow.visible = false
		
	if input_group != INPUT_GROUP.TARGETTWO:
		return
		
	if not game_manager.is_team_a_turn():
		return
		
	var indexes = monster_manager.get_targettwo_indexes()
		
	for i in indexes:
		var targets = monster_manager.get_action_swap_team()
		var target = monster_manager.get_monster(targets, i)
		targetstwo_candidate_arrows[i].visible = true
		targetstwo_candidate_arrows[i].global_position = target.global_position
		targetstwo_candidate_arrows[i].global_position.y = targetstwo_candidate_arrows[i].global_position.y - 60

	var index_target = control.get_index_targettwo()
	
	targetstwo_candidate_arrows[index_target].visible = false
