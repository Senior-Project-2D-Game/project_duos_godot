extends Node2D

var player = preload("res://player/Player.tscn")
var ingame = preload("res://assets/audio/in_game1.wav")

onready var players := {
	"1": {
		viewport = $"VBoxContainer/ViewportContainer/Viewport",
		camera = $"VBoxContainer/ViewportContainer/Viewport/Camera2D",
	},
	"2": {
		viewport = $"VBoxContainer/ViewportContainer2/Viewport",
		camera = $"VBoxContainer/ViewportContainer2/Viewport/Camera2D",
	}
}

func _ready():
	var player_arr = Players.get_children()
	player_arr[0].get_parent().remove_child(player_arr[0])
	player_arr[1].get_parent().remove_child(player_arr[1])
	player_arr[0].set_name("IcePlayer")
	player_arr[1].set_name("FirePlayer")

	player_arr[0].position = Vector2(-600,-100)
	player_arr[1].position = Vector2(-600,900)
	
	# Set respawn location
	player_arr[0].spawn = Vector2(-600,-100)
	player_arr[1].spawn = Vector2(-600,900)

	$"VBoxContainer/ViewportContainer/Viewport/Level".add_child(player_arr[0])
	$"VBoxContainer/ViewportContainer/Viewport/Level".add_child(player_arr[1])
	players["1"].player = player_arr[0]
	players["2"].player = player_arr[1]
	players["2"].player.whichPlayer = "fire"	# changes second player animation 
	#	print(players["2"].player.whichPlayer)	DEBUG WHICH PLAYER IS WHICH
	
	var ice = $"VBoxContainer/ViewportContainer/Viewport/Level/Ice"
	ice.connect("body_shape_entered", players["1"].player,"_on_ice_entered")
	ice.connect("body_shape_exited", players["1"].player,"_on_ice_exited")
	
	var launcher = $"VBoxContainer/ViewportContainer/Viewport/Level/Launcher"
	launcher.connect("body_shape_entered", players["2"].player,"_on_launcher_entered")
	launcher.connect("body_shape_exited", players["2"].player,"_on_launcher_exited")
	
	players["2"].viewport.world_2d = players["1"].viewport.world_2d
	for node in players.values():
		var remote_transform := RemoteTransform2D.new()
		remote_transform.remote_path = node.camera.get_path()
		node.player.add_child(remote_transform)

	$SFX.stream = ingame
	$SFX.play()
