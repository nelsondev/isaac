extends Particles2D

var INSIDE = false

func _process(delta):
	if INSIDE:
		modulate.a = lerp(modulate.a, 0.0, 0.5)
	else:
		modulate.a = lerp(modulate.a, 1.0, 0.04)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		INSIDE = true
	
func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		INSIDE = false
