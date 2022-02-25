extends Node

var character_inv_data : Array = []
export(int) var character_inv_size = 50

signal inventory_shuffled

# ACCESORS

func get_character_inv_data_as_array() -> Array:
	return character_inv_data

func get_inventory_data_as_text() -> String:
	var items_in_inventory : String = ""
	
	for item in character_inv_data:
		if item != null:
			items_in_inventory += item.get_name() + "\n"
	
	return items_in_inventory

func add_item(id: int) -> void:
	var items = ItemsDatabase.get_items()
	
	for item in items:
		if str(id) == item:
			for inv_slot in character_inv_data.size():
				if character_inv_data[inv_slot] == null:
					character_inv_data[inv_slot] = ItemsDatabase.get_item(id)
					return

func remove_item(slot: int) -> void:
	if is_slot_valid(slot):
		if character_inv_data[slot] != null:
			character_inv_data[slot] = null

func set_item(slot: int, id: int) -> void:
	if is_slot_valid(slot):
		character_inv_data[slot] = ItemsDatabase.get_item(id)

func replace_item(origin_slot: int, target_slot: int) -> void:
	if is_slot_valid(origin_slot) and is_slot_valid(target_slot):
		var tmp_slot = character_inv_data[target_slot]
		
		character_inv_data[target_slot] = character_inv_data[origin_slot]
		character_inv_data[origin_slot] = tmp_slot

func shuffle_inventory() -> void:
	character_inv_data.shuffle()
	emit_signal("inventory_shuffled")

func is_slot_valid(slot: int) -> bool:
	if slot >= 0:
		return true
	
	push_error("Invalid Slot for Inventory")
	return false

# BUILTIN

func _ready() -> void:
	init_inventory()
	generate_random_items() # DEBUG FEATURE

# LOGIC

func init_inventory() -> void:
	for i in character_inv_size:
		character_inv_data.append(null)

####DEBUG FEATURE, JUST TO GENERATE SOME RANDOM ITEMS, ADD TO INVENTORY AND PRINT FOR STATS
func generate_random_items() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var basicsword_found : int = 0
	var basicshield_found : int = 0
	var bigsword_found : int = 0
	
	for _i in range (character_inv_size/2):
		var rnumber : int = rng.randi_range(1, 3)
		match(rnumber):
			1:
				add_item(10001)
				basicsword_found += 1
			2:
				add_item(10002)
				basicshield_found += 1
			3:
				add_item(10003)
				bigsword_found += 1
			_:
				push_error("Invalid ID")
	
	print("------------------------------------------------------------------------------------------------\n| %d basicsword have been found | %d basicshield have been found | %d bigsword have been found |\n------------------------------------------------------------------------------------------------" % [basicsword_found, basicshield_found, bigsword_found])
