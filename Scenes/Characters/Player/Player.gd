extends Character
class_name Player
func is_class(value: String): return value == "Player" or .is_class(value)
func get_class() -> String: return "Player"

onready var inputs_node : Node = $Inputs

onready var dodge_sprite_animation : PackedScene = preload("res://Scenes/Characters/Player/DodgeSprite/DodgeSprite.tscn")

onready var weapon_node : Node2D = get_node_or_null("WeaponPoint/Weapon")

var dirLeft : int = 0
var dirRight : int = 0
var dirUp : int = 0
var dirDown : int = 0

#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if is_dodging:
		animate_dodging()

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

	action(action_name)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var pos = $ShieldPoint.global_position
		var mousePos = get_global_mouse_position()
		set_look_direction(mousePos-pos)


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
			attack()
		"Attack_Released":
			pass
		"Block_Pressed":
			block()
		"Block_Released":
			unblock()
		"Dodge_Pressed":
			dodge()
		"Dodge_Released":
			pass
		_:
			return

	set_direction(Vector2(dirRight - dirLeft, dirDown - dirUp))

func attack() -> void:
	set_state("Attack")

func block() -> void:
	state_machine.set_state("Block")

func unblock() -> void:
	state_machine.set_state("Idle")

func dodge() -> void:
	if get_state_name() == "Move" and not is_dodging:
		set_modulate(Color8(255,255,255,230))
		yield(get_tree().create_timer(dodging_time*3), "timeout")
		is_dodging = true
		movement_speed = movement_speed * 3
		yield(get_tree().create_timer(dodging_time), "timeout")
		reset_dodge()

func reset_dodge() -> void:
	is_dodging = false
	set_modulate(Color8(255,255,255,255))
	movement_speed = movement_speed / 3

func animate_dodging() -> void:
	var dodge_anim = dodge_sprite_animation.instance()
	dodge_anim.global_position = global_position
	get_parent().add_child(dodge_anim)

#### INPUTS ####

#### SIGNAL RESPONSES ####
func _on_weapon_hit() -> void:
	set_state("Idle")
	weapon_node.get_node_or_null("AnimationPlayer").play("attack", -1, -1, false)
