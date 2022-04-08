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
var ninepatchrect_ressource = preload("res://Scenes/Characters/Player/visible_selection_rect.tscn")
var select_rect = null
var visible_select_rect = null
onready var select_point = $select_point_area
var target_click = null
var shape = null
var start_rect_pos = Vector2(0, 0)
var glow_npcs = []
var selected_npcs = []

#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	var __ = EVENTS.connect("player_target", self, "_on_new_target")
	__ = EVENTS.connect("player_vassal", self, "_on_new_vassal")
	__ = EVENTS.connect("inventory_item_equip", self, "_on_inventory_item_equip")

	__ = select_point.connect("body_entered", self, "_on_select_point_entered")
	__ = select_point.connect("body_exited", self, "_on_select_point_exited")
	
	## SKILL TREE
	__ = EVENTS.connect("skill_learn", self, "_on_try_to_learn_skill")

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
		EVENTS.emit_signal("new_npc", npc_instance)

	elif event.is_action_pressed("debug_vassalize"):
		start_selection()

	elif event.is_action_released("debug_vassalize"):
		stop_selection()

	if is_instance_valid(target_click):
		if event.is_action_pressed("player_attack"):
			_on_new_vassal(target_click)
		if event.is_action_pressed("player_block"):
			_on_new_target(target_click)
	action(action_name)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var pos = $WeaponsPoint.global_position
		var mousePos = get_global_mouse_position()
		select_point.position = mousePos - position
		set_look_direction(rad2deg((mousePos-pos).angle()))

		if is_instance_valid(select_rect):
			var extent = (mousePos-start_rect_pos)/2
			shape.set_extents(extent)
			select_rect.position = start_rect_pos + shape.get_extents()
			var new_size = Vector2((extent*2).x, (extent*2).y)
			visible_select_rect.set_position(start_rect_pos  + Vector2(min(new_size.x, 0), min(new_size.y,0)))
			visible_select_rect.rect_size = Vector2(abs(new_size.x), abs(new_size.y))

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

func add_selection(npc):
	selected_npcs.append(npc)
	npc.select()

func empty_selection():
	for npc in selected_npcs:
		if is_instance_valid(npc):
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

func stop_selection() -> void:
	var npcs = glow_npcs.duplicate()
	select_rect.queue_free()
	visible_select_rect.queue_free()
	yield(select_rect, "tree_exited")
	for npc in npcs:
		add_selection(npc)

func start_selection() -> void:
	if is_instance_valid(select_rect):
		select_rect.queue_free()

	empty_selection()
	select_rect = Area2D.new()
	visible_select_rect = ninepatchrect_ressource.instance()
	var collision = CollisionShape2D.new()
	shape = RectangleShape2D.new()
	shape.set_extents(Vector2(0,0))
	collision.set_shape(shape)
	start_rect_pos = get_global_mouse_position()
	select_rect.position = get_global_mouse_position()
	select_rect.call("add_child", collision)

	get_tree().get_root().call("add_child", select_rect)
	get_tree().get_root().call("add_child", visible_select_rect)

	select_rect.connect("body_entered", self, "_on_select_body_entered")
	select_rect.connect("body_exited", self, "_on_select_body_exited")

#### INPUTS ####

#### SIGNAL RESPONSES ####
func _on_new_target(new_target) -> void:
	for npc in selected_npcs:
		if is_instance_valid(npc) and npc.is_vassal_of(self):
			if npc.liege == new_target:
				npc.follow(new_target)
			else:
				npc.attack(new_target)

func _on_new_vassal(new_vassal) -> void:
	for npc in selected_npcs:
		if is_instance_valid(npc):
			npc.set_liege(new_vassal)

func _on_select_point_entered(body) -> void:
	if body is Character:
		target_click = body
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_select_point_exited(body) -> void:
	if body == target_click:
		target_click = null
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		
func _on_inventory_item_equip(item, slot) -> void:
		equip_item(item, slot)

func _on_try_to_learn_skill(st_skill_node : TextureButton) -> void:
	if is_skill_learned(st_skill_node.get_skill_name()):
		return
		
	if not is_instance_valid(st_skill_node):
		push_error("No skill to learn, invalid st skill node")
		return
	
	if not SKILL_LIST.does_skill_exist(st_skill_node.get_skill_name() ):
		push_error("Skill NODE does not exist in skill database SKILL_LIST")
		return
	
	# returns the exp cost of the skill to learn
	if weapon_exp >= st_skill_node.get_learn_exp_cost():
		
		weapon_exp -= st_skill_node.get_learn_exp_cost()
		if weapon_exp < 0: weapon_exp = 0
		
		# returns the name of the skill to learn
		add_skill( st_skill_node.get_skill_name() )
		EVENTS.emit_signal("skill_learned", st_skill_node)
