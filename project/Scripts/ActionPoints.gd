extends Label

onready var game_manager = get_node('/root/Control/GameManager')

func _ready():
	get_child(0).play("New Anim")

func _process(var delta):
	text = String(game_manager.get_action_points())
