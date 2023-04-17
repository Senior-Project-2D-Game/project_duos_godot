extends Node

export var splitscreen = false
export var selectPos = [null, null]
export var playerCompleted = [false, false]
export var time_elapsed = 0.0

func instance_node_at_location(node: Object, parent: Object, location: Vector2):
	var node_instance = instance_node(node, parent)
	node_instance.global_position = location
	return node_instance

func instance_node(node: Object, parent: Object):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	return node_instance

func reset_game():
	Players.get_children().clear()
	splitscreen = false
	selectPos = [null, null]
	playerCompleted = [false, false]
	time_elapsed = 0.0

