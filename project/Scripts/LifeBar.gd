extends Node2D

export (String, 'TeamA', 'TeamB') var team_select

onready var team : Array = get_node('/root/Control/'+team_select).get_children()

onready var lifebars : Array = get_children()

#var showing_status : bool = false

#var team_a_bar_positions : Array = [Vector2(150,34), Vector2(100,60), Vector2(50,87)]
#var team_b_bar_positions : Array = [Vector2(880,53), Vector2(930,80), Vector2(980,106)]

#func _ready():
#	_manage_status_show()
	
#func _manage_status_show():
#	while(true):
#		showing_status = false
#		yield(get_tree().create_timer(1.0), "timeout")
#		showing_status = true
#		yield(get_tree().create_timer(1.0), "timeout")

func _process(delta):
	_set_health()
#	_status_effect()

#func _set_health_bar_position():
#	_set_health_bar_position_team_a()
#	_set_health_bar_position_team_b()
#
#func _set_health_bar_position_team_a():
#	if team_select == 'TeamB':
#		return
#
#	for i in team.size():
#		var position_index = team[i].get_position_index()
#
#func _set_health_bar_position_team_b():
#	if team_select == 'TeamA':
#		return

func _set_health():
	for i in team.size():
		var health = team[i].get_health()
		var health_max = team[i].get_health_max()
		var position_index = team[i].get_position_index()
		
		lifebars[position_index].value = health
		lifebars[position_index].max_value = health_max
		lifebars[position_index].get_node('HealthText').text = str(health)
#
#func _status_effect():
#	for i in team.size():
#		var position_index = team[i].get_position_index()
#
#		var bleedcramp = lifebars[position_index].get_node("BleedCramp")
#		var bleed = lifebars[position_index].get_node("Bleed")
#		var cramp = lifebars[position_index].get_node("Cramp")
#
#		bleedcramp.visible = false
#		bleed.visible =  false
#		cramp.visible = false
#
#		if not showing_status:
#			continue
#
#		var is_bleed = team[i].get_status_bleed()
#		var is_paralyzed = team[i].get_status_paralyze()
#
#		if not is_bleed and not is_paralyzed:
#			continue
#
#		if is_bleed and is_paralyzed:
#			bleedcramp.visible = true
#			continue
#
#		if is_bleed:
#			bleed.visible = true
#			continue
#
#		if is_paralyzed:
#			cramp.visible = true
#			continue
