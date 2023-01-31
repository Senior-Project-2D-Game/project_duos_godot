class_name IcePlayer extends Player

onready var animatedSprite = $AnimatedSprite


func _physics_process(delta):
	var _horizontal_direction = (
	Input.get_action_strength("p1_move_right")
	- Input.get_action_strength("p1_move_left")
)
	if _horizontal_direction > 0:
		animatedSprite.animation = "walking"
		animatedSprite.flip_h = false
	if _horizontal_direction < 0:
		animatedSprite.animation = "walking"
		animatedSprite.flip_h = true
	if player_state == "sliding":
		animatedSprite.animation = "frozen"
	else:
		animatedSprite.animation = "idle"
