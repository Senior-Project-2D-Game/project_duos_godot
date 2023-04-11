extends Area2D

func _on_checkpoint(body):
	if body is KinematicBody2D:
		body.spawn = self.position



func _on_Death_Collides2_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is KinematicBody2D:
		body.position = body.spawn


func _on_fire3_body_entered(body):
	if body is KinematicBody2D:
		body.spawn = self.position
