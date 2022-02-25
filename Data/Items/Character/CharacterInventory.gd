extends Node

var character_inv_data : Array = []
export(int) var character_inv_size = 10

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
	print(character_inv_data)
	var items = ItemsDatabase.get_items()
	
	for item in items:
		if str(id) == item:
			for inv_slot in character_inv_data.size():
				if character_inv_data[inv_slot] == null:
					character_inv_data[inv_slot] = ItemsDatabase.get_item(id)
					return

func remove_item(slot: int) -> void:
	if slot < 0:
		push_error("Cannot remove from slot <= -1")
		return
		
	if character_inv_data[slot] != null:
		character_inv_data[slot] = null

# BUILTIN

func _ready() -> void:
	init_inventory()
#	generate_random_items() # DEBUG FEATURE
#	remove_item(1)
	print(get_inventory_data_as_text())

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
