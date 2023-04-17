extends Label


func _ready():
	text = _format_seconds(Global.time_elapsed, true)

func _format_seconds(time : float, use_milliseconds : bool) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	if not use_milliseconds:
		return "%02d:%02d" % [minutes, seconds]
	var milliseconds := fmod(time, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]


func _on_ReturnBtn_pressed():
	pass # Replace with function body.
