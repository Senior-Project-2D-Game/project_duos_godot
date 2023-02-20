extends Node2D
var net_config = "res://scenes/Network_Setup.tscn"


func _on_Splitscreen_Btn_pressed():
	#get_tree().change_scene(splitscreen) !! TO DO
	pass


func _on_Online_Btn_pressed():
	get_tree().change_scene(net_config)
