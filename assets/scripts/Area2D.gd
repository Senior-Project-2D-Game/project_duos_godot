extends Area2D

var levelCompletion = "res://scenes/Level_Completion.tscn"

func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is KinematicBody2D:
		self.shape_owner_get_owner(local_shape_index).queue_free()

# handles body collision with death collider
func _on_Death_Collides_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is KinematicBody2D:
		body.position = body.spawn

func _on_CompletionCollider_body_entered(body):
	if body is KinematicBody2D:
		if body.name == "IcePlayer":
			Global.playerCompleted[0] = true
		elif body.name == "FirePlayer":
			Global.playerCompleted[1] = true
	if Global.playerCompleted[0] and Global.playerCompleted[1]:
		get_tree().change_scene(levelCompletion)
