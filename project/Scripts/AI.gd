extends Node2D

onready var game_manager = get_node('/root/Control/GameManager')
onready var monster_manager = get_node('/root/Control/MonsterManager')
onready var action_manager = get_node('/root/Control/ActionManager')

var deciding_next_action : bool = false

class AI_ACTION_USER_TARGET:
	var user
	var targets
	var action
	var weight
	
	func _init(var user, var targets, var action, var weight):
		self.user = user
		self.targets = targets
		self.action = action
		self.weight = weight
		
	func add_weight():
		weight = weight + 1
		
class ACTION_USER:
	var action
	var user
	
	func _init(var action, var user):
		self.action = action
		self.user = user
	
func _process(var delta):
	_decide_action()
	
func _decide_action():
	var team_a_turn = game_manager.get_team_a_turn()
	
	if team_a_turn:
		return
		
	if deciding_next_action:
		return
		
	deciding_next_action = true
	
	var action_user = _get_action_user_array()
	var ai_action_targets = _set_ai_action_user_target(action_user)
	ai_action_targets = _set_ai_action_targets_weight(ai_action_targets)
	
func _set_ai_action_targets_weight(var ai_action_targets):
	ai_action_targets = _set_weight_healing(ai_action_targets)
	ai_action_targets = _set_position_advantage(ai_action_targets)
	ai_action_targets = _set_weight_type_advantage(ai_action_targets)
	ai_action_targets = _set_weight_lowest_hp(ai_action_targets)
	
func _set_weight_lowest_hp(var ai_action_targets):
	pass
	
func _set_weight_type_advantage(var ai_action_targets):
	pass
	for ai_action_target in ai_action_targets:
		var target = monster_manager.get_foes()
		if monster_manager.is_type_advantage(target, ai_action_target.action):
			ai_action_target.add_weight()
	
func _set_weight_healing(var ai_action_targets):
	for ai_action_target in ai_action_targets:
		if action_manager.is_action_healing(ai_action_target.action):
			ai_action_target.add_weight()
			
	return ai_action_targets
			
func _set_position_advantage(var action_user_targets):
	for action_user_target in action_user_targets:
		if typeof(action_user_target.targets) == TYPE_ARRAY:
			continue
		
		var action = action_user_target.action
		var user_index = action_user_target.user.get_position_index()
		var traget_index = action_user_target.targets.get_position_index()
		
		if action_manager.is_position_advantage(action, user_index, traget_index):
			action_user_targets.add_weight()
	
	return action_user_targets
	
func _set_ai_action_user_target(var actions_users):
	var initial_weight = 1
	var action_user_targets : Array
	
	for action_user in actions_users:
		var user = action_user.user
		var action = action_user.action
		var user_index = user.get_position_index()
		
		var team_target = monster_manager.get_action_target_team(action, user)
		var team_user = monster_manager.get_team_b()
		
		var targets = monster_manager.get_targets(user_index, team_user, team_target, action)
		
		if targets.all:
			action_user_targets.append(
				AI_ACTION_USER_TARGET.new(user, team_target, action, initial_weight))
		else:
			for index in targets.indexes:
				var target = monster_manager.get_action_target_team_monster(action, user)
				action_user_targets.append(
					AI_ACTION_USER_TARGET.new(user, target, action, initial_weight))
					
		return action_user_targets

func _get_usable_actions_and_users():
	var actions = _get_action_user_array()
	return _remove_unusable_actions(actions)
	
func _get_action_user_array():
	var action_user : Array
	var team_b = monster_manager.get_team_b_monsters_with_turn_remaining()
	
	for monster in team_b:
		var monster_actions = monster.get_actions()
		for action in monster_actions:
			action_user.append(ACTION_USER.new(action, monster))
			
	return action_user

func _remove_unusable_actions(var actions : Array):
	var action_points_remaining = game_manager.get_action_points()
	
	var usable_actions : Array
	
	for action in actions:
		if action_points_remaining >= action.cost:
			usable_actions.append(action)
			
	return usable_actions
	
