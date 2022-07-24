extends Node

class_name Targets

onready var team_user
onready var team_target

var indexes : Array
var all : bool
var team_a : bool

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
	_remove_outofbounds_targets();
	_remove_dead_targets()

func _remove_outofbounds_targets():
	for i in range(indexes.size()-1, -1, -1):
		if indexes[i] < 0 or indexes[i] > 2:
			indexes.remove(i)
		
func _remove_dead_targets():
	for monster in team_target:
		for i in range(indexes.size()-1, -1, -1):
			if monster.get_position_index() == i:
				if monster.get_health() == 0:
					print(monster.name)
					print('before ')
					print(indexes)
					indexes.erase(i)
					print('after')
					print(indexes)
					
func _is_mon_dead(var position_index):
	for monster in team_target:
		if monster.get_position_index() == position_index && monster.get_health() == 0:
			return true
			
	return false

func _remove_actioner_as_target(actioner_index):
	if all == true:
		return
		
	if team_a == false:
		return
		
#	print(actioner_index)
		
	indexes.remove(actioner_index)
	
func _get_target_candidates(actioner_index : int, action_range):
	if action_range == ACTION_RANGE.ALLY_ALL:
		indexes = [0, 1, 2]
		team_a = true
		all = true
	
	if action_range == ACTION_RANGE.FOE_ALL:
		indexes = [0, 1, 2]
		team_a = false
		all = true
	
	if action_range == ACTION_RANGE.ALLY:
		indexes = [0, 1, 2]
		team_a = true
		all = false
		
	if action_range == ACTION_RANGE.FOE:
		indexes = [actioner_index-1, actioner_index, actioner_index+1]
		team_a = false
		all = false
