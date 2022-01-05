extends Character
class_name Player
func is_class(value: String): return value == "Player" or .is_class(value)
func get_class() -> String: return "Player"

onready var inputs_node : Node = $Inputs

var dirLeft : int = 0
var dirRight : int = 0
var dirUp : int = 0
var dirDown : int = 0

#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

#### VIRTUALS ####

#### LOGIC ####

func _input(event: InputEvent) -> void:
	if !event is InputEventKey:
		if !event is InputEventMouseButton:
			return
		
		if event.is_action("player_attack"):
			attack()
		
		elif event.is_action("player_block"):
			block()
			
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
	
	action(action_name)


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
		_:
			return
	
	set_direction(Vector2(dirRight - dirLeft, dirDown - dirUp))

func attack() -> void:
	$Weapon.set_visible(true)
	$Weapon/AnimationPlayer.play("attack")

func block() -> void:
	pass

#### INPUTS ####

#### SIGNAL RESPONSES ####
