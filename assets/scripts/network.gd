extends Node

#const RPC_PORT = 31400
#const MAX_PLAYERS = 2
#const TESTING_IP = "127.0.0.1"
#const OFFLINE_TESTING = true
#
#var net_id = null
#var is_host = false
#var peer_ids = []
#
#func initialize_server():
#	# initialize server
#	var peer = NetworkedMultiplayerENet.new()
#	peer.create_server(RPC_PORT, MAX_PLAYERS)
#	get_tree().set_network_peer(peer)
#
#func initialize_client(server_ip):
#	if OFFLINE_TESTING:
#		server_ip = TESTING_IP
#	var peer = NetworkedMultiplayerENet.new()
#	peer.create_client(server_ip, RPC_PORT)
#	get_tree().network_peer = peer
#
#func set_ids():
#	net_id = get_tree().get_network_unique_id()
#	peer_ids = get_tree().get_network_connected_peers()

const DEFAULT_PORT = 28960
const MAX_CLIENTS = 2

var server = null
var client = null

var ip_address = ""

func _ready() -> void:
	if OS.get_name() == "Windows":
		ip_address = IP.get_local_addresses()[3]
	elif OS.get_name() == "Android":
		ip_address = IP.get_local_addresses()[0]
	else:
		 ip_address = IP.get_local_addresses()[3]
	
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") and not ip.ends_with(".1"):
			ip_address = ip
	
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func create_server() -> void:
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(server)

func join_server() -> void:
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_address, DEFAULT_PORT)
	get_tree().set_network_peer(client)

func _connected_to_server() -> void:
	print("Successfully connected to server")

func _server_connected() -> void:
	print("Disconnected from the server")
