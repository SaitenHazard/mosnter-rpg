extends Node2D

export (String, 'TeamA', 'TeamB') var team

onready var monsters : Array = get_node('/root/Control/'+team).get_children()

onready var lifebars : Array = get_children()

func _process(delta):
	for i in monsters.size():
		var health_current = monsters[i].get_health_max()
		var health_max = monsters[i].get_health_current()
		
		lifebars[i].value = health_current
		lifebars[i].max_value = health_max
		lifebars[i].get_node('HealthText').text = str(health_current) + '/' + str(health_max)
