extends Node

onready var monster_manager = get_node('/root/Control/MonsterManager')
onready var control = get_parent()

onready var selection_arrows : Array = get_node('/root/Control/SelectionArrows').get_children()
onready var targets_selected_arrows : Array = get_node('/root/Control/TargetsSelectArrows').get_children()
onready var targets_candidate_arrows : Array = get_node('/root/Control/TargetCandidateArrows').get_children()

onready var selection_arrow_ally = selection_arrows[0]
onready var selection_arrow_action = selection_arrows[1]
onready var selection_arrow_targettwo = selection_arrows[2]

onready var actions : Array = get_node('/root/Control/Actions').get_children()

#var input_group
#var index_ally
#var index_target
#var index_action

#var targets
var target_team

func _process(delta):
#	_set_variables()
	_set_selected_ally()
	_set_selected_action()
	_set_candidate_targets()
	_set_selected_targets()
	_set_selected_targetstwo()
	
func _set_selected_targetstwo():
	selection_arrow_targettwo.visible = false
	
	var input_group = control.get_input_group()
	
	if not input_group == INPUT_GROUP.TARGETTWO:
		return
	
	var team = monster_manager.get_action_swap_team()
	var targettwo = control.get_index_targettwo()
	
	selection_arrow_targettwo.global_position = team[targettwo].global_position
	selection_arrow_targettwo.global_position.x = selection_arrow_targettwo.global_position.x + 55
	selection_arrow_targettwo.visible = true

func _set_selected_targets():
	for arrow in targets_selected_arrows:
		arrow.visible = false
		
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

#func _set_variables():
#	input_group = control.get_input_group()
#	index_ally = control.get_index_ally()
#	index_action = control.get_index_action()
#	index_target = control.get_index_target()
#	targets = monster_manager.get_selected_action_targets()
#	target_team = monster_manager.get_target_team()
	
func _set_selected_ally():
	selection_arrow_ally.global_position = monster_manager.get_selected_ally().global_position
	selection_arrow_ally.global_position.x = selection_arrow_ally.global_position.x + 55
	
func _set_selected_action():
	var input_group = control.get_input_group()
	selection_arrow_action.visible = false
	
	if input_group == INPUT_GROUP.ALLY:
		return
		
	var index_action = control.get_index_action()
		
	var origin_y = 243
	var y_increment = 43
		
	selection_arrow_action.visible = true
	selection_arrow_action.position.y = origin_y + (index_action * y_increment) 
	
func _set_candidate_targets():
	var input_group = control.get_input_group()
	
	for arrow in targets_candidate_arrows:
		arrow.visible = false
		
	if input_group == INPUT_GROUP.ALLY:
		return
		
	var targets = monster_manager.get_selected_action_targets()
	
	for i in targets.indexes:
		var target = monster_manager.get_target_team_monster(i)
		targets_candidate_arrows[i].visible = true
		targets_candidate_arrows[i].global_position = target.global_position
		targets_candidate_arrows[i].global_position.x = targets_candidate_arrows[i].global_position.x + 55

#func _manage_target_selection_arrows():
#	for arrow in target_selection_arrows:
#		arrow.set_visible(false)
#
#	if not input_group == INPUT_GROUP.TARGET:
#		return
#
#	if targets.all == true:
#		for i in targets.indexes:
#			target_selection_arrows[i].global_position = team[i].global_position
#			target_selection_arrows[i].global_position.x = target_selection_arrows[i].global_position.x + 50
#			target_selection_arrows[i].set_visible(true)
#		return
#
#	target_selection_arrows[0].global_position.x = target_selection_arrows[0].global_position.x + 50
#	target_selection_arrows[0].set_visible(true)
#
#func _manage_target_arraows():
#	for arrow in target_arrows:
#		arrow.set_visible(false)
#
#	if not input_group == INPUT_GROUP.ACTION and not input_group == INPUT_GROUP.TARGET:
#		return
#
#	for i in targets.indexes:
#		target_arrows[i].global_position = team[i].global_position
#		target_arrows[i].global_position.x = target_arrows[i].global_position.x + 50
#		target_arrows[i].set_visible(true)
