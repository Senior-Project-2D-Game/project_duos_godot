extends Control

var main_menu = "res://scenes/Main_menu.tscn"
var is_paused = false setget set_is_paused

func _input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_Quit_pressed():
	get_tree().quit()


func _on_Resume_pressed():
	self.is_paused = false


func _on_MainMenu_pressed():
	get_tree().change_scene(main_menu)
	self.is_paused = false
