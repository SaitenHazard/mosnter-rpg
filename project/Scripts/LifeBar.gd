extends Node2D

export (String, 'TeamAlly', 'TeamFoe') var team_select

onready var team : Array = get_node('/root/Control/'+team_select).get_children()

onready var lifebars : Array = get_children()

func _process(delta):
	for i in team.size():
		var health = team[i].get_health()
		var health_max = team[i].get_health_max()
		
		lifebars[i].value = health
		lifebars[i].max_value = health_max
		lifebars[i].get_node('HealthText').text = str(health) + '/' + str(health_max)
