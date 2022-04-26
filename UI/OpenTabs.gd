extends Button
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

export var open_window : NodePath

#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _pressed() -> void:
	get_node(open_window).visible = true
