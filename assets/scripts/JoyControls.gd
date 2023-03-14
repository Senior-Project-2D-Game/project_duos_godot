extends Sprite

export var input_index = 0
var currPos = "center"
var controls = {
	"left" : [["button", 14], ["motion", JOY_AXIS_0, "left"]],
	"right" : [["button", 15], ["motion", JOY_AXIS_0, "right"]],
	"jump" : [["button", 0]], "pause" : [["button", 1]]
}

func add_inputs():
	var ev
	var action
	for action_name in controls:
		action = action_name + str(input_index)
		if not InputMap.has_action(action):
			InputMap.add_action(action)

		for key in controls[action_name]:
			if key[0] == "button":
				ev = InputEventJoypadButton.new()
				ev.button_index = key[1]

			elif key[0] == "motion":
				ev = InputEventJoypadMotion.new()
				ev.set_axis(key[1])

				if key[2] == "left":
					ev.set_axis_value(-1.0)
				else:
					ev.set_axis_value(1.0)

			ev.set_device(input_index)
			InputMap.action_add_event(action, ev)


func _physics_process(delta):
	if Input.is_action_just_pressed("left" + str(input_index)):
		if currPos == "right":
			position.x -= 256
			Global.selectPos[1] = null
			currPos = "center"
		elif currPos == "center" and Global.selectPos[0] == null:
			position.x -= 256
			currPos = "left"
			Global.selectPos[0] = input_index
	
	elif Input.is_action_just_pressed("right" + str(input_index)):
		
		if currPos == "left":
			position.x += 256
			currPos = "center"
			Global.selectPos[0] = null
		elif currPos == "center" and Global.selectPos[1] == null:
			position.x += 256
			currPos = "right"
			Global.selectPos[1] = input_index
