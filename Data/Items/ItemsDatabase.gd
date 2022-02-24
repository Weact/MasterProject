extends Node
func is_class(value: String): return value == "ItemsDatabase" or .is_class(value)
func get_class() -> String: return "ItemsDatabase"

func _ready() -> void:
	pass
