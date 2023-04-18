extends Node2D

onready var dialogue1 = $Label
onready var escapeDiag = $Label5
onready var dialogue2 = $Label2
onready var dialogue3 = $Label3
onready var dialogue4 = $Label4
var main_level = "res://scenes/Levels/Fire Ice Level.tscn"
var player = load("res://player/Player.tscn")
var kb_controls = load("res://assets/sprites/kb_controls.tscn")
var joy_controls = load("res://assets/sprites/joy_controls.tscn")
var intro = preload("res://assets/audio/deep-ambient.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue1.show()
	
	$SFX.stream = intro
	$SFX.play()
	
	$AnimationPlayer.play("default")
	yield($AnimationPlayer, "animation_finished")
	playDialogue2()
	$portal.show()
	yield($AnimationPlayer, "animation_finished")
	playDialogue3()
	yield($AnimationPlayer, "animation_finished")
	playDialogue4()
	yield($AnimationPlayer, "animation_finished")
	
	$Continue.show()
	if Input.is_action_pressed("ui_accept"):
		_on_Continue_pressed()		# continues to game if Enter or Space is pressed
	
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		_on_Continue_pressed()
		

func playDialogue2():
	dialogue1.hide()	
	dialogue2.show()	
	
	$AnimationPlayer.play("label2")		
	
func playDialogue3():
	dialogue2.hide()	
	dialogue3.show()	
	$AnimationPlayer.play("label3")		
	
func playDialogue4():
	dialogue3.hide()	
	dialogue4.show()	
	$AnimationPlayer.play("label4")		


func _on_AnimationPlayer_animation_finished(anim_name):
	return true


func _on_Continue_pressed():
	Global.splitscreen = true
	for plr in Global.selectPos:
			var player_instance = Global.instance_node_at_location(player, Players, Vector2(0,0))
			player_instance.controller_index = plr
			player_instance.add_inputs()
	get_tree().change_scene(main_level)
