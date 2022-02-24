extends Resource
class_name ItemResource
func is_class(value: String): return value == "ItemResource" or .is_class(value)
func get_class() -> String: return "ItemResource"

export(String) var name
export(bool) var stackable = false
export(int, 1, 99, 1) var max_stack_size = 1 if stackable else 99

enum ITEM_TYPE { GENERIC, CONSUMABLE, WEAPON, SHIELD, EQUIPMENT, QUEST, MATERIAL }
export(ITEM_TYPE) var type = ITEM_TYPE.GENERIC

enum ITEM_RARITY { COMMON, RARE, EPIC, LEGENDARY }
export(ITEM_RARITY) var rarity = ITEM_RARITY.COMMON

enum ITEM_SLOT { NONE, HELMET, SHOULDER, CHESTPLATE, LEGGINGS, BOOTS, MAINHAND, OFFHAND }
export(ITEM_SLOT) var slot = ITEM_SLOT.NONE

export(Texture) var texture
