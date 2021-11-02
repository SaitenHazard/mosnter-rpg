extends Node2D

export (String, 'TeamA', 'TeamB') var team

onready var monsters : Array = get_node('/root/Control/TeamB').get_children()

onready var lifebars : Array = get_children()

func _process(delta):
	for i in monsters.size():
#		print(monsters[i].get_health_max())
		lifebars[i].max_value = monsters[i].get_health_max()
		lifebars[i].value = monsters[i].get_health_current()
