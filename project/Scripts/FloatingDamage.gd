extends Label

export var travel = Vector2(0, -50)
export var duration = 1
export var spread = PI/2

export (Color, RGBA) var color_damage
export (Color, RGBA) var color_heal

func show_value(value):
	if value == 0:
		return
	elif value < 0:
		self.modulate = color_heal
		value = value * -1
	else:
		self.modulate = color_damage
	
	self.rect_global_position.y = self.rect_global_position.y - 50
	text = str(value)
	# For scaling, set the pivot offset to the center.
	rect_pivot_offset = rect_size / 2
#	var movement = travel.rotated(rand_range(-spread, spread))
	var movement = travel.rotated(0)
	# Animate the position.
	$Tween.interpolate_property(self, "rect_position", rect_position,
			rect_position + movement, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	# Animate the fade-out.
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	if crit:
#		# Set the color and animate size for criticals.
#		modulate = Color(1, 0, 0)
#		$Tween.interpolate_property(self, "rect_scale", rect_scale*2, rect_scale,
#			0.4, Tween.TRANS_BACK, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()
