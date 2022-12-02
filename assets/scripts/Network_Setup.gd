extends Control

# Player info, associate ID to data
var player = load("res://player/Player.tscn")
var which_level = "res://scenes/Levels/Fire Ice Level.tscn"
const player_x_spawn = -672
const player_y_spawn = -16

onready var multiplayer_config_ui = $Multiplayer_configure
onready var server_ip_address = $Multiplayer_configure/IP

onready var device_ip_address = $LoadScreen/ConnectText

func _ready() -> void:
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	#get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	#get_tree().connect("connection_failed", self, "_failed_connect")
	
	device_ip_address.text = Net.ip_address

func _player_connected(id):
	print("Player " + str(id) + " has connected.")

	instance_player(id)

func _player_disconnected(id):
	print("Player " + str(id) + " has disconnected.")	

	if Players.has_node(str(id)):
		Players.get_node(str(id)).queue_free()

func _on_Host_pressed():
	multiplayer_config_ui.hide()
	Net.create_server()
	
	instance_player(get_tree().get_network_unique_id())


func _on_Join_pressed():
	if server_ip_address.text != "":
		multiplayer_config_ui.hide()
		Net.ip_address = server_ip_address.text
		Net.join_server()

func _connected_to_server() -> void:
	#yield(get_tree().create_timer(0.1), "timeout")
	instance_player(get_tree().get_network_unique_id())
	

func instance_player(id):
	var player_instance = Global.instance_node_at_location(player, Players, Vector2(player_x_spawn, player_y_spawn))
	player_instance.set_name(str(id))
	player_instance.set_network_master(id)

#func connected():
#	if not Net.is_host:
#		rpc("begin_game")
#		begin_game()
#
#remote func begin_game():
#	var selfPeerID = get_tree().get_network_unique_id()
#
#	# Load world
#	_load_world(which_level)
#
##	# Load my player
##	var my_player = preload("res://player/Player.tscn").instance()
##	my_player.set_name(str(selfPeerID))
##	my_player.set_network_master(selfPeerID)
##	get_node("/root/world/players").add_child(my_player)
##
##	# Load other players
##	for p in player_info:
##		var player = preload("res://player/Player.tscn").instance()
##		player.set_name(str(p))
##		player.set_network_master(p)
##		get_node("/root/world/players").add_child(player)
##
##	rpc_id(1, "done_preconfiguring")
#

#
#func _server_disconnected():
#	# Server kicked us; show error and abort
#	get_tree().quit()
#
#func _failed_connect():
#	pass
#
#func _load_world(level):
#	var world = load(level).instance()
#	get_node("/root").add_child(world)



