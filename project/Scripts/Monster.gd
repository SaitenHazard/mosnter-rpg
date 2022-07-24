extends Node2D

class_name Monster

var health_max : int
var health : int
var type_weakness
var position_index : int

var turn_available : bool = true

var actions : Array

var status = {
	BLEED = 0,
	CRAMP = 0,
}

var team

onready var monster_manager = get_node('/root/Control/MonsterManager')
onready var sound_manager = get_node('/root/Control/SoundManager')

onready var texture_bleed = preload('res://sprite/badges/bleed.png')
onready var texture_cramp = preload('res://sprite/badges/cramp.png')
onready var texture_crampbleed = preload('res://sprite/badges/crampbleed.png')

var FCT = preload("res://Scenes/FloatingText.tscn")

var attack_frame = 0
var hit_frame = 1

#var showing_status : bool

func initiate_turn():
	_do_bleed_damage()
	_decrease_status_count()
	set_turn_availabale(true)
	
func _manage_status_show():
	var StatusSprite = get_node('StatusSprite')
	
	while(true):
		StatusSprite.visible = false
		yield(get_tree().create_timer(0.5), "timeout")
		
		if is_dead():
			break
		
		if is_bleed() and is_cramp():
			StatusSprite.visible = true
			StatusSprite.texture = texture_crampbleed
		elif is_bleed():
			StatusSprite.visible = true
			StatusSprite.texture = texture_bleed
		elif is_cramp():
			StatusSprite.visible = true
			StatusSprite.texture = texture_cramp
		
		yield(get_tree().create_timer(1.0), "timeout")
	
#func _process(delta):
#	if name == 'Spook':
#		print(position_index)
	
func _do_bleed_damage():
	if not status.BLEED == 0:
		do_damage(1)
		do_do_floating('Bleed', FLOATING_COLORS.yellow)

func _ready():
	var animatedSprite = get_node('AnimatedSprite')
	animatedSprite.play('idle')
	_set_status_position()
	_manage_status_show()
	
func _set_status_position():
	if team == TEAM.B:
		get_node('StatusSprite').set_position(Vector2(-29, 34))
	else:
		get_node('StatusSprite').set_position(Vector2(29, 34))
	
func _decrease_status_count():
	if not status.BLEED == 0:
		status.BLEED = status.BLEED - 1
		if status.BLEED == 0:
			do_do_floating('Bleed', FLOATING_COLORS.red)
		
	if not status.CRAMP == 0:
		status.CRAMP = status.CRAMP - 1
		if status.CRAMP == 0:
			do_do_floating('Cramp', FLOATING_COLORS.red)
		
func do_action_animation(var delay : float):
	var animatedSprite = get_node('AnimatedSprite')
	animatedSprite.stop()
	animatedSprite.set_frame(attack_frame)
	animatedSprite.scale = Vector2(4.5,4.5)
	yield(get_tree().create_timer(delay), "timeout")
	animatedSprite.scale = Vector2(3,3)
	animatedSprite.play('idle')

func do_hit_ani():
	var animatedSprite = get_node('AnimatedSprite')
	var animation_player = animatedSprite.get_child(0)
	yield(get_tree().create_timer(0.5), "timeout")
	sound_manager.play_hit()
	animatedSprite.stop()
	animatedSprite.set_frame(hit_frame)
	animation_player.play('hit')
	_do_flast(Vector3(1,1,1))
	yield(get_tree().create_timer(0.7), "timeout")
	animatedSprite.play('idle')
	
func do_bonfire_ani():
	var color = convert_rgb_to_float(Vector3(239,125,87))
	color = Color(color.x, color.y, color.z, 1)
	var animated_sprite = get_child(0)
	animated_sprite.material.set_shader_param("flash_color", color)
	animated_sprite.material.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(0.5), "timeout")
	animated_sprite.material.set_shader_param("flash_modifier", 0)
	
func do_natural_remedy_ani():
	var color = convert_rgb_to_float(Vector3(167,240,112))
	color = Color(color.x, color.y, color.z, 1)
	var animated_sprite = get_node('AnimatedSprite')
	animated_sprite.material.set_shader_param("flash_color", color)
	animated_sprite.material.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(0.5), "timeout")
	animated_sprite.material.set_shader_param("flash_modifier", 0)
	
func do_healing_pulse_ani():
	var color = convert_rgb_to_float(Vector3(115,239,247))
	color = Color(color.x, color.y, color.z, 1)
	var animated_sprite = get_node('AnimatedSprite')

	animated_sprite.material.set_shader_param("flash_color", color)
	animated_sprite.material.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(0.25), "timeout")
	animated_sprite.material.set_shader_param("flash_modifier", 0)

	yield(get_tree().create_timer(0.1), "timeout")

	animated_sprite.material.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(0.4), "timeout")
	animated_sprite.material.set_shader_param("flash_modifier", 0)
	
