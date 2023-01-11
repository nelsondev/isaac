extends Node2D

class_name Movement

signal move_start
signal move_stop
signal moving

signal direction_changed(direction)

signal dive_start
signal dive_stop

export var SPEED = 100

var velocity = Vector2.ZERO
var input = Vector2.ZERO
var direction = "right"
var diving = false
var velocity_lock = false
var input_lock = false

# Lock
func lock_velocity():
	velocity_lock = true
func lock_velocity_to(velocity: Vector2):
	velocity_lock = true
	self.velocity = velocity
func lock_input():
	input_lock = true
func lock():
	velocity_lock = true
func lock_to(velocity: Vector2):
	velocity_lock = true
	self.velocity = velocity
func dive():
	if not input_lock and input != Vector2.ZERO and not diving:
		diving = true
		lock_input()
		emit_signal("dive_start")
func undive():
	diving = false
	emit_signal("dive_stop")
	unlock_input()

# Unlock
func unlock_velocity():
	velocity_lock = false
func unlock_input():
	input_lock = false
func unlock():
	velocity_lock = false

func execute(body: KinematicBody2D):
	
	var old_velocity = velocity
	var old_direction = direction
	
	if not input_lock:
		input = Vector2(
			Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 
			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		).normalized()
		
	if Input.is_action_just_pressed("roll"):
		dive()
	
	if not velocity_lock:
		velocity = input * SPEED
		velocity = body.move_and_slide(velocity)
	else:
		body.move_and_slide(velocity)
	
	if velocity.x != 0: direction = "right" if velocity.x > 0 else "left"
	if diving: return
	if old_velocity == Vector2.ZERO and velocity != Vector2.ZERO: emit_signal("move_start")
	if old_velocity != Vector2.ZERO and velocity == Vector2.ZERO: emit_signal("move_stop")
	if old_direction != direction: emit_signal("direction_changed", direction)
	if velocity != Vector2.ZERO and not diving: emit_signal("moving")
