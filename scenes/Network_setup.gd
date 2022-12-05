extends Control

var player = load("res://player/Player.tscn")

onready var multiplayer_config_ui = $Multiplayer_config
onready var server_ip_address = $Multiplayer_config/server_ip
onready var device_ip_address = $CanvasLayer/device_ip
onready var start_game = $CanvasLayer/Start

var main_level = "res://scenes/main_scene.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")	
	get_tree().connect("connected_to_server", self, "_connected_to_server")

	device_ip_address.text = Network.ip_address
	
	if get_tree().network_peer != null:
		pass
	else:
		start_game.hide()

func _process(delta):
	if get_tree().network_peer != null:
		print(get_tree().is_network_server())		
		if get_tree().get_network_connected_peers().size() > 0 and get_tree().is_network_server():
			start_game.show()
		else:
			start_game.hide()
			
		
func _player_connected(id):
	print("Player " + str(id) + " has connected")
	
	instance_player(id)

func _player_disconnected(id):
	print("Player " + str(id) + " has disconnected")
	
	if Players.has_node(str(id)):
		Players.get_node(str(id)).queue_free()

func _on_Host_Server_pressed():
	multiplayer_config_ui.hide()
	Network.create_server()
	
	instance_player(get_tree().get_network_unique_id())

func _on_Join_Server_pressed():
	if server_ip_address.text != "":
		multiplayer_config_ui.hide()
		Network.ip_address = server_ip_address.text
		Network.join_server()

func _connected_to_server():
	yield(get_tree().create_timer(0.1), "timeout")
	instance_player(get_tree().get_network_unique_id())


func instance_player(id):
	var player_instance = Global.instance_node_at_location(player, Players, Vector2(0,0))
	player_instance.name = str(id)
	player_instance.set_network_master(id)
	
sync func switch_to_game() -> void:
	get_tree().change_scene(main_level)


func _on_Start_Btn_pressed():
	rpc("switch_to_game")
