extends CanvasLayer

func _process(delta):
	$Container/Control/Heart.visible = Game.health >= 1
	$Container/Control/Heart2.visible = Game.health >= 2
	$Container/Control/Heart3.visible = Game.health >= 3
