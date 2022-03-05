extends Node2D

class AI_ACTION_USER_TARGET:
	var user
	var targets
	var action
	var weight
	var weight_reasons = ''
	
	func _init(var user, var targets, var action, var weight):
		self.user = user
		self.targets = targets
		self.action = action
		self.weight = weight
		
	func add_weight(var i = 1):
		weight = weight + i
		
class ACTION_USER:
	var action
	var user
	
	func _init(var action, var user):
		self.action = action
		self.user = user

onready var game_manager = get_node('/root/Control/GameManager')
onready var monster_manager = get_node('/root/Control/MonsterManager')
onready var action_manager = get_node('/root/Control/ActionManager')

var cumulative_weight

var ai_action_user_target_object = null

var rng = RandomNumberGenerator.new()
		
#class ActionUserTargetSorter:
#	static func sort_ascending(a, b):
#		if a.weight < b.weight:
#			return true
#		return false
	
func _ready():
	rng.randomize()
	
func _process(var delta):
	_ai_action_manager()
	
var count : int = 0 
	
func _ai_action_manager():
	var team_a_turn = game_manager.get_team_a_turn()
	
	if team_a_turn:
		return
		
	if not ai_action_user_target_object == null:
		return
		
	if count > 1:
		return
	
	count = count + 1
		
	_set_action()
	_do_action()
	
func _wait_for_last_action():
	var last_action_used = action_manager.get_last_action_used()
	
	if last_action_used.action_name == ACTION_NAMES.Bamboo_Bash: 
		yield(get_tree().create_timer(3), "timeout")
		
	if last_action_used.action_name == ACTION_NAMES.Bonfire: 
		yield(get_tree().create_timer(2), "timeout")
		
	if last_action_used.action_name == ACTION_NAMES.Fire_Ball: 
		yield(get_tree().create_timer(2), "timeout")
		
	if last_action_used.action_name == ACTION_NAMES.Fire_Blitz: 
		yield(get_tree().create_timer(2), "timeout")
		
	if last_action_used.action_name == ACTION_NAMES.Healing_Pulse: 
		yield(get_tree().create_timer(3), "timeout")
		
	if last_action_used.action_name == ACTION_NAMES.Icicle_Blade: 
		yield(get_tree().create_timer(2), "timeout")
		
	if last_action_used.action_name == ACTION_NAMES.Natural_Remedy: 
		yield(get_tree().create_timer(2), "timeout")
		
	if last_action_used.action_name == ACTION_NAMES.Sticky_Sticks: 
		pass
		
	if last_action_used.action_name == ACTION_NAMES.Swift_Surf: 
		pass
		
	if last_action_used.action_name == ACTION_NAMES.Swap: 
		yield(get_tree().create_timer(1), "timeout")
	
func unset_ai_action_user_target_object():
	ai_action_user_target_object = null
	
func get_ai_action_user_target():
	return ai_action_user_target_object
	
func _do_action():
	var action = ai_action_user_target_object.action
	var user = ai_action_user_target_object.user
	var targets = ai_action_user_target_object.targets
	var target2 = _get_random_monster_for_swap(ai_action_user_target_object)
	
#	print(targets[0].get_name())
#	print(target2.get_name())
	
	action_manager.do_action(action, user, targets, target2)
	
func _get_random_monster_for_swap(var ai_action_user_target):
	var action = ai_action_user_target.action
	
	if action.swap == null:
		return null
		
	if not action_manager.action_has_two_targets(action):
		return null
		
	var position_indexes : Array = [0,1,2]
	var team
	
	if action.swap == ACTION_RANGE.FOE:
		team = monster_manager.get_team_a()
		position_indexes.remove(ai_action_user_target.user.get_position_index())
		
	if action.swap == ACTION_RANGE.ALLY:
		team = monster_manager.get_team_a()
		position_indexes.remove(ai_action_user_target.targets[0].get_position_index())
		
	var rand_index : int = rng.randi_range(0,1)
	
	return monster_manager.get_monster(team, position_indexes[rand_index])
	
func _set_action():
	var action_user_objects = _get_action_user_array()
	var action_user_target_objects = _set_ai_action_user_target(action_user_objects)
	
#	0,1
	ai_action_user_target_object = action_user_target_objects[3]
	
#	action_user_target_objects = _set_ai_action_targets_weight(action_user_target_objects)
#	ai_action_user_target_object = _choose_ai_action_target_user(action_user_target_objects)
	
func _choose_ai_action_target_user(var action_user_target_objects : Array):
	var action_user_target_objects_weight = _get_actions_user_targets_with_rand_weight(action_user_target_objects)
	var roll = rng.randi_range(0, action_user_target_objects_weight.size()-1)
	return action_user_target_objects_weight[roll]
	
func _get_actions_user_targets_with_rand_weight(var action_user_target_objects : Array):
	var action_user_target_objects_weight : Array
	
	while(action_user_target_objects_weight.empty()):
		var roll = rng.randi_range(1, 100)
		var weight = _get_random_weight(roll)
			
		for action_user_target_object in action_user_target_objects:
			if action_user_target_object.weight == weight:
				action_user_target_objects_weight.append(action_user_target_object)
			
	return action_user_target_objects_weight
	
func _get_random_weight(var roll):
	if (roll >= 45):
		return 5
	elif(roll >= 25):
		return 4
	elif(roll >= 15):
		return 3
	elif(roll >= 10):
		return 2
	else:
		return 1
		
