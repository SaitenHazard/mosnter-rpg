extends Node

onready var action_animations = get_node('/root/Control/AttackAnimations')

func do_swap_animations(var target1, var target2):
	target1.do_action_animation()
	target2.do_action_animation()

func do_animations(var action, var targets, var user):
	if action.damage == null:
		return
		
	user.do_action_animation()
	if action.action_name == ACTION_NAMES.Fire_Ball:
		var fireball = action_animations.get_node('Fireball')
		_fireball(fireball, targets[0])
		return
		
	if action.action_name == ACTION_NAMES.Icicle_Blade:
		_icicle_blade(targets[0])
		return
		
	if action.action_name == ACTION_NAMES.Fire_Blitz:
		_fireblitz(targets)
		return	
		
	if action.action_name == ACTION_NAMES.Bamboo_Bash:
		_bamboo_bash(targets[0])
		return
		
func _bamboo_bash(var target):
	var sprite = action_animations.get_node('Bamboo')
	sprite.global_position = target.global_position
#	sprite.global_position.y = sprite.global_position.y - 80
	sprite.global_position.x = sprite.global_position.x - 100
	sprite.get_node('AnimationPlayer').play('New Anim')
	target.do_hit_ani()
	_do_flast(sprite, 0.5)
		
func _icicle_blade(var target):
	var sprite = action_animations.get_node('Icicle')
	sprite.global_position = target.global_position
	sprite.global_position.y = sprite.global_position.y - 80
	sprite.global_position.x = sprite.global_position.x - 20
	sprite.get_node('AnimationPlayer').play('New Anim')
	target.do_hit_ani()
	_do_flast(sprite, 0.5)
		
func _fireblitz(var targets):
	var fireball = action_animations.get_node('Fireball')
	var fireball2 = action_animations.get_node('Fireball2')
	var fireball3 = action_animations.get_node('Fireball3')
	_fireball(fireball, targets[0])
	_fireball(fireball2, targets[1])
	_fireball(fireball3, targets[2])
	
func _fireball(var sprite, var target):
	sprite.global_position = target.global_position
	sprite.global_position.x = sprite.global_position.x - 100
	sprite.get_node('AnimationPlayer').play('New Anim')
	target.do_hit_ani()
	_do_flast(sprite, 0.5)
	
func _do_flast(var animated_sprite, var delay):
	yield(get_tree().create_timer(delay), "timeout")
	animated_sprite.material.set_shader_param("flash_color", Color(1,1,1,1))
	animated_sprite.material.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(0.5), "timeout")
	animated_sprite.material.set_shader_param("flash_modifier", 0)
