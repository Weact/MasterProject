extends Node2D
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

signal animation_finished

#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	var __ = $AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	
#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_animation_finished(_anim) -> void:
	emit_signal("animation_finished")