func _set_ai_action_targets_weight(var ai_action_target_users):
	ai_action_target_users = _set_weight_healing(ai_action_target_users)
	ai_action_target_users = _set_position_advantage(ai_action_target_users)
	ai_action_target_users = _set_weight_type_advantage(ai_action_target_users)
	ai_action_target_users = _set_weight_lowest_hp(ai_action_target_users)
	ai_action_target_users = _set_ai_action_targets_multitarget(ai_action_target_users)
	ai_action_target_users = _set_weight_status(ai_action_target_users)
	
	return ai_action_target_users
	
func _set_weight_status(var ai_action_target_users):
	for ai_action_target in ai_action_target_users:
		if not ai_action_target.action.status_effect == null:
			ai_action_target.add_weight()
			ai_action_target.weight_reasons = ai_action_target.weight_reasons + 'status |'
			
	return ai_action_target_users
	
#func _set_cumulative_weight(var ai_action_targets):
#
#	var last_weight : int = 0
#	var cumulative_weight : int = 0
#	var mutiplicy : int = 0
#
#	for ai_action_target in ai_action_targets:
#		if last_weight < ai_action_target.weight:
#			last_weight = last_weight + 2
#		cumulative_weight = cumulative_weight + (ai_action_target.weight * last_weight) 
#		ai_action_target.cumulative_weight = cumulative_weight
#
#	return ai_action_targets
	
	
func _set_ai_action_targets_multitarget(var ai_action_target_users):
	for ai_action_target in ai_action_target_users:
		if ai_action_target.targets.size() > 1:
			ai_action_target.add_weight()
			ai_action_target.weight_reasons = ai_action_target.weight_reasons + 'multitarget |'
			
	return ai_action_target_users
	
func debug(var ai_action_target_users):
	for ai_action_target in ai_action_target_users:
		print('---')
		print('Action: ' + ai_action_target.action.name)
		print('User: ' + ai_action_target.user.name)
		print('Weight:' + String(ai_action_target.weight))
		print('Targets:')
		
		for target in ai_action_target.targets:
			print(target.name)
			
		print('Reason : ' + ai_action_target.weight_reasons)
			
func _set_weight_lowest_hp(var ai_action_target_users):
	for ai_action_target in ai_action_target_users:
		if ai_action_target.targets.size() > 1:
			continue
			
		var target_team_monster_lowest_hp = monster_manager.get_target_team_lowest_hp(ai_action_target.action, ai_action_target.user)
			
		if target_team_monster_lowest_hp == ai_action_target.targets[0]:
			ai_action_target.add_weight()
			ai_action_target.weight_reasons = ai_action_target.weight_reasons + 'lowest_hp |'
			
	return ai_action_target_users
	
func _set_weight_type_advantage(var ai_action_target_users):
	for ai_action_target in ai_action_target_users:
		if ai_action_target.targets.size() > 1:
			continue
			
		if action_manager.is_type_advantage(ai_action_target.action, ai_action_target.targets[0]):
			ai_action_target.add_weight()
			ai_action_target.weight_reasons = ai_action_target.weight_reasons + 'type_advantage |'
			
	return ai_action_target_users
			
func _set_weight_healing(var ai_action_target_users):
	for ai_action_target in ai_action_target_users:
		if action_manager.is_action_healing(ai_action_target.action):
			ai_action_target.weight_reasons = ai_action_target.weight_reasons + 'weight_healing |'
			ai_action_target.add_weight()
			
	return ai_action_target_users
			
func _set_position_advantage(var ai_action_target_users):
	for action_user_target in ai_action_target_users:
		if action_user_target.targets.size() > 1:
			continue
		
		var action = action_user_target.action
		var user = action_user_target.user
		var traget = action_user_target.targets[0]
		
		if action_manager.is_position_advantage(action, user, traget):
			action_user_target.weight_reasons = action_user_target.weight_reasons + 'position_advantage |'
			action_user_target.add_weight()
			
	return ai_action_target_users
	
func _set_ai_action_user_target(var actions_users):
	var ai_action_target_users : Array
	var initial_weight = 1
	
	for action_user in actions_users:
		var user = action_user.user
		var action = action_user.action
		var user_index = user.get_position_index()
		
		var team_target = monster_manager.get_action_target_team(action, user)
		var team_user = monster_manager.get_team_b()
		
		var targets = monster_manager.get_targets(user, action)
		
		if targets.all:
			ai_action_target_users.append(
				AI_ACTION_USER_TARGET.new(user, team_target, action, initial_weight))
		else:
			for index in targets.indexes:
				var target = monster_manager.get_action_target_team_monster(action, user, index)
				ai_action_target_users.append(
					AI_ACTION_USER_TARGET.new(user, [target], action, initial_weight))
					
	return ai_action_target_users

func _get_usable_actions_and_users():
	var actions = _get_action_user_array()
	return _remove_unusable_actions(actions)
	
func _get_action_user_array():
	var action_user : Array
	var team_b = monster_manager.get_team_b_monsters_with_turn_remaining()
	
	for monster in team_b:
		var monster_actions = monster.get_actions()
		monster_actions = _remove_action_swap(monster_actions)
		for action in monster_actions:
			action_user.append(ACTION_USER.new(action, monster))
	
	return action_user
	
func _remove_action_swap(var monster_actions):
	monster_actions.remove(3)
	return monster_actions

func _remove_unusable_actions(var actions : Array):
	var action_points_remaining = game_manager.get_action_points()
	
	var usable_actions : Array
	
	for action in actions:
		if action_points_remaining >= action.cost:
			usable_actions.append(action)
			
	return usable_actions
	
