extends KinematicBody2D

class_name Player
const GRAVITY = 600.0
const WALK_SPEED = 200
const JUMP_FORCE = -300

var player_state = "normal"
var velocity = Vector2()

func _physics_process(delta):
	if is_on_floor():
		velocity.y = 10
	else:
		if player_state == "launched":
			velocity.y = JUMP_FORCE + abs(velocity.y)/2

		velocity.y += delta * GRAVITY
	
	if player_state == "sliding":
		if velocity.x > 0:
			velocity.x = WALK_SPEED 
		else:
			velocity.x = -WALK_SPEED 
		
		if is_on_wall():
			velocity.x = -velocity.x 
	else:
		if Input.is_action_pressed("left"):
			velocity.x = -WALK_SPEED
		elif Input.is_action_pressed("right"):
			velocity.x =  WALK_SPEED
		else:
			velocity.x = 0
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_FORCE
	


	move_and_slide(velocity, Vector2(0, -1))



func _on_launcher_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is KinematicBody2D:
		player_state = "launched"



func _on_launcher_exited(body_rid, body, body_shape_index, local_shape_index):
	player_state = "normal"


func _on_ice_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is KinematicBody2D:
		player_state = "sliding"


func _on_ice_exited(body_rid, body, body_shape_index, local_shape_index):
	player_state = "normal"
