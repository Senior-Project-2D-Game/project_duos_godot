extends KinematicBody2D

class_name Player
const GRAVITY = 600.0
const SPEED = 200
const JUMP_FORCE = 300
const UP_DIRECTION = Vector2.UP

var is_master = false
var is_player1 = false
var player_state = "normal"
var _velocity = Vector2.ZERO
export var controls : Resource = null

func _physics_process(delta):
	if Net.is_host:
		var is_falling = _velocity.y > 0.0 and not is_on_floor()
		var is_jumping = Input.is_action_just_pressed(controls.jump) and is_on_floor()
		var is_jump_cancelled = Input.is_action_just_released(controls.jump) and _velocity.y < 0.0
		var is_idling = is_on_floor() and is_zero_approx(_velocity.x)
		var is_running = is_on_floor() and not is_zero_approx(_velocity.x)
		var is_launched = player_state == "launched"
		var is_sliding = player_state == "sliding"
		
		var _horizontal_direction = (
			Input.get_action_strength(controls.move_right)
			- Input.get_action_strength(controls.move_left)
		)
		_velocity.y += GRAVITY * delta 
		
		if is_sliding:
			_velocity.x = sign(_velocity.x) * SPEED
			
			if is_on_wall():
				_velocity.x = -_velocity.x
		else:
			_velocity.x = _horizontal_direction * SPEED
			if is_jumping:
				_velocity.y = -JUMP_FORCE
			elif is_launched:
				_velocity.y = -JUMP_FORCE + abs(_velocity.y)/2
			elif is_jump_cancelled:
				_velocity.y = 0.0
	else:
		var is_falling = _velocity.y > 0.0 and not is_on_floor()
		var is_jumping = Input.is_action_just_pressed(controls.jump) and is_on_floor()
		var is_jump_cancelled = Input.is_action_just_released(controls.jump) and _velocity.y < 0.0
		var is_idling = is_on_floor() and is_zero_approx(_velocity.x)
		var is_running = is_on_floor() and not is_zero_approx(_velocity.x)
		var is_launched = player_state == "launched"
		var is_sliding = player_state == "sliding"
		
		var _horizontal_direction = (
			Input.get_action_strength(controls.move_right)
			- Input.get_action_strength(controls.move_left)
		)
		_velocity.y += GRAVITY * delta 
		
		if is_sliding:
			_velocity.x = sign(_velocity.x) * SPEED
			
			if is_on_wall():
				_velocity.x = -_velocity.x
		else:
			_velocity.x = _horizontal_direction * SPEED
			if is_jumping:
				_velocity.y = -JUMP_FORCE
			elif is_launched:
				_velocity.y = -JUMP_FORCE + abs(_velocity.y)/2
			elif is_jump_cancelled:
				_velocity.y = 0.0	

	_velocity = move_and_slide(_velocity, UP_DIRECTION)
	rpc_unreliable("update_position", position)
	


func initialize(id):
	name = str(id)
	if id == Net.net_id:
		is_master = true
	else:
		pass


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

