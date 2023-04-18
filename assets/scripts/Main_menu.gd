extends Node2D
var net_config = "res://scenes/Network_Setup.tscn"
var splitscreen_config = "res://scenes/CharacterSelect.tscn"
var tutorial = "res://scenes/Tutorial.tscn"
var intro = preload("res://assets/audio/deep-ambient.wav")

func _ready():
	$AnimationPlayer.play("default")
	Global.reset_game()
	

func _on_Splitscreen_Btn_pressed():
	get_tree().change_scene(splitscreen_config)


func _on_Online_Btn_pressed():
	get_tree().change_scene(net_config)


func _on_Tutorial_Btn_pressed():
	get_tree().change_scene(tutorial)
