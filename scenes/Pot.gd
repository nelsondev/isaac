extends Area2D

var health = 1

func damage(_amount):
	$Sprite.visible = false
	$Particles2D.restart()
	$Particles2D.emitting = true
	$CollisionShape2D.call_deferred("set_disabled", true)
	$AudioStreamPlayer2D.pitch_scale = rand_range(0.9, 1.1)
	$AudioStreamPlayer2D.play()
	
	yield(get_tree().create_timer(5.0), "timeout")
	queue_free()
