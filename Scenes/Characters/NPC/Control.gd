extends Control
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	var __ = connect("gui_input", self, "_on_gui_input")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_gui_input(event) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("player_attack"):
			owner.following = true
