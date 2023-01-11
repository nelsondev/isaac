extends Camera2D
class_name PlayerCamera

export var SHAKE_STRENGTH = Vector2.ZERO

func _physics_process(_delta):
	if SHAKE_STRENGTH != Vector2.ZERO:
		offset = Vector2(rand_range(-SHAKE_STRENGTH.x, SHAKE_STRENGTH.x), rand_range(-SHAKE_STRENGTH.y, SHAKE_STRENGTH.y))
	else:
		offset = offset.linear_interpolate(Vector2.ZERO, 0.5)
	
	SHAKE_STRENGTH = SHAKE_STRENGTH.linear_interpolate(Vector2.ZERO, 0.1)
