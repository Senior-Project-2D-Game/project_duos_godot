extends Node2D

var player = preload("res://player/Player.tscn")
var player_instance = player.instance()
var main_menu = "res://scenes/Main_menu.tscn"

onready var dialogue1 = $Label
onready var dialogue2 = $Label4
onready var dialogue3 = $Label2
onready var dialogue4 = $Label3
onready var dialogue5 = $Label5

func _ready():
#	print(self.get_children())
	
	Global.splitscreen = true
	player_instance.controller_index = "keyboard"
	player_instance.add_inputs()
	player_instance.set_name("FirePlayer")
	player_instance.position = Vector2(-570, -400)
	
	# Set respawn location
	player_instance.spawn = Vector2(-570, -400)

	$".".add_child(player_instance)
	player_instance.whichPlayer = "fire"	# changes second player animation 
	
	player_instance.z_index = 0



#	yield($AnimationPlayer, "animation_finished")
#	playDialogue3()

	# continues to game if Enter or Space is pressed
	
func playDialogue2():
	dialogue1.hide()	
	dialogue2.show()	
	$AnimationPlayer.play("joy_move1")		
	
func playDialogue3():
	dialogue2.hide()	
	dialogue3.show()	
	$AnimationPlayer.play("jump_move")		
	
func playDialogue4():
	dialogue3.hide()	
	dialogue4.show()	
	$AnimationPlayer.play("checkpoint")	
	
func playDialogue5():
	dialogue4.hide()	
	dialogue5.show()	
	$AnimationPlayer.play("escape")		

func _process(delta):
	$Camera2D.position.x = player_instance.position.x
	
func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().change_scene(main_menu)


func _on_AnimationPlayer_animation_finished(anim_name):
	return true


func _on_JumpDialog_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	playDialogue3()


func _on_EnterDialog_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	$AnimationPlayer.play("key_move1")
	yield($AnimationPlayer, "animation_finished")
	playDialogue2()	


func _on_CheckpointDialog_body_entered(body):
	playDialogue4()
	yield($AnimationPlayer, "animation_finished")	
	playDialogue5()
