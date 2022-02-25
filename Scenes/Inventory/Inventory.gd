extends Control
class_name Inventory
func is_class(value: String): return value == "Inventory" or .is_class(value)
func get_class() -> String: return "Inventory"

onready var inv_slot : PackedScene = preload("res://Scenes/Inventory/ItemSlot/ItemSlot.tscn")
onready var slots_container_node : GridContainer = get_node_or_null("Background/MC/VBC/SC/SlotsContainer")

func _ready() -> void:
	var __ = CharacterInventory.connect("inventory_shuffled", self, "_on_inventory_shuffled")
	generate_inventory()

func clear_inventory() -> void:
	if slots_container_node.get_child_count() > 0:
		for child in slots_container_node.get_children():
				child.queue_free()

func generate_inventory() -> void:
	var character_inventory_data : Array = CharacterInventory.get_character_inv_data_as_array()
	create_slots(character_inventory_data)
#	create_first_slot(character_inventory_data)

func create_first_slot(inventory) -> void:
	var first_slot = create_slot(inventory, 0)
	slots_container_node.add_child(first_slot)

func create_slots(inventory) -> void:
	for slot in range(0, CharacterInventory.character_inv_size):
		var next_slot = create_slot(inventory, slot)
		slots_container_node.add_child(next_slot, true)

func create_slot(inventory, slot):
	var new_slot = inv_slot.instance()
	if inventory[slot] != null:
		var item_texture = inventory[slot].get_texture()
		new_slot.get_node("Icon").set_texture(item_texture)
	
	return new_slot

func _on_inventory_shuffled() -> void:
	clear_inventory()
	generate_inventory()
