extends Node

onready var control = get_parent()

onready var monster_manager = get_node('/root/Control/MonsterManager')
onready var game_manager = get_node('/root/Control/GameManager')
onready var action_animations = get_node('/root/Control/AttackAnimations')

#func _set_targets():
#	var input_group = control.get_input_group()
#	var targets_team = monster_manager.get_target_team()
#	var targets = monster_manager.get_selected_action_targets()
#
#	if not input_group == INPUT_GROUP.TARGET or not input_group == INPUT_GROUP.ACTION:
#		targets_team = null
#		targets = null
#		return

func do_action(var action : Action, var user : Monster, var targets : Array, var target2 : Monster):
	control.lock_inputs()
	_do_animations(action, targets)
	user.set_turn_availabale(false) 
	
	game_manager.deduct_action_points(action.cost)
	_do_damage(action, user, targets)
	_do_status_effect(action, targets)
	_do_swap(action, user, targets, target2)

	control.reset_inputs()
	
func _do_animations(var action, var targets):
	if action.action_name == ACTION_NAMES.Fire_Ball:
		_do_animation_fireball(targets)
	
func _do_animation_fireball(var targets):
	var sprite = action_animations.get_node('Fireball')
	sprite.global_position = targets[0].global_position
	sprite.global_position.x = sprite.global_position.x - 100
	sprite.get_node('AnimationPlayer').play('New Anim')
	sprite.get_node('AnimationPlayer').play('New Anim')
	targets[0]._do_hit_ani()
	_do_flast(sprite, 0.5)
	
func _do_flast(var animated_sprite, var delay):
	yield(get_tree().create_timer(delay), "timeout")
	animated_sprite.material.set_shader_param("flash_color", Color(1,1,1,1))
	animated_sprite.material.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(0.5), "timeout")
	animated_sprite.material.set_shader_param("flash_modifier", 0)
	
func enough_points_for_action():
	var action = get_selected_action()
	
	if game_manager.get_action_points() < action.cost:
		return false
	
	return true
	
func _do_swap(var action : Action, var user: Monster, var targets : Array, var target2: Monster):
	var swap_one
	var swap_two
	
	if action.swap == null:
		return
	
	if not target2 == null:
		swap_one = target2
		if action.swap == ACTION_RANGE.ALLY:
			swap_two = user
		else:
			swap_two = targets[0]
	else:
		swap_one = user
		swap_two = targets[0]
			
	var position_index_swap_one = swap_one.get_position_index()
	var position_index_swap_two = swap_two.get_position_index()
	
	swap_one.set_position_index(position_index_swap_two)
	swap_two.set_position_index(position_index_swap_one)
	
func _get_effected_targets():
	var action = get_selected_action()
	var action_range = action.action_range

	var targets : Array

	if action_range == ACTION_RANGE.ALLY_ALL:
		targets = monster_manager.get_allies()
	elif action_range == ACTION_RANGE.FOE_ALL:
		targets = monster_manager.get_team_a()
	else:
		var target_index = control.get_index_target()
		var target = monster_manager.get_target()
		targets.append(target)
		
	return targets
	
func _do_damage(var action : Action, var user : Monster, var targets : Array):
	for target in targets:
		var damage = _get_damage(action, user, target)
		target.do_damage(damage)
		
func _do_status_effect(var action : Action, var targets : Array):
	var status_effect = action.status_effect
	
	if status_effect != Status_effect.NULL:
		for target in targets:
			target.set_status(status_effect)
			
func _get_damage(var action : Action, var user : Monster, var target : Monster):
	var damage = action.damage
	
	if damage == 0:
		return damage
		
	if is_type_advantage(action, target):
		if is_action_healing(action):
			damage = damage - 2
		else:
			damage = damage + 1
		
	if is_position_advantage(action, user, target):
		damage = damage + 1
		
	return damage
	
func selected_action_has_two_targets():
	var action = get_selected_action()
	return action_has_two_targets(action)

func action_has_two_targets(var action : Action):
	if action.action_name == ACTION_NAMES.Bonfire:
		return false
		
	if not action.damage == 0 and not action.swap == null:
		return true
	
	return false

func is_position_advantage(var action : Action, var user : Monster, var target : Monster):
	if _is_action_range_ally(action):
		return false
		
	if is_action_healing(action):
		return false
		
	var user_position = user.get_position_index()
	
	var target_position = target.get_position_index()
		
	if target_position == user_position:
		return true
		
	return false
	
func _is_action_range_ally(var action : Action):
	if action.action_range == ACTION_RANGE.ALLY:
		return true
		
	if action.action_range == ACTION_RANGE.ALLY_ALL:
		return true
		
	return false

func is_type_advantage(var action : Action, var target : Monster):
	var action_type = action.elemental_type
	var target_type_weakness = target.get_type_weakness()
	
	if action_type == target_type_weakness:
		return true
		
	return false
	
func is_action_healing(var action : Action):
	if action.damage < 0:
		return true
		
	return false
	
#func action_has_two_targets(var action):
#	if action.name == "Bonfire":
#		return false
#
#	if not action.damage == 0 and not action.swap == null:
#		return true
#
#	return false
	
func get_selected_action():
	var index_action = control.get_index_action()
	return get_selected_ally_actions()[index_action]

func get_selected_ally_actions():
	return monster_manager.get_selected_team_a().get_actions()
