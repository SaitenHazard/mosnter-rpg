extends Label

onready var game_manager = get_node('/root/Control/GameManager')

func _process(var delta):
	text = String(game_manager.get_action_points())
