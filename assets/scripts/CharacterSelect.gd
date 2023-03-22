extends Node2D

var player = load("res://player/Player.tscn")
var kb_controls = load("res://assets/sprites/kb_controls.tscn")
var joy_controls = load("res://assets/sprites/joy_controls.tscn")
var main_level = "res://scenes/Levels/Fire Ice Level.tscn"
var main_menu = "res://scenes/Main_menu.tscn"

var icon_y = 200

func _ready():
	var devices = ["keyboard"] 
	devices.append_array(Input.get_connected_joypads())
	for device in devices:
		if typeof(device) == TYPE_STRING:
			Global.instance_node_at_location(kb_controls, self, Vector2(512, icon_y))
		else:
			var new_joy = Global.instance_node_at_location(joy_controls, self, Vector2(512, icon_y))
			new_joy.input_index = device
			new_joy.add_inputs()

		icon_y += 100

func _process(delta):
	if Global.selectPos[0] != null and Global.selectPos[1] != null:
		$ContinueBtn.show()
		if Input.is_action_pressed("ui_accept"):
			_on_ContinueBtn_pressed()		# continues to game if Enter or Space is pressed
	else:
		$ContinueBtn.hide()


func _on_ContinueBtn_pressed():
	Global.splitscreen = true
	for plr in Global.selectPos:
			var player_instance = Global.instance_node_at_location(player, Players, Vector2(0,0))
			player_instance.controller_index = plr
			player_instance.add_inputs()
	get_tree().change_scene(main_level)


func _on_ReturnBtn_pressed():
	get_tree().change_scene(main_menu)
