extends Control
class_name Inventory
func is_class(value: String): return value == "Inventory" or .is_class(value)
func get_class() -> String: return "Inventory"

onready var inv_slot : PackedScene = preload("res://Scenes/Inventory/ItemSlot/ItemSlot.tscn")
onready var slots_container_node : GridContainer = get_node_or_null("Background/MC/VBC/SC/SlotsContainer")
onready var exit_button_node : TextureButton = get_node_or_null("Background/MC/VBC/HBC/Exit/ExitTButton")

var inventory_opened : bool = false
signal clear_finished

var temp_character_inv_data = []

## ACCESSORS

func is_inventory_open() -> bool:
	return inventory_opened

## BUILTIN

func _ready() -> void:
	var __ = GAME.connect("inventory_state_changed", self, "_on_inventory_state_changed")
	__ = CharacterInventory.connect("inventory_shuffled", self, "_on_inventory_shuffled")
	__ = CharacterInventory.connect("inventory_sorted", self, "_on_inventory_sorted")
	__ = connect("clear_finished", self, "_on_clear_finished")
	__ = exit_button_node.connect("button_down", self, "_on_exit_tbutton_pressed")
	
	synchronize_inventory()
	
	if visible:
		set_visible(false)

## LOGIC

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
# !! THIS METHOD SHOULD NEVER BE CALLED ANYWHERE EXCEPT IN SAFE REGENERATE INVENTORY !!
func _generate_inventory() -> void:
	create_slots(temp_character_inv_data)
	
func safe_regenerate_inventory() -> void:
	clear_inventory()
	
	if !slots_container_node.get_children().empty():
		yield(self, "clear_finished")
		
	_generate_inventory()

func create_slots(inventory) -> void:
	for slot in range(0, CharacterInventory.character_inv_size):
		var next_slot = create_slot(inventory, slot)
		slots_container_node.add_child(next_slot, true)

# Inventory : CharacterInventory array data <given at generate_inventory()>
func create_slot(inventory, slot):
	var new_slot = inv_slot.instance()
	if inventory[slot] != null:
		var item_texture = inventory[slot].get_texture()
		new_slot.get_node("Icon").set_texture(item_texture)
	
	return new_slot

func open_inventory() -> void:
	inventory_opened = true
	set_visible(inventory_opened)

func close_inventory() -> void:
	inventory_opened = false
	set_visible(inventory_opened)

func synchronize_inventory() -> void:
	
	# DON'T PASS ANY ARGUMENT SINCE DEFAULT IS FALSE, WILL RETURNS THE ARRAY AS A GETTER
	# Need to check if temp character inv data is the same as current character inventory data
	# Or if textures from slot are well displayed (are_all_slots_textures_synchronized)
	if temp_character_inv_data != CharacterInventory.get_character_inv_data_as_array()\
	or not are_all_slots_texture_synchronized():
		# MUST PASS TRUE IN ARG, OTHERWISE IT WILL RETURN THE ARRAY BY REFERENCE
		temp_character_inv_data = CharacterInventory.get_character_inv_data_as_array(true)
		safe_regenerate_inventory()

func are_all_slots_texture_synchronized() -> bool:
	var slots_array : Array = []
	if slots_container_node.get_child_count() > 0:
		for slot_child in slots_container_node.get_children():
			slots_array.append(slot_child)
	for slot in slots_array:
#		var slot_texture : Texture = slot.texture
		print(slot)
	
	return false

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
	print("Inventory shuffled")
	safe_regenerate_inventory()

func _on_inventory_sorted() -> void:
	print("Inventory sorted")
	safe_regenerate_inventory()

# Do not put code in there except if you want to do something when inventory has been cleared
func _on_clear_finished() -> void:
	pass

func _on_exit_tbutton_pressed() -> void:
	close_inventory()

func _on_inventory_state_changed() -> void:
	if inventory_opened:
		close_inventory()
	else:
		synchronize_inventory()
		open_inventory()
