extends Node

var character_inv_data : Array = []
export(int) var character_inv_size = 50
export(int) var fill_ratio = 1

enum INVENTORY_SORTING_MODE{NONE = 0, NAME, RARITY, TYPE}

var items = ItemsDatabase.get_items()

signal inventory_shuffled
signal inventory_sorted

# ACCESORS

func get_character_inv_data_as_array() -> Array:
	return character_inv_data

func get_inventory_data_as_text() -> String:
	var items_in_inventory : String = ""
	
	for item in character_inv_data:
		if item != null:
			items_in_inventory += item.get_name() + "\n"
	
	return items_in_inventory

func is_inventory_empty() -> bool:
	return count_valid_items() == 0

func count_valid_items() -> int:
	var valid_item_count : int = 0
	for item in character_inv_data:
		if item != null:
			valid_item_count += 1
	
	return valid_item_count

func set_item(slot: int, id: int) -> void:
	if is_slot_valid(slot):
		character_inv_data[slot] = ItemsDatabase.get_item(id)

func is_slot_valid(slot: int) -> bool:
	if slot >= 0:
		return true
	
	push_error("Invalid Slot for Inventory")
	return false

# BUILTIN

func _ready() -> void:
	init_inventory()
#	generate_random_items() # DEBUG FEATURE

# LOGIC


func init_inventory() -> void:
	for i in character_inv_size:
		character_inv_data.append(null)

func add_item(id: int) -> void:
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

func replace_item(origin_slot: int, target_slot: int) -> void:
	if is_slot_valid(origin_slot) and is_slot_valid(target_slot):
		var tmp_slot = character_inv_data[target_slot]
		
		character_inv_data[target_slot] = character_inv_data[origin_slot]
		character_inv_data[origin_slot] = tmp_slot

func shuffle_inventory() -> void:
	if is_inventory_empty():
		return
		
	character_inv_data.shuffle()
	emit_signal("inventory_shuffled")

func sort_inventory(mode: int = 1) -> void:
	if is_inventory_empty():
		return
		
	if mode <= INVENTORY_SORTING_MODE.NONE:
		mode = INVENTORY_SORTING_MODE.NAME
		
	match(mode):
		1:
			character_inv_data.sort_custom(self, "sort_inventory_by_name")
		2:
			character_inv_data.sort_custom(self, "sort_inventory_by_rarity")
		3:
			character_inv_data.sort_custom(self, "sort_inventory_by_type")
		_:
			push_error("incorrect inventory sorting mode")
			
	emit_signal("inventory_sorted")

func sort_inventory_by_name(item_a : ItemResource, item_b : ItemResource) -> bool:
	if item_a == null or item_b == null:
		if item_a != null:
			return true
		elif item_b != null:
			return false
		else:
			return false
	if item_a.get_name() > item_b.get_name() or item_a == item_b:
		return false
	return true

func sort_inventory_by_rarity(item_a : ItemResource, item_b : ItemResource) -> bool:
	if item_a == null or item_b == null:
		if item_a != null:
			return true
		elif item_b != null:
			return false
		else:
			return false
	if item_a.get_rarity() < item_b.get_rarity() or item_a == item_b:
		return false
	return true

func sort_inventory_by_type(item_a : ItemResource, item_b : ItemResource) -> bool:
	if item_a == null or item_b == null:
		if item_a != null:
			return true
		elif item_b != null:
			return false
		else:
			return false
	if item_a.get_type() > item_b.get_type() or item_a == item_b:
		return false
	return true

####DEBUG FEATURE, JUST TO GENERATE SOME RANDOM ITEMS, ADD TO INVENTORY AND PRINT FOR STATS
func generate_random_items() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var basicsword_found : int = 0
	var basicshield_found : int = 0
	var bigsword_found : int = 0
	
	for _i in range (character_inv_size / fill_ratio):
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
	
	print("------------------------------------------------------------------------------------------------\n| %d basicsword have been added | %d basicshield have been added | %d bigsword have been added |\n------------------------------------------------------------------------------------------------" % [basicsword_found, basicshield_found, bigsword_found])
