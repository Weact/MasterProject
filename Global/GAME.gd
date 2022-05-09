extends Node2D

var PLAYER_NODE : PhysicsBody2D = null

var map_valentin_player = null
var map_lucas_player = null

signal inventory_state_changed

func _ready() -> void:
	PLAYER_NODE = get_tree().get_root().get_node("MapL/Player/Player")

func _input(event: InputEvent) -> void:
	if not event is InputEventKey and not event is InputEventMouseButton:
		return

	if event.is_action_pressed("minimize"):

		print(OS.window_fullscreen)
		OS.window_fullscreen = !OS.window_fullscreen

	elif event.is_action_pressed("regen"):
		map_valentin_player = get_tree().get_root().get_node_or_null("MapV/Player/Player")
		map_lucas_player = get_tree().get_root().get_node_or_null("MapL/Player/Player")
		cheat_health_stamina(map_valentin_player, map_lucas_player)

	elif event.is_action_pressed("restart_game"):
		restart_map()

	elif event.is_action_pressed("cheat_stats"):
		map_valentin_player = get_tree().get_root().get_node_or_null("MapV/Player/Player")
		map_lucas_player = get_tree().get_root().get_node_or_null("MapL/Player/Player")
		cheat_stats(map_valentin_player, map_lucas_player)

	elif event.is_action_pressed("open_inventory"):
		emit_signal("inventory_state_changed")

	elif event.is_action_pressed("shuffle_inventory"):
		if event.is_action_pressed("sort_inventory"):
			CharacterInventory.sort_inventory(CharacterInventory.INVENTORY_SORTING_MODE.NAME)
			return

		CharacterInventory.shuffle_inventory()
	
	elif event.is_action_pressed("spawn_random_item"):
		var random_item_index = randi() % 3
		var _generated_item = null
		if random_item_index == 0:
			_generated_item = generate_item(ItemsDatabase.get_item(10001).get_name()) #sword
		elif random_item_index == 1:
			_generated_item = generate_item(ItemsDatabase.get_item(10002).get_name()) #shield
		elif random_item_index == 2:
			_generated_item = generate_item(ItemsDatabase.get_item(10003).get_name()) #bow
		else:
			push_error("Invalid item")
		
		if is_instance_valid(PLAYER_NODE):
			_generated_item.set_position(PLAYER_NODE.get_position())

func restart_map() -> void:
	var __ = get_tree().reload_current_scene()

func cheat_health_stamina(player_v, player_l) -> void:
	if is_instance_valid(player_v):
		player_v.set_health_point(1000)
		player_v.set_stamina(1000)
	elif is_instance_valid(player_l):
		player_l.set_health_point(1000)
		player_l.set_stamina(1000)

func cheat_stats(player_v, player_l) -> void:
	cheat_health_stamina(player_v, player_l)

	if is_instance_valid(player_v):
		player_v.set_attack_power(1000)
		player_v.set_block_power(1000)
		player_v.set_stamina(1000)
		player_v.set_movement_speed(player_v.get_movement_speed() * 2)
	elif is_instance_valid(player_l):
		player_l.set_attack_power(1000)
		player_l.set_block_power(1000)
		player_l.set_stamina(1000)
		player_l.set_movement_speed(player_l.get_movement_speed() * 2)

func _create_timer_delay(time: float = 1.0, autostart: bool = true, oneshot: bool = true, connected_object : Node = null, signal_result_method : String = "") -> Timer:
	var new_timer = Timer.new()
	new_timer.set_wait_time(time)
	new_timer.set_one_shot(oneshot)
	new_timer.set_autostart(autostart)

	if is_instance_valid(connected_object) and signal_result_method != "":
		new_timer.connect("timeout", connected_object, signal_result_method, [new_timer])

	return new_timer

func generate_item(item_name, _position : Vector2 = Vector2.ZERO) -> Node2D:
	var item = load("res://Scenes/Items/"+str(item_name)+".tscn")
	if !is_instance_valid(item):
		return null
	var item_instance = item.instance()
	get_tree().get_root().call_deferred("add_child", item_instance)

	return item_instance
