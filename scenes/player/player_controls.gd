extends Node

@export
var motion = Vector2():
	set(value):
		# This will be sent by players, make sure values are within limits.
		motion = value.normalized()

func update():
	var m = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		m.x -= 1
	if Input.is_action_pressed("move_right"):
		m.x += 1
	if Input.is_action_pressed("move_up"):
		m.y -= 1
	if Input.is_action_pressed("move_down"):
		m.y += 1

	motion = m
	
