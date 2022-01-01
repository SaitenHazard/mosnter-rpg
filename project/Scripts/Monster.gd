extends Node2D

var health_max : int
var health : int
var type_weakness
var position_index : int

var actions : Array

var status = {
	BLEED = 0,
	PARALYZE = 0,
}

var team
var team_ally_positions : Array = [Vector2(290,230), Vector2(380,312), Vector2(290,420)]
var team_foe_positions : Array = [Vector2(660,230), Vector2(580,310), Vector2(660,410)]

var index = 0

var texture_monster_fire = preload('res://sprite/monster_fire.png')
var texture_monster_water = preload('res://sprite/monster_water.png')
var texture_monster_grass = preload('res://sprite/monster_grass.png')

func get_index():
	return index

func set_index(var index):
	self.index = index
	set_position_()
	
func set_team(var team):
	self.team = team
	
func set_position_():
	if team == TEAM.ALLY:
		position = team_ally_positions[index]
	else:
		position = team_foe_positions[index]

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

func get_position_index() -> int:
	return position_index
	
func set_position_index(position_index):
	self.position_index = position_index

func get_type_weakness():
	return type_weakness

func set_type(type_weakness):
	self.type_weakness = type_weakness
	_set_sprite()
	
func _set_sprite():
	if type_weakness == ELEMENTAL_TYPE.WATER:
		get_node('Sprite').texture = texture_monster_fire
	elif type_weakness == ELEMENTAL_TYPE.FIRE:
		get_node('Sprite').texture = texture_monster_grass
	else:
		get_node('Sprite').texture = texture_monster_water
		
func set_health(health : int):
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
