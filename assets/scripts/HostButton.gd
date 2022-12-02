extends Button

signal set_connect_type

func _ready():
	if OS.get_name() == "Windows":
		$IP.text = "IP: " + str(IP.get_local_addresses()[3])
	else:
		$IP.text = "IP: " + str(IP.get_local_addresses()[7])

func host():
	Net.initialize_server()
	emit_signal("set_connect_type", true)
