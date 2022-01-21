extends Node

onready var control = get_parent()

onready var monster_manager = get_node('/root/Control/MonsterManager')
onready var game_manager = get_node('/root/Control/GameManager')
onready var selection_arrows : Array = get_node('/root/Control/SelectionArrows').get_children()
onready var targets_selected_arrows : Array = get_node('/root/Control/TargetsSelectArrows').get_children()
onready var targets_candidate_arrows : Array = get_node('/root/Control/TargetCandidateArrows').get_children()

onready var selection_arrow_ally = selection_arrows[0]
onready var selection_arrow_action = selection_arrows[1]
onready var selection_arrow_targettwo = selection_arrows[2]

onready var actions : Array = get_node('/root/Control/Actions').get_children()

func _process(delta):
	_set_selected_ally()
	_set_selected_action()
	_set_candidate_targets()
	_set_selected_targets()
	_set_selected_targetstwo()
	
func _set_selected_targetstwo():
	selection_arrow_targettwo.visible = false
	
	if control.get_lock_inputs():
		return
	
	var input_group = control.get_input_group()
	
	if not input_group == INPUT_GROUP.TARGETTWO:
		return
		
	var targettwo = monster_manager.get_action_swap_target_to()
	
	selection_arrow_targettwo.global_position = targettwo.global_position
	selection_arrow_targettwo.global_position.x = selection_arrow_targettwo.global_position.x + 55
	selection_arrow_targettwo.visible = true

func _set_selected_targets():
	for arrow in targets_selected_arrows:
		arrow.visible = false
		
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
			targets_selected_arrows[i].visible = true
			targets_selected_arrows[i].global_position = target_team[i].global_position
			targets_selected_arrows[i].global_position.x = targets_selected_arrows[i].global_position.x + 55
			
		for arrow in targets_selected_arrows:
			arrow.visible = true
			
	if not targets.all:
		var target = monster_manager.get_target()
		targets_selected_arrows[index_target].visible = true
		targets_selected_arrows[index_target].global_position = target.global_position
		targets_selected_arrows[index_target].global_position.x = targets_selected_arrows[index_target].global_position.x + 55
	
func _set_selected_ally():
	selection_arrow_ally.visible = false
	
	if control.get_lock_inputs():
		return
	
	selection_arrow_ally.visible = true
	
	selection_arrow_ally.global_position = monster_manager.get_selected_team_a().global_position
	selection_arrow_ally.global_position.x = selection_arrow_ally.global_position.x + 55
	
func _set_selected_action():
	var input_group = control.get_input_group()
	selection_arrow_action.visible = false
	
	if input_group == INPUT_GROUP.ALLY:
		return
		
	var index_action = control.get_index_action()
		
	var origin_y = 248
	var y_increment = 43
		
	selection_arrow_action.visible = true
	selection_arrow_action.position.y = origin_y + (index_action * y_increment) 
	
func _set_candidate_targets():
	var input_group = control.get_input_group()
	
	for arrow in targets_candidate_arrows:
		arrow.visible = false
		
	if input_group == INPUT_GROUP.ALLY:
		return	
		
	if input_group == INPUT_GROUP.TARGETTWO:
		return
		
	var targets = monster_manager.get_selected_action_targets()
	
	for i in targets.indexes:
		var target = monster_manager.get_target_team_monster(i)
		targets_candidate_arrows[i].visible = true
		targets_candidate_arrows[i].global_position = target.global_position
		targets_candidate_arrows[i].global_position.x = targets_candidate_arrows[i].global_position.x + 55
