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

#### ACCESSORS ####

#### BUILT-IN ####

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
		var pos = $WeaponsPoint.global_position
		var mousePos = get_global_mouse_position()
		set_look_direction(rad2deg((mousePos-pos).angle()))


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
				var __ = use_skill("GuardBreak")
			else:
				var __ = use_skill("ChargedAttack")
				
			attackPressed = true
			
		"Attack_Released":
			var charged_attack = skill_tree.get_skill("ChargedAttack")
			if is_instance_valid(charged_attack) and charged_attack.is_ready():
				charged_attack.execute()
			elif get_current_state() == "ChargedAttack":
				var __ = use_skill("Attack")
			attackPressed = false
		"Block_Pressed":
			var __ = use_skill("Block")
			blockPressed = true
		"Block_Released":
			unblock()
			blockPressed = false
		"Dodge_Pressed":
			var __ = use_skill("Dodge")
		"Dodge_Released":
			pass
		_:
			return

	set_direction(Vector2(dirRight - dirLeft, dirDown - dirUp))

func unblock() -> void:
	var block_skill = skill_tree.get_skill("Block")
	if is_instance_valid(block_skill):
		block_skill.recover()
 
#### INPUTS ####

#### SIGNAL RESPONSES ####
