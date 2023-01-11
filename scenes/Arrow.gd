extends Sprite

var time = 0

func _process(delta):
	time += delta
	position.y += cos(time * 3) * 0.03
