extends Label

onready var game_manager = get_node('/root/Control/GameManager')

func _process(var delta):
	print(game_manager.get_action_points())
	text = String(game_manager.get_action_points())
