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
			EVENTS.emit_signal("player_vassal", owner)
		if event.is_action_pressed("player_block"):
			EVENTS.emit_signal("player_target", owner)
