extends Node

class_name Targets

onready var team_user
onready var team_target

var indexes : Array
var all : bool
var ally : bool

func _init(user_index : int, action_range, team_user, team_target):
	self.team_user = team_user
	self.team_target = team_target
	_get_targets(user_index, action_range)
#	_debug(action_range)

func _debug(action_range):
	return

	if action_range == ACTION_RANGE.ALLY:
		print('ALLY')
		
	if action_range == ACTION_RANGE.ALLY_ALL:
		print('ALLY_ALL')
		
	if action_range == ACTION_RANGE.FOE:
		print('FOE')
		
	if action_range == ACTION_RANGE.FOE_ALL:
		print('FOE_ALL')

func _get_targets(actioner_index : int, action_range):
	_get_target_candidates(actioner_index, action_range)
	_remove_actioner_as_target(actioner_index)
	_remove_dead_targets()
	_remove_outofbounds_targets();

func _remove_outofbounds_targets():
	for i in range(indexes.size()-1, -1, -1):
		if indexes[i] < 0 or indexes[i] > 2:
			indexes.remove(i)
		
func _remove_dead_targets():
	if ally == true:
		for i in team_user.size():
			if team_user[i].get_health() <= 0:
				indexes.remove(i)
				
	if ally == false:
		for i in team_target.size():
			if team_target[i].get_health() <= 0:
				indexes.remove(i)

func _remove_actioner_as_target(actioner_index):
	if all == true:
		return
		
	if ally == false:
		return
		
#	print(actioner_index)
		
	indexes.remove(actioner_index)
	
func _get_target_candidates(actioner_index : int, action_range):
	if action_range == ACTION_RANGE.ALLY_ALL:
		indexes = [0, 1, 2]
		ally = true
		all = true
	
	if action_range == ACTION_RANGE.FOE_ALL:
		indexes = [0, 1, 2]
		ally = false
		all = true
	
	if action_range == ACTION_RANGE.ALLY:
		indexes = [0, 1, 2]
		ally = true
		all = false
		
	if action_range == ACTION_RANGE.FOE:
		indexes = [actioner_index-1, actioner_index, actioner_index+1]
		ally = false
		all = false
