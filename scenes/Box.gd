extends StaticBody2D

func damage(_amount):
	$Sprite.visible = false
	$CollisionPolygon2D.call_deferred("set_disabled", true)
	$Particles2D.restart()
	$Particles2D.emitting = true
	$AudioStreamPlayer2D.pitch_scale = rand_range(0.9, 1.1)
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D2.pitch_scale = rand_range(0.9, 1.1)
	$AudioStreamPlayer2D2.play()
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()
