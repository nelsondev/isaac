extends Sprite

export var LEVEL = 1
export var ENABLED = false

func _on_Area2D_body_entered(body):
	Game.set_level(LEVEL)
	$AudioStreamPlayer2D_Activate.play()
