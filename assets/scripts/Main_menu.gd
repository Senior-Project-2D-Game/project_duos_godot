extends Node2D
var net_config = "res://scenes/Network_Setup.tscn"
var splitscreen_config = "res://scenes/Splitscreen_Setup.tscn"


func _on_Splitscreen_Btn_pressed():
	get_tree().change_scene(splitscreen_config)


func _on_Online_Btn_pressed():
	get_tree().change_scene(net_config)
