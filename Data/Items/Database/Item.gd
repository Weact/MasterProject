extends Resource
class_name ItemResource
func is_class(value: String): return value == "ItemResource" or .is_class(value)
func get_class() -> String: return "ItemResource"

export(String) var name
export(bool) var stackable = false
export(int, 1, 99, 1) var max_stack_size = 1

enum ITEM_TYPE { GENERIC = 0, CONSUMABLE, WEAPON, SHIELD, EQUIPMENT, QUEST, MATERIAL }
export(ITEM_TYPE) var type = ITEM_TYPE.GENERIC

enum ITEM_RARITY { COMMON = 0, RARE, EPIC, LEGENDARY }
export(ITEM_RARITY) var rarity = ITEM_RARITY.COMMON

enum ITEM_SLOT { NONE= 0, HELMET, SHOULDER, CHESTPLATE, LEGGINGS, BOOTS, MAINHAND, OFFHAND }
export(ITEM_SLOT) var slot = ITEM_SLOT.NONE

export(Texture) var texture

export(PackedScene) var scene_path

# ACCESSORS

func get_name() -> String:
	return name

func is_stackable() -> bool:
	return stackable

func get_max_stack_size() -> int:
	return max_stack_size

func get_type() -> int: #ITEM_TYPE
	return type

func get_rarity() -> int: #ITEM_RARITY
	return rarity

func get_slot() -> int: #ITEM_SLOT
	return slot

func get_texture() -> Texture:
	return texture

# LOGIC
func display() -> void:
	print("Name : %s\nStackable: %s\nMax stack: %s\nType: %s\nRarity: %s\nSlot: %s\n-----" % [name, stackable, max_stack_size, type, rarity, slot])
