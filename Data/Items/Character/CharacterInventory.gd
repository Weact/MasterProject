extends Node

var _player : PhysicsBody2D = null

var character_inv_data : Array = []
export(int) var character_inv_size = 1
export(int) var fill_ratio = 1

enum INVENTORY_SORTING_MODE{NONE = 0, NAME, RARITY, TYPE}

var items = ItemsDatabase.get_items()

signal inventory_shuffled
signal inventory_sorted

# ACCESORS
# Return the array as a "getter" if false
# return the array for setter purpose (e.g. array1 = this_array) as duplicated array if true
func get_character_inv_data_as_array(return_array_duplicated: bool = false) -> Array:
	# WE USE .DUPLICATE(TRUE) TO COPY THE ARRAY DEEPLY
	# MEANS CHANGING ANY ARRAY WILL NOT MODIFY THE OTHER ONE
	# IF WE JUST RETURN CHARACTER INV DATA TO SET ANOTHER ARRAY
	# SETTING CHARACTER INV DATA WILL CHANGES ALSO OTHER ARRAY VALUES
	# (... cf godot documenatation Array:duplicate ...)
	if return_array_duplicated:
		return character_inv_data.duplicate(true)
	else:
		return character_inv_data

## RETURN THE CHARACTER INV DATA AS STRING FORMAT
func get_inventory_data_as_text() -> String:
	var items_in_inventory : String = ""
	
	for item in character_inv_data:
		if item != null:
			items_in_inventory += item.get_name() + "\n"
	
	return items_in_inventory

####### INVENTORY ITEMS

## SET THE ITEM BY ID AT SPECIFIED SLOT
func set_item_by_id(slot: int, id: int) -> void:
	if is_slot_valid(slot):
		# must convert id(int) to String because ITEMS keys are string
		if not str(id) in ItemsDatabase.ITEMS.keys():
			character_inv_data[slot] = null
		else:
			character_inv_data[slot] = ItemsDatabase.get_item(id)
		EVENTS.emit_signal("inventory_changed")
## RETURNS ITEM AT SPECIFIED SLOT
func get_item(slot: int) -> ItemResource:
	if slot >= character_inv_size:
		return null
	if is_slot_valid(slot):
		return character_inv_data[slot]
	return null
## ADD AN ITEM TO INVENTORY BY ID
func add_item(id: int) -> void:
	if ItemsDatabase.is_item_id_valid(id):
		# a slot is free, add item to the null slot
		if not is_inventory_full():
			for inv_slot in character_inv_size:
				if character_inv_data[inv_slot] == null:
					set_item_by_id(inv_slot, id)
					return
		# all slots are taken, generate item on ground
		else:
			GAME.generate_item(ItemsDatabase.get_item(id).get_name())
			return
## ADD ITEMS BY ARRAY TO INVENTORY, USING IDs
func add_items(ids_array : PoolIntArray) -> void:
	for id in ids_array:
		if ItemsDatabase.is_item_id_valid(id):
			add_item(id)
		else:
			push_error(str(id) + " is an invalid id, could not add item to inventory")
## REMOVE ITEM FROM INVENTORY FROM SLOT
func remove_item(slot: int) -> void:
	if is_slot_valid(slot):
		if character_inv_data[slot] != null:
			set_item_by_id(slot, 10000)
## REPLACE ITEM A BY ITEM B
func replace_item(origin_slot: int, target_slot: int) -> void:
	if is_slot_valid(origin_slot) and is_slot_valid(target_slot):
		var tmp_slot = character_inv_data[target_slot]
		
		character_inv_data[target_slot] = character_inv_data[origin_slot]
		character_inv_data[origin_slot] = tmp_slot
		EVENTS.emit_signal("inventory_changed")
## CHECK IF AN INVENTORY SLOT IS VALID
func is_slot_valid(slot: int) -> bool:
	if slot >= 0:
		return true
	
	push_error("Invalid Slot for Inventory")
	return false
## DOES THE INVENTORY HAS AN ITEM OR NONE ?
func is_inventory_empty() -> bool:
	return count_valid_items() == 0
func is_inventory_full() -> bool:
	var returned:bool = count_valid_items() == character_inv_size
	return returned
## COUNT ITEMS IN INVENTORY
func count_valid_items() -> int:
	var valid_item_count : int = 0
	for item in character_inv_data:
		if item != null:
			valid_item_count += 1
	
	return valid_item_count

# BUILTIN
func _ready() -> void:
	init_inventory()
	add_items([10001, 10002, 10003, 10001, 10002, 10003, 10001, 10002, 10003, 10001, 10002, 10003, 10003])
#	generate_random_items() # DEBUG FEATURE

# LOGIC
func init_inventory() -> void:
	for i in character_inv_size:
		character_inv_data.append(null)

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
