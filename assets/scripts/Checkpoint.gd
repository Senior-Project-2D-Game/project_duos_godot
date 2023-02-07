extends Area2D

func _on_checkpoint(body):
	if body is KinematicBody2D:
		body.spawn = self.position

