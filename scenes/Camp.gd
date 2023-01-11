extends Area2D

var health = 3
var player_inside = false
var timer = Timer.new()
export var enabled = false

func _ready():
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = false
	timer.connect("timeout", self, "add_health")

func damage(amount):
	health -= 1
	
	if health > 0:
		$Particles2D.amount /= health * 2
		$Particles2D2.amount /= health * 2
		$AudioStreamPlayer2D_Fire.pitch_scale -= 0.2
	
	if health <= 0:
		enabled = false
		$Particles2D_Explode.emitting = true
		$Camp.visible = false
		$Camp0.visible = false
		$Camp1.visible = false
		$Particles2D.visible = false
		$Particles2D2.visible = false
		$AudioStreamPlayer2D_Fire.playing = false
		$AudioStreamPlayer2D_Break.playing = true
		$AudioStreamPlayer2D_Break2.playing = true
		$Tween.interpolate_property($Light2D, "energy", $Light2D.energy, 0.0, 0.5)
		$Tween.start()
		$CollisionShape2D.call_deferred("set_disabled", true)
		yield(get_tree().create_timer(5.0), "timeout")
		queue_free()

func _process(delta):
	$Particles2D_Health.emitting = enabled and player_inside and Game.health < Game.health_max
	$Particles2D_Upgrade.emitting = enabled and player_inside

func add_health():
	if Game.health < Game.health_max and enabled:
		$AudioStreamPlayer2D_Ahhh.pitch_scale += 0.1
		$AudioStreamPlayer2D_Ahhh.play() 
		Game.get_camera().SHAKE_STRENGTH = Vector2(0.5, 0.5)
		Game.health += 1

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$AudioStreamPlayer2D_Ahhh.pitch_scale = 1.0
		timer.start()
		player_inside = true
		body.damage_scalar = 2.0

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		timer.stop()
		player_inside = false
		body.damage_scalar = 1.0
