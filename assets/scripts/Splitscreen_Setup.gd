extends Node2D


var player = load("res://player/Player.tscn")
var main_level = "res://scenes/Levels/Fire Ice Level.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.splitscreen = true
	if Input.get_connected_joypads().size() >= 2:
		for plr in Input.get_connected_joypads():
			var player_instance = Global.instance_node_at_location(player, Players, Vector2(0,0))
			player_instance.controller_index = plr
			player_instance.add_inputs()
	get_tree().change_scene(main_level)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
