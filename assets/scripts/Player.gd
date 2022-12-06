extends KinematicBody2D

class_name Player

const GRAVITY = 600.0
const SPEED = 200
const JUMP_FORCE = 300
const UP_DIRECTION = Vector2.UP
var player_state = "normal"
var _velocity = Vector2.ZERO

puppet var puppet_position = Vector2(0,0) setget puppet_position_set

onready var tween = $Tween

func _physics_process(delta):
	if is_network_master():
		var is_falling = _velocity.y > 0.0 and not is_on_floor()
		var is_jumping = Input.is_action_just_pressed("p1_jump") and is_on_floor()
		var is_jump_cancelled = Input.is_action_just_released("p1_jump") and _velocity.y < 0.0
		var is_idling = is_on_floor() and is_zero_approx(_velocity.x)
		var is_running = is_on_floor() and not is_zero_approx(_velocity.x)
		var is_launched = player_state == "launched"
		var is_sliding = player_state == "sliding"

		var _horizontal_direction = (
			Input.get_action_strength("p1_move_right")
			- Input.get_action_strength("p1_move_left")
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
#	rpc_unreliable("update_position", position)  # makes it gittery
	

func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	
	tween.interpolate_property(self, 'global_position', global_position, puppet_position, 0.1)
	tween.start()

func _on_network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)

func _on_launcher_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is KinematicBody2D:
		body.player_state = "launched"

func _on_launcher_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is KinematicBody2D:
		body.player_state = "normal"

func _on_ice_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is KinematicBody2D:
		body.player_state = "sliding"


func _on_ice_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is KinematicBody2D:
		body.player_state = "normal"

