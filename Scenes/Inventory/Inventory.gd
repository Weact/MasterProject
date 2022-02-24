extends Control
class_name Inventory
func is_class(value: String): return value == "Inventory" or .is_class(value)
func get_class() -> String: return "Inventory"

export(int) var inventory_size = 1

onready var inv_slot : PackedScene = preload("res://Scenes/Inventory/ItemSlot/ItemSlot.tscn")
onready var slots_container_node : GridContainer = get_node_or_null("Background/MC/VBC/SC/SlotsContainer")

func _ready() -> void:
	for slot in inventory_size:
		var new_slot = inv_slot.instance()
		slots_container_node.add_child(new_slot, true)
