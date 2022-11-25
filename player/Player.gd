extends KinematicBody2D

class_name Player
const GRAVITY = 600.0
const WALK_SPEED = 200
const JUMP_FORCE = -300

var is_master = false
var player_state = "normal"
var velocity = Vector2()
export var controls : Resource = null

func initialize(id):
	name = str(id)
	if id == Net.net_id:
		is_master = true
	else:
		pass

func _physics_process(delta):
	if is_master:
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
			if Input.is_action_pressed(controls.move_left):
				velocity.x = -WALK_SPEED
			elif Input.is_action_pressed(controls.move_right):
				velocity.x =  WALK_SPEED
			else:
				velocity.x = 0
			
			if Input.is_action_just_pressed(controls.jump) and is_on_floor():
				velocity.y = JUMP_FORCE

	move_and_slide(velocity, Vector2(0, -1))
	rpc_unreliable("update_position", position)


remote func update_position(pos):
	position = pos

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


func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	pass # Replace with function body.
