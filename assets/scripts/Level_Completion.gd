extends Node2D

var main_menu = "res://scenes/Main_menu.tscn"

func _on_ReturnBtn_pressed():
	get_tree().change_scene(main_menu)
