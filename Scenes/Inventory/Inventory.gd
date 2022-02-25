extends Control
class_name Inventory
func is_class(value: String): return value == "Inventory" or .is_class(value)
func get_class() -> String: return "Inventory"

onready var inv_slot : PackedScene = preload("res://Scenes/Inventory/ItemSlot/ItemSlot.tscn")
onready var slots_container_node : GridContainer = get_node_or_null("Background/MC/VBC/SC/SlotsContainer")

func _ready() -> void:
	var character_inventory_data : Array = CharacterInventory.get_character_inv_data_as_array()
	
	for slot in CharacterInventory.character_inv_size:
		
		var new_slot = inv_slot.instance()
		
		if character_inventory_data[slot] != null:
			var item_name = character_inventory_data[slot].get_name()
			var item_texture = character_inventory_data[slot].get_texture()
			new_slot.set_name(item_name)
			new_slot.get_node("Icon").set_texture(item_texture)
			
		slots_container_node.add_child(new_slot, true)
