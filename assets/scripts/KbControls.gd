extends Sprite

var input_index = "keyboard"
var currPos = "center"

func _physics_process(delta):
	if Input.is_action_just_pressed("control_left"):
		if currPos == "right":
			position.x -= 256
			Global.selectPos[1] = null
			currPos = "center"
		elif currPos == "center" and Global.selectPos[0] == null:
			position.x -= 256
			currPos = "left"
			Global.selectPos[0] = input_index
	
	elif Input.is_action_just_pressed("control_right"):
		
		if currPos == "left":
			position.x += 256
			currPos = "center"
			Global.selectPos[0] = null
		elif currPos == "center" and Global.selectPos[1] == null:
			position.x += 256
			currPos = "right"
			Global.selectPos[1] = input_index
