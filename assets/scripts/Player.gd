extends KinematicBody2D

class_name Player

const GRAVITY = 600.0
const SPEED = 200
const JUMP_FORCE = 300
const UP_DIRECTION = Vector2.UP
var player_state = "normal"
var state
var _velocity = Vector2.ZERO
var state_machine
var spawn = Vector2.ZERO

var isIcePlayer = true

puppet var puppet_position = Vector2(0,0) setget puppet_position_set

onready var tween = $Tween

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	if is_network_master():
		var current = state_machine.get_current_node()
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
		
		_velocity.y += GRAVITY * delta 		# jump
		
		if is_sliding:
			if isIcePlayer:
				rpc_unreliable("update_animation_frozen", Animation)				
				state_machine.travel("ice_frozen")
			
			if _velocity.x != 0:
				_velocity.x = sign(_velocity.x) * SPEED
			else:
				_velocity.x = SPEED
			
			if is_on_wall():
				_velocity.x = -SPEED

		else:
			_velocity.x = _horizontal_direction * SPEED
			
			if _horizontal_direction > 0:
				rpc_unreliable("update_animation_move_right", Animation)				
				state_machine.travel("ice_run")
				$Sprite.flip_h = false
				
#				else:
#					state_machine.travel("fire_run")
				
#				state_machine.travel("ice_turn")
				
				if is_jumping:
					_velocity.y = -JUMP_FORCE
				elif is_launched:
					_velocity.y = -JUMP_FORCE + abs(_velocity.y)/2
				elif is_jump_cancelled:
					_velocity.y = 0.0
					
			elif _horizontal_direction < 0:
				rpc_unreliable("update_animation_move_left", Animation)				
				state_machine.travel("ice_run")
				$Sprite.flip_h = true								
				
#				state_machine.travel("ice_turn")				
				
				if is_jumping:
					_velocity.y = -JUMP_FORCE
				elif is_launched:
					_velocity.y = -JUMP_FORCE + abs(_velocity.y)/2
				elif is_jump_cancelled:
					_velocity.y = 0.0
			else:
				rpc_unreliable("update_animation_stop", Animation)
				state_machine.travel("ice_idle")
				
				if is_jumping:
					_velocity.y = -JUMP_FORCE
				elif is_launched:
					_velocity.y = -JUMP_FORCE + abs(_velocity.y)/2
				elif is_jump_cancelled:
					_velocity.y = 0.0

	_velocity = move_and_slide(_velocity, UP_DIRECTION)
	
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


remote func update_animation_move_left(animation):
	state_machine.travel("ice_run")
	$Sprite.flip_h = true		
							
remote func update_animation_move_right(animation):
	state_machine.travel("ice_run")
	$Sprite.flip_h = false		
	
remote func update_animation_stop(animation):
	state_machine.travel("ice_idle")
	
remote func update_animation_frozen(animation):
	state_machine.travel("ice_frozen")
