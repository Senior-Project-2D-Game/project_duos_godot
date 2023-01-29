extends Area2D

func _on_platform_hit(body_rid, body, body_shape_index, local_shape_index):
	if body is KinematicBody2D:
		self.get_child(0).get_child(0).visible = true
