extends KinematicBody2D

export var SPEED = 10

var state = ""
var input = Vector2.ZERO
var input_last = Vector2.RIGHT
var direction = "right"
var WEAPON = preload("res://scenes/ThrowingWeapon.tscn")
var CAMP = preload("res://scenes/Camp.tscn")
var enabled = true
var damage_scalar = 1.0

func _physics_process(_delta):
	if not enabled: return
	
	direction = "right" if input_last.x > 0 else "left"
	
	$Sprite.flip_h = direction == "left"
	$Particles2D.scale.x = -1 if direction == "right" else 1
	
	var tool_input = Vector2(
		Input.get_action_strength("tool_right") - Input.get_action_strength("tool_left"),
		Input.get_action_strength("tool_down") - Input.get_action_strength("tool_up")
	)
	
	if tool_input != Vector2.ZERO:
		$Position2D.rotation = tool_input.angle()
		$Position2D/Area2D/Crosshair.rotation = -tool_input.angle()
		$Position2D/Area2D/Tool.flip_v = tool_input.x < 0
		$Camera2D.offset = $Camera2D.offset.linear_interpolate(tool_input * 5, 1.0)
	
	if $AnimationPlayer.current_animation == "RESET":
		return
	if Input.is_action_just_pressed("roll"): 
		$AnimationPlayer.play("roll")
	if Input.is_action_pressed("action") and $Position2D/Area2D/Tool.visible and tool_input != Vector2.ZERO:
		var weapon = WEAPON.instance()
		weapon.connect("finished", self, "_on_ThrowingWeapon_finished")
		$Position2D/Area2D/Tool.visible = false
		$Position2D/Area2D/Tool.scale = Vector2(0, 0)
		Game.get_level().add_child(weapon)
		weapon.set_global_position($Position2D/Area2D.get_global_position())
		weapon.DIRECTION = tool_input
		weapon.DAMAGE *= damage_scalar
		weapon.SPEED *= damage_scalar
	if Input.is_action_just_pressed("action_2") and tool_input != Vector2.ZERO:
		var camp = CAMP.instance()
		Game.get_level().add_child(camp)
		camp.set_global_position($Position2D/Area2D/Crosshair.get_global_position())
	
	if $Position2D/Area2D/Tool.visible:
		$Position2D/Area2D/Tool.scale = $Position2D/Area2D/Tool.scale.linear_interpolate(Vector2(1, 1), 0.2)
	
	if $AnimationPlayer.current_animation == "roll":
		$Sprite.rotation_degrees = lerp($Sprite.rotation_degrees, 90 if direction == "right" else -90, 0.5)
		$Hat.rotation_degrees = lerp($Hat.rotation_degrees, 90 if direction == "right" else -90, 0.5)
		$CollisionShape2D.disabled = true
		$Area2D/CollisionPolygon2D.disabled = false
		move_and_slide(input_last * SPEED, Vector2.UP)
	else:
		$CollisionShape2D.disabled = false
		$Sprite.rotation_degrees = lerp($Sprite.rotation_degrees, 0, 0.25)
		$Hat.rotation_degrees = lerp($Hat.rotation_degrees, 0, 0.25)
		$Area2D/CollisionPolygon2D.disabled = true
		
		input = Vector2(
			Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 
			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		).normalized()
			
		if input != Vector2.ZERO:
			input_last = input
			$AnimationPlayer.play("walk")
		else:
			$AnimationPlayer.play("idle")
		
		move_and_slide(input * SPEED, Vector2.UP)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "roll": 
		$AnimationPlayer.play("RESET")
		SPEED = 60

func _on_ThrowingWeapon_finished():
	$Position2D/Area2D/Tool.visible = true
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("dashable"):
		body.damage(1.0)
		
func _on_Area2D_area_entered(area):
	if area.is_in_group("dashable"):
		area.damage(1.0)
