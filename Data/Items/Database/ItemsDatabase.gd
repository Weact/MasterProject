extends Node
func is_class(value: String): return value == "ItemsDatabase" or .is_class(value)
func get_class() -> String: return "ItemsDatabase"

const ITEMS : Dictionary = {
	"10001":preload("res://Data/Items/List/BasicSword.tres"),
	"10002":preload("res://Data/Items/List/BasicShield.tres"),
	"10003":preload("res://Data/Items/List/BigSword.tres")
}

# ACCESSORS
func get_item(id: int) -> Resource:
	for item in ITEMS:
		if str(id) == item:
			return ITEMS[item]
	
	return null

func get_items() -> Dictionary:
	return ITEMS

func _ready() -> void:
	pass
