extends Control
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

onready var player_node = owner

#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	if is_instance_valid(owner):
		$BasePanel/TabContainer/Reign/Tree._connect_character(owner)



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
