extends Node

var character_inv_data : Array = []
export(int) var character_inv_size = 5

# ACCESORS

func get_character_inv_data_as_dict() -> Array:
	return character_inv_data

func get_inventory_data_as_text() -> String:
	var items_in_inventory : String = ""
	
	for item in character_inv_data:
		items_in_inventory += item.get_name() + "\n"
	
	return items_in_inventory

func add_item(id: int) -> void:
	if character_inv_data.size() > character_inv_size-1:
		return
	
	var items = ItemsDatabase.get_items()
	
	for item in items:
		if str(id) == item:
			character_inv_data.append(ItemsDatabase.get_item(id))

# BUILTIN

func _ready() -> void:
	generate_random_items() # DEBUG FEATURE
	print(get_inventory_data_as_text())

# LOGIC

####DEBUG FEATURE, JUST TO GENERATE SOME RANDOM ITEMS, ADD TO INVENTORY AND PRINT FOR STATS
func generate_random_items() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var basicsword_found : int = 0
	var basicshield_found : int = 0
	var bigsword_found : int = 0
	
	for i in range (100):
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
