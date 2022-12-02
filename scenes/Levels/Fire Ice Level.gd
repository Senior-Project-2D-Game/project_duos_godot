extends Node2D

onready var players := {
	"1": {
		viewport = $"VBoxContainer/ViewportContainer/Viewport",
		camera = $"VBoxContainer/ViewportContainer/Viewport/Camera2D",
		player = $"VBoxContainer/ViewportContainer/Viewport/Level/Fire Level/Player",
	},
	"2": {
		viewport = $"VBoxContainer/ViewportContainer2/Viewport",
		camera = $"VBoxContainer/ViewportContainer2/Viewport/Camera2D",
		player = $"VBoxContainer/ViewportContainer/Viewport/Level/Ice Level/Player",
	}
}

func _ready():
	players[2].viewport.world_2d = players["1"].viewport.world_2d
	for node in players.values():
		var remote_transform := RemoteTransform2D.new()
		remote_transform.remote_path = node.camera.get_path()
		node.player.add_child(remote_transform)
