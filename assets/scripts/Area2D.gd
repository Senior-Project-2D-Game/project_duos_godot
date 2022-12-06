extends Area2D

func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is KinematicBody2D:
		self.shape_owner_get_owner(local_shape_index).queue_free()

# handles body collision with death collider
func _on_Death_Collides_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is KinematicBody2D:
		print("Dead")
