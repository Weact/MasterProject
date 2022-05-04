extends YSort
class_name Door

func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

export var ai_to_check : Array

#### ACCESSORS ####
func _ready() -> void:
	for ai_path in ai_to_check:
		var ai = get_node(ai_path)
		var __ = ai.connect("die", self, "_on_ai_die")

func _on_ai_die() -> void:
	open()

#### BUILT-IN ####
func open() -> void:
	$AnimationPlayer.play("Open")


#### ACCESSORS ####

#### BUILT-IN ####
#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
