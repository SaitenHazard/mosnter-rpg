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
	PARALYZE = 0,
}

var team

var texture_monster_fire = preload('res://sprite/monster_fire.png')
var texture_monster_water = preload('res://sprite/monster_water.png')
var texture_monster_grass = preload('res://sprite/monster_grass.png')

var attack_frame = 0
var hit_frame = 1

func _ready():
	var animatedSprite = get_child(0)
	animatedSprite.play('idle')

func do_action_animation(var delay : float):
	var animatedSprite = get_child(0)
	animatedSprite.stop()
	animatedSprite.set_frame(attack_frame)
	animatedSprite.scale = Vector2(4.5,4.5)
	yield(get_tree().create_timer(delay), "timeout")
	animatedSprite.scale = Vector2(3,3)
	animatedSprite.play('idle')

func do_hit_ani():
	var animatedSprite = get_child(0)
	var animation_player = get_child(0).get_child(0)
	yield(get_tree().create_timer(0.5), "timeout")
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
	var animated_sprite = get_child(0)
	animated_sprite.material.set_shader_param("flash_color", color)
	animated_sprite.material.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(0.5), "timeout")
	animated_sprite.material.set_shader_param("flash_modifier", 0)
	
func do_healing_pulse_ani():
	var color = convert_rgb_to_float(Vector3(115,239,247))
	color = Color(color.x, color.y, color.z, 1)
	var animated_sprite = get_child(0)

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
	var animated_sprite = get_child(0)
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
	
func set_team(var team):
	self.team = team
	
func get_team():
	return team
	
func _manage_status():
	if status.BLEED != 0:
		status.BLEED = status.BLEED - 1
		
	if status.PARALYZE != 0:
		status.PARALYZE = status.PARALYZE - 1

func set_status(var status):
	if status == Status_effect.BLEED:
		self.status.BLEED = 4
		
	if status == Status_effect.PARALYZE:
		self.status.PARALYZE = 2

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
	health = health * 2
	health = 1
	self.health_max = health
	self.health = health
	
func set_actions(action1, action2, action3, action4):
	actions = [action1, action2, action3, action4]
	
func get_health_max() -> int :
	return health_max
	
func get_health() -> int :
	return health
	
func get_actions() -> Array :
	return actions
	
func get_action(i : int) :
	return actions[i]
	
func do_damage(var damage : int):
	health = health - damage
	
	if health < 0:
		health = 0
		
	if health > health_max:
		health = health_max
		
	if health == 0:
		do_death_ani()
		
func do_death_ani():
	yield(get_tree().create_timer(1.5), "timeout")
	var animated_sprite = get_child(0)
	animated_sprite.play('dead')
