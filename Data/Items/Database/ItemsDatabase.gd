extends Node
func is_class(value: String): return value == "ItemsDatabase" or .is_class(value)
func get_class() -> String: return "ItemsDatabase"

const ITEMS : Dictionary = {
	"10001":preload("res://Data/Items/List/Sword.tres"),
	"10002":preload("res://Data/Items/List/Shield.tres"),
	"10003":preload("res://Data/Items/List/Bow.tres")
}

# ACCESSORS
func get_item(id: int) -> ItemResource:
	for item in ITEMS:
		if str(id) == item:
			return ITEMS[item]
	
	push_error("Item %d could not be retrived, returned null" % str(id))
	return null

func get_item_id(name: String) -> int:
	for index in ITEMS.size():
		for item in ITEMS:
			if name == ITEMS[item].get_name():
				var item_id := int(item)
				return item_id
	
	return 10000

func get_items() -> Dictionary:
	return ITEMS

func is_item_id_valid(id: int) -> bool:
	if str(id) in ITEMS.keys():
		return true
	return false

func _ready() -> void:
	pass
