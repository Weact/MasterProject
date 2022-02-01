extends Node

var map_valentin_player = null
var map_lucas_player = null

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("minimize"):
			print(OS.window_fullscreen)
			OS.window_fullscreen = !OS.window_fullscreen
		elif event.is_action_pressed("regen"):
			map_valentin_player = get_tree().get_root().get_node_or_null("MapV/Player/Player")
			map_lucas_player = get_tree().get_root().get_node_or_null("MapL/Player/Player")
			if is_instance_valid(map_valentin_player):
				map_valentin_player.set_health_point(1000)
				map_valentin_player.set_stamina(1000)
			elif is_instance_valid(map_lucas_player):
				map_lucas_player.set_health_point(1000)
				map_lucas_player.set_stamina(1000)
		elif event.is_action_pressed("restart_game"):
			var __ = get_tree().reload_current_scene()

func _create_timer_delay(time: float = 0.0, autostart: bool = true, oneshot: bool = true, connected_object : Node = null, signal_result_method : String = "") -> Timer:
	var new_timer = Timer.new()
	new_timer.set_wait_time(time)
	new_timer.set_one_shot(oneshot)
	new_timer.set_autostart(autostart)
	
	if is_instance_valid(connected_object) and signal_result_method != "":
		new_timer.connect("timeout", connected_object, signal_result_method, [new_timer])
	
	return new_timer
