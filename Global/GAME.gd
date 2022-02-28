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
			cheat_health_stamina(map_valentin_player, map_lucas_player)
			
		elif event.is_action_pressed("restart_game"):
			var __ = get_tree().reload_current_scene()
			
		elif event.is_action_pressed("cheat_stats"):
			map_valentin_player = get_tree().get_root().get_node_or_null("MapV/Player/Player")
			map_lucas_player = get_tree().get_root().get_node_or_null("MapL/Player/Player")
			cheat_stats(map_valentin_player, map_lucas_player)
		
		elif event.is_action_pressed("shuffle_inventory"):
			if event.is_action_pressed("sort_inventory"):
				CharacterInventory.sort_inventory(CharacterInventory.INVENTORY_SORTING_MODE.NAME)
				return
				
			CharacterInventory.shuffle_inventory()

func cheat_health_stamina(player_v, player_l) -> void:
	if is_instance_valid(player_v):
		player_v.set_health_point(1000, true)
		player_v.set_stamina(1000, true)
	elif is_instance_valid(player_l):
		player_l.set_health_point(1000, true)
		player_l.set_stamina(1000, true)

func cheat_stats(player_v, player_l) -> void:
	cheat_health_stamina(player_v, player_l)
	
	if is_instance_valid(player_v):
		player_v.set_attack_power(1000)
		player_v.set_block_power(1000)
		player_v.set_stamina(1000, true)
		player_v.set_movement_speed(player_v.get_movement_speed() * 2)
	elif is_instance_valid(player_l):
		player_l.set_attack_power(1000)
		player_l.set_block_power(1000)
		player_l.set_stamina(1000, true)
		player_l.set_movement_speed(player_l.get_movement_speed() * 2)

func _create_timer_delay(time: float = 1.0, autostart: bool = true, oneshot: bool = true, connected_object : Node = null, signal_result_method : String = "") -> Timer:
	var new_timer = Timer.new()
	new_timer.set_wait_time(time)
	new_timer.set_one_shot(oneshot)
	new_timer.set_autostart(autostart)
	
	if is_instance_valid(connected_object) and signal_result_method != "":
		new_timer.connect("timeout", connected_object, signal_result_method, [new_timer])
	
	return new_timer