func convert_rgb_to_float(var color : Vector3):
	var denominator = 255
	return color/denominator

func _do_flast(var color_vec3 : Vector3):
	var animated_sprite = get_node('AnimatedSprite')
	var color = Color(color_vec3.x, color_vec3.y, color_vec3.z, 1)
	animated_sprite.material.set_shader_param("flash_color", color)
	animated_sprite.material.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(0.5), "timeout")
	animated_sprite.material.set_shader_param("flash_modifier", 0)

func set_turn_availabale(var b : bool):
	turn_available = b
	
func is_turn_available():
	return turn_available
	
func get_position_index() -> int:
	return position_index

func set_position_index(var index):
	self.position_index = index
	_do_cramp_damage()
	
func _do_cramp_damage():
	if status.CRAMP < 0:
		do_damage(1)
		do_do_floating('Cramp', FLOATING_COLORS.red)
	
func set_team(var team):
	self.team = team
	
func get_team():
	return team
	
func _manage_status():
	if status.BLEED != 0:
		status.BLEED = status.BLEED - 1
		
	if status.PARALYZE != 0:
		status.PARALYZE = status.PARALYZE - 1
		
func is_bleed() -> int:
	return status.BLEED > 0
	
func is_cramp()  -> int:
	return status.CRAMP > 0

func set_status(var status):
	yield(get_tree().create_timer(0.5), "timeout")
	
	if status == Status_effect.NULL:
		return
		
	if status == Status_effect.BLEED:
		self.status.BLEED = 3
		
	if status == Status_effect.CRAMP:
		self.status.CRAMP = 3

func get_type_weakness():
	return type_weakness

func set_type(type_weakness):
	self.type_weakness = type_weakness
#	_set_sprite()
	
#func _set_sprite():
#	if type_weakness == ELEMENTAL_TYPE.WATER:
#		get_node('Sprite').texture = texture_monster_fire
#	elif type_weakness == ELEMENTAL_TYPE.FIRE:
#		get_node('Sprite').texture = texture_monster_grass
#	else:
#		get_node('Sprite').texture = texture_monster_water
		
func set_health(health : int):
	self.health_max = health
	self.health = health
	self.health = 1
	
func set_actions(action1, action2, action3, action4, action5):
	actions = [action1, action2, action3, action4, action5]
	
func get_health_max() -> int :
	return health_max
	
func get_health() -> int :
	return health
	
func get_actions() -> Array :
	return actions
	
func get_action(i : int) :
	return actions[i]
	
func test(damage : int = 0):
	pass
	
func do_damage(damage):
	yield(get_tree().create_timer(0.5), "timeout")
	health = health - damage
	
	if health < 0:
		health = 0
		
	if health > health_max:
		health = health_max
		
func _process(delta):
	if health == 0:
		do_death_ani()
		
func do_floating_damage(damage, type_advantage, position_advantage, critical, status, boosted):
	yield(get_tree().create_timer(0.5), "timeout")
	if damage < 0:
		do_do_floating(damage, FLOATING_COLORS.green)
	elif damage > 0:
		do_do_floating(damage, FLOATING_COLORS.red)
	
	if type_advantage:
		yield(get_tree().create_timer(0.5), "timeout")
		if damage < 0:
			do_do_floating('type+', FLOATING_COLORS.green)
		else:
			do_do_floating('type+', FLOATING_COLORS.red)
		
	if position_advantage:
		yield(get_tree().create_timer(0.5), "timeout")
		do_do_floating('pos+', FLOATING_COLORS.red)
		
	if critical:
		yield(get_tree().create_timer(0.5), "timeout")
		if damage < 0:
			do_do_floating('crit+', FLOATING_COLORS.green)
		else:
			do_do_floating('crit+', FLOATING_COLORS.red)
			
	if boosted:
		yield(get_tree().create_timer(0.5), "timeout")
		if damage < 0:
			do_do_floating('boost+', FLOATING_COLORS.green)
		else:
			do_do_floating('boost+', FLOATING_COLORS.red)
			
	if status == Status_effect.BLEED:
		yield(get_tree().create_timer(0.5), "timeout")
		do_do_floating('bleed+', FLOATING_COLORS.yellow)
	elif status == Status_effect.CRAMP:
		yield(get_tree().create_timer(0.5), "timeout")
		do_do_floating('cramp+', FLOATING_COLORS.yellow)
			
func do_do_floating(var text, var is_green):
	var fct = FCT.instance()
	add_child(fct)
	fct.show_value(text, is_green)
	
func do_death_ani():
	yield(get_tree().create_timer(1.5), "timeout")
	var animated_sprite = get_node('AnimatedSprite')
	animated_sprite.play('dead')
	
func is_dead():
	return health <= 0
