extends Control
class_name Inventory
func is_class(value: String): return value == "Inventory" or .is_class(value)
func get_class() -> String: return "Inventory"

onready var inv_slot : PackedScene = preload("res://Scenes/Inventory/ItemSlot/ItemSlot.tscn")
onready var slots_container_node : GridContainer = get_node_or_null("Background/MC/VBC/SC/SlotsContainer")

signal clear_finished

func _ready() -> void:
	var __ = CharacterInventory.connect("inventory_shuffled", self, "_on_inventory_shuffled")
	__ = connect("clear_finished", self, "_on_clear_finished")
	
	generate_inventory()

func clear_inventory() -> void:
	var last_child = null
	if slots_container_node.get_child_count() > 0:
		for child in slots_container_node.get_children():
			last_child = child
			child.queue_free()
	if last_child != null and last_child.is_inside_tree():
		yield(last_child, "tree_exited")
	
	emit_signal("clear_finished")

# | Process :
# - Create_slots which will add all slots into $SlotsContainer
# - Create_slot which will be called each time a slot need to be created by create_slot
#	range(0, CharacterInventory.character_inv_size)
# - Create_slot return a slot(new_slot) which will be used to add_child in create_slots' loop
func generate_inventory() -> void:
	var character_inventory_data : Array = CharacterInventory.get_character_inv_data_as_array()
	create_slots(character_inventory_data)

func create_slots(inventory) -> void:
	for slot in range(0, CharacterInventory.character_inv_size):
		var next_slot = create_slot(inventory, slot)
		slots_container_node.add_child(next_slot, true)

# Inventory : CharacterInventory array data <given at generate_inventory():34>
func create_slot(inventory, slot):
	var new_slot = inv_slot.instance()
	if inventory[slot] != null:
		var item_texture = inventory[slot].get_texture()
		new_slot.get_node("Icon").set_texture(item_texture)
	
	return new_slot

# | Called when user press F3 to shuffle its inventory
#
# | Process :
# - Clear the inventory on screen first
# - Wait for the clear to be finished (make sure that all nodes have been queue freed
#	before generating again
# - Generate Inventory On Screen
#
# | Instead of pressing F3 to shuffle, we can imagine a button in the inventory
# 	pannel that triggers this event
func _on_inventory_shuffled() -> void:
	clear_inventory()
	
	if !slots_container_node.get_children().empty():
		yield(self, "clear_finished")
		
	generate_inventory()

# Do not put code in there except if you want to do something when inventory has been cleared
func _on_clear_finished() -> void:
	pass
