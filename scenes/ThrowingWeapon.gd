extends Area2D

signal finished

export var SPEED = 100
export var DIRECTION = Vector2.RIGHT
export var DONE = false
export var DAMAGE = 1

func _ready():
	$AudioStreamPlayer2D.pitch_scale *= DAMAGE
	$AudioStreamPlayer2D.play()
	$AnimationPlayer.play("default")

func _physics_process(delta):
	if DONE: 
		$AudioStreamPlayer2D2.pitch_scale = rand_range(0.9 * DAMAGE, 1.1 * DAMAGE)
		$AudioStreamPlayer2D2.play()
		emit_signal("finished")
		DONE = false
	else:
		transform.origin += (DIRECTION * SPEED) * delta

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()

func _on_ThrowingWeapon_body_entered(body):
	if body.is_in_group("damagable"):
		body.damage(DAMAGE)
		$CollisionShape2D.call_deferred("set_disabled", true)
		$AnimationPlayer.play("done")

func _on_ThrowingWeapon_area_entered(area):
	if area.is_in_group("damagable"):
		area.damage(DAMAGE)
		$CollisionShape2D.call_deferred("set_disabled", true)
		$AnimationPlayer.play("done")
