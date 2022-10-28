extends KinematicBody2D

const GRAVITY = 600.0
const WALK_SPEED = 200
const JUMP_FORCE = -300

var player_state = "normal"
var velocity = Vector2()

func _physics_process(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		if player_state == "launched":
			pass
			#velocity.y = JUMP_FORCE + abs(velocity.y)/2
		
		velocity.y += delta * GRAVITY
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_FORCE

	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.

	# The second parameter of "move_and_slide" is the normal pointing up.
	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0, -1))



func _on_launcher_entered(_body:Node):
	player_state = "launched"
