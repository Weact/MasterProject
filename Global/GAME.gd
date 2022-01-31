extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("minimize"):
			print(OS.window_fullscreen)
			OS.window_fullscreen = !OS.window_fullscreen
