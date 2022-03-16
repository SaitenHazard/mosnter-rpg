extends Node

onready var action_animations_gameObject = get_node('/root/Control/AttackAnimations')

func do_swap_animations(var target1, var target2):
	target1.do_action_animation(0.5)
	target2.do_action_animation(0.5)

func do_animations(var action, var targets, var user):
	if action.damage == null:
		return
		
	var user_ani_delay : float  = 0
		
	if action.action_name == ACTION_NAMES.Fire_Ball:
		var fireball = action_animations_gameObject.get_node('Fireball')
		user_ani_delay = 1
		_fireball(fireball, targets[0])
		
	if action.action_name == ACTION_NAMES.Icicle_Drop:
		user_ani_delay = 1
		_icicle_blade(targets[0])
		
	if action.action_name == ACTION_NAMES.Fire_Blitz:
		user_ani_delay = 1
		_fireblitz(targets)
		
	if action.action_name == ACTION_NAMES.Bamboo_Bash:
		user_ani_delay = 1
		_bamboo_bash(targets[0])
		
	if action.action_name == ACTION_NAMES.Healing_Pulse:
		user_ani_delay = 1
		_healing_pulse(targets)
		
	if action.action_name == ACTION_NAMES.Bonfire:
		user_ani_delay = 1
		_bonfire(targets[0])
		
	if action.action_name == ACTION_NAMES.Natural_Remedy:
		user_ani_delay = 1
		_natural_remedy(targets[0])	
		
	if action.action_name == ACTION_NAMES.Swift_Surf:
		user_ani_delay = 1
		_swfit_surf(targets[0])	
		
	if action.action_name == ACTION_NAMES.Sticky_Seeds:
		user_ani_delay = 1
		_sticky_seeds(targets[0])
		
	user.do_action_animation(user_ani_delay)
	
func _sticky_seeds(var target):
	var sprite = action_animations_gameObject.get_node('Seed')
	sprite.global_position = target.global_position
	
	if target.get_team() == TEAM.A:
		sprite.get_node('AnimationPlayer').play('New Anim (copy)')
		sprite.global_position.x = sprite.global_position.x + 100
	else:
		sprite.global_position.x = sprite.global_position.x - 100
		sprite.get_node('AnimationPlayer').play('New Anim')
	
	target.do_hit_ani()
	_do_flast(sprite, 0.5)
	
func _swfit_surf(var target):
	var sprite = action_animations_gameObject.get_node('Wave')
	sprite.global_position = target.global_position
	
	sprite.global_position.y = sprite.global_position.y + 25

	if target.get_team() == TEAM.A:
		sprite.global_position.x = sprite.global_position.x + 100
		sprite.get_node('AnimationPlayer').play('New Anim (copy)')
	else:
		sprite.global_position.x = sprite.global_position.x - 100
		sprite.get_node('AnimationPlayer').play('New Anim')
	
	target.do_hit_ani()
	_do_flast(sprite, 0.5)
	
func _natural_remedy(var target):
	var sprite = action_animations_gameObject.get_node('Leaf')
	sprite.global_position = target.global_position
	sprite.global_position.y = sprite.global_position.y - 100
	sprite.visible = true
	sprite.get_node('AnimationPlayer').play('New Anim')
	_do_flast(sprite, 0.5)
	
	yield(get_tree().create_timer(0.5), "timeout")
	target.do_natural_remedy_ani()
	
func _bonfire(var target):
	target.do_bonfire_ani()
	var sprite = action_animations_gameObject.get_node('Bonfire')
	
	if target.get_team() == TEAM.A:
		sprite.global_position.x = 308
	else:
		sprite.global_position.x = 748
	
	sprite.visible = true
	sprite.get_node('AnimationPlayer').play('New Anim')
	
func _healing_pulse(var targets):
	var sprite = action_animations_gameObject.get_node('Pulse')
	sprite.global_position.y = 367
	
	if targets[0].get_team() == TEAM.A:
		sprite.global_position.x = 320
	else:
		sprite.global_position.x = 740
	
	sprite.get_node('AnimationPlayer').play('New Anim')
	targets[0].do_healing_pulse_ani()
	targets[1].do_healing_pulse_ani()
	targets[2].do_healing_pulse_ani()
		
func _bamboo_bash(var target):
	var sprite = action_animations_gameObject.get_node('Bamboo')
	sprite.global_position = target.global_position
	
	if target.get_team() == TEAM.A:
		sprite.global_position.x = sprite.global_position.x + 100
		sprite.get_node('AnimationPlayer').play('New Anim (copy)')
#		sprite.get_node('AnimationPlayer').play('New Anim')
	else:
		sprite.global_position.x = sprite.global_position.x - 100
		sprite.get_node('AnimationPlayer').play('New Anim')
	
	target.do_hit_ani()
	_do_flast(sprite, 0.5)
		
func _icicle_blade(var target):
	var sprite = action_animations_gameObject.get_node('Icicle')
	sprite.global_position = target.global_position

	if target.get_team() == TEAM.A:
		sprite.global_position.y = sprite.global_position.y - 80
		sprite.global_position.x = sprite.global_position.x + 20
	else:
		sprite.global_position.y = sprite.global_position.y - 80
		sprite.global_position.x = sprite.global_position.x - 20
		
	sprite.get_node('AnimationPlayer').play('New Anim')
	target.do_hit_ani()
	_do_flast(sprite, 0.5)
		
func _fireblitz(var targets):
	var fireball = action_animations_gameObject.get_node('Fireball')
	var fireball2 = action_animations_gameObject.get_node('Fireball2')
	var fireball3 = action_animations_gameObject.get_node('Fireball3')
	_fireball(fireball, targets[0])
	_fireball(fireball2, targets[1])
	_fireball(fireball3, targets[2])
	
func _fireball(var sprite, var target):
	sprite.global_position = target.global_position
	
	if target.get_team() == TEAM.A:
		sprite.get_node('AnimationPlayer').play('New Anim (copy)')
		sprite.global_position.x = sprite.global_position.x + 100
	else:
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
