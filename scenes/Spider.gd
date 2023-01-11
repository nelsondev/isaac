extends Area2D

export var time = 0
var scalar = 1.0
var health = 6
var timer = Timer.new()
var y_offset = -256
onready var x_offset = transform.origin.x
onready var x_offset_start = transform.origin.x

func _draw():
	var end = Vector2(x_offset_start + (-x_offset), y_offset)
	
	draw_line(Vector2.ZERO, end, Color.white)
	
func _ready():
	timer.one_shot = true
	timer.wait_time = 0.5
	timer.autostart = false
	timer.connect("timeout", self, "adjust_speed")
	add_child(timer)
	$AnimatedSprite.material = $AnimatedSprite.material.duplicate(true)
	
func _process(delta):
	time += delta * scalar
	transform.origin.x = x_offset_start + (32.0 * sin(time * 2.0))
	$AnimatedSprite.rotation = lerp_angle($AnimatedSprite.rotation, transform.origin.normalized().x * -0.2, 0.1)
	if floor(transform.origin.x) == 0: 
		$AudioStreamPlayer2D_Whoosh.pitch_scale = rand_range(1.2, 1.5)
		$AudioStreamPlayer2D_Whoosh.play()
		$AudioStreamPlayer2D_Spider.play()
	if health <= 0:
		y_offset = lerp(y_offset, 0, 0.2)
		x_offset = lerp(x_offset, transform.origin.x, 0.2)
	else:
		x_offset = transform.origin.x
	update()
	
func damage(amount):
	health -= amount
	
	if health <= 0:
		scalar = 0
		$AudioStreamPlayer2D.pitch_scale = rand_range(0.65, 0.8)
		$AudioStreamPlayer2D.play()
		$AudioStreamPlayer2D.volume_db = 20.0
		$AnimatedSprite.stop()
		$AnimationPlayer.stop()
		$AudioStreamPlayer2D.pitch_scale = rand_range(0.9, 1.1)
		$AudioStreamPlayer2D_Death.play()
		$AnimationPlayer.play("hit")
		$CollisionShape2D.call_deferred("set_disabled", true)
		$Particles2D.emitting = true
		$Particles2D2.emitting = true
		$AnimatedSprite.visible = false
		timer.stop()
		yield(get_tree().create_timer(2.0), "timeout")
		queue_free()
	else:
		$AnimationPlayer.stop()
		$AnimationPlayer.play("hit")
		$AudioStreamPlayer2D.play()
		scalar += 1
		timer.stop()
		timer.start()
	
func adjust_speed():
	scalar = 1.0
