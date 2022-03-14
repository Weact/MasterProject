extends Character
class_name Player
func is_class(value: String): return value == "Player" or .is_class(value)
func get_class() -> String: return "Player"

onready var inputs_node : Node = get_node("Inputs")

var dirLeft : int = 0
var dirRight : int = 0
var dirUp : int = 0
var dirDown : int = 0
var blockPressed : bool = false
var attackPressed : bool = false

var npc_ressource = preload("res://Scenes/Characters/NPC/NPC.tscn")
var select_rect = null
var shape = null
var start_rect_pos = Vector2(0, 0)
var glow_npcs = []
var selected_npcs = []

#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	var __ = EVENTS.connect("player_target", self, "_on_new_target")
	__ = EVENTS.connect("player_vassal", self, "_on_new_vassal")

func _ready() -> void:
	var __ = EVENTS.connect("inventory_item_equip", self, "_on_inventory_item_equip")

#### VIRTUALS ####

#### LOGIC ####

func _input(event: InputEvent) -> void:
	if not event is InputEventKey and not event is InputEventMouseButton:
		return

	var action_name : String = ""

	if event.is_action_pressed(inputs_node.get_input("MoveLeft")):
		action_name = "MoveLeft_Pressed"

	elif event.is_action_released(inputs_node.get_input("MoveLeft")):
		action_name = "MoveLeft_Released"

	elif event.is_action_pressed(inputs_node.get_input("MoveRight")):
		action_name = "MoveRight_Pressed"

	elif event.is_action_released(inputs_node.get_input("MoveRight")):
		action_name = "MoveRight_Released"

	elif event.is_action_pressed(inputs_node.get_input("MoveUp")):
		action_name = "MoveUp_Pressed"

	elif event.is_action_released(inputs_node.get_input("MoveUp")):
		action_name = "MoveUp_Released"

	elif event.is_action_pressed(inputs_node.get_input("MoveDown")):
		action_name = "MoveDown_Pressed"

	elif event.is_action_released(inputs_node.get_input("MoveDown")):
		action_name = "MoveDown_Released"

	elif event.is_action_pressed(inputs_node.get_input("Attack")):
		action_name = "Attack_Pressed"

	elif event.is_action_released(inputs_node.get_input("Attack")):
		action_name = "Attack_Released"

	elif event.is_action_pressed(inputs_node.get_input("Block")):
		action_name = "Block_Pressed"

	elif event.is_action_released(inputs_node.get_input("Block")):
		action_name = "Block_Released"

	elif event.is_action_pressed(inputs_node.get_input("Dodge")):
		action_name = "Dodge_Pressed"

	elif event.is_action_released(inputs_node.get_input("Dodge")):
		action_name = "Dodge_Released"

	elif event.is_action_pressed(inputs_node.get_input("Interact")):
		action_name = "Interact_Pressed"

	elif event.is_action_released(inputs_node.get_input("Interact")):
		action_name = "Interact_Released"

	elif event.is_action_pressed("debug_new_ai"):
		var npc_instance = npc_ressource.instance()
		get_tree().get_root().call("add_child", npc_instance)
		npc_instance.position = get_global_mouse_position()
		GAME.emit_signal("new_npc", npc_instance)
		print("NEW AI")
		print(npc_instance)

	elif event.is_action_pressed("debug_vassalize"):
		if is_instance_valid(select_rect):
			select_rect.queue_free()

		empty_selection()
		select_rect = Area2D.new()
		var collision = CollisionShape2D.new()
		shape = RectangleShape2D.new()
		shape.set_extents(Vector2(0,0))
		collision.set_shape(shape)
		start_rect_pos = get_global_mouse_position()
		select_rect.position = get_global_mouse_position()
		select_rect.call("add_child", collision)

		get_tree().get_root().call("add_child", select_rect)

		select_rect.connect("body_entered", self, "_on_select_body_entered")
		select_rect.connect("body_exited", self, "_on_select_body_exited")

	elif event.is_action_released("debug_vassalize"):
		var npcs = glow_npcs.duplicate()
		select_rect.queue_free()
		yield(select_rect, "tree_exited")
		for npc in npcs:
			add_selection(npc)

	action(action_name)

func add_selection(npc):
	selected_npcs.append(npc)
	npc.select()

func empty_selection():
	for npc in selected_npcs:
		npc.select(false)
	while !selected_npcs.empty():
		selected_npcs.pop_back()

func _on_select_body_entered(body) -> void:
	if !body.is_class("NPC"):
		return

	glow_npcs.append(body)
	body.select()

func _on_select_body_exited(body) -> void:
	if !body.is_class("NPC"):
		return

	glow_npcs.erase(body)
	body.select(false)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var pos = $WeaponsPoint.global_position
		var mousePos = get_global_mouse_position()
		set_look_direction(rad2deg((mousePos-pos).angle()))

		if is_instance_valid(select_rect):
			shape.set_extents((get_global_mouse_position()-start_rect_pos)/2)
			select_rect.position = start_rect_pos + shape.get_extents()


func action(action_name: String) -> void:
	match(action_name):
		"MoveLeft_Pressed":
			dirLeft = 1
		"MoveLeft_Released":
			dirLeft = 0
		"MoveRight_Pressed":
			dirRight = 1
		"MoveRight_Released":
			dirRight = 0
		"MoveUp_Pressed":
			dirUp = 1
		"MoveUp_Released":
			dirUp = 0
		"MoveDown_Pressed":
			dirDown = 1
		"MoveDown_Released":
			dirDown = 0
		"Attack_Pressed":
			if blockPressed:
				if is_instance_valid(shield_node):
					shield_node.trigger()
			else:
				if is_instance_valid(weapon_node):
					weapon_node.press()
			attackPressed = true

		"Attack_Released":
			if is_instance_valid(weapon_node):
				weapon_node.release()

			attackPressed = false
		"Block_Pressed":
			if is_instance_valid(weapon_node):
				weapon_node.cancel()
			if is_instance_valid(shield_node):
				shield_node.press()
			blockPressed = true
		"Block_Released":
			if is_instance_valid(shield_node):
				shield_node.release()
			blockPressed = false
		"Dodge_Pressed":
			var __ = use_skill("Dodge")
		"Dodge_Released":
			pass
		"Interact_Pressed":
			pick_up()
		"Interact_Released":
			pass
		_:
			return

	set_direction(Vector2(dirRight - dirLeft, dirDown - dirUp))

#### INPUTS ####

#### SIGNAL RESPONSES ####
func _on_new_target(new_target) -> void:
	for npc in selected_npcs:
		if npc.liege == new_target:
			npc.follow(new_target)
		else:
			npc.attack(new_target)

func _on_new_vassal(new_vassal) -> void:
	for npc in selected_npcs:
		npc.set_liege(new_vassal)

func _on_inventory_item_equip(item, slot) -> void:
	CharacterInventory.add_equipped_item(item)
	equip_item(item, slot)
