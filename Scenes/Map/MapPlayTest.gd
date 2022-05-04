extends "res://Scenes/Map/Base/MapBase.gd"
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

onready var player = get_node("Player/Player")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.message_target(get_node("Player/Sword"), "F pour ramasser")
	player.message_target(get_node("Player/Shield"), "F pour ramasser")
	player.message_target(get_node("Player/Player/HUD/UI/OpenInventory"), "TAB pour ouvrir l'inventaire")
	var __ = get_node("Player/Player/HUD/UI/Inventory").connect("visibility_changed", self, "_select_item")
	__ = EVENTS.connect("inventory_item_equip", self, "_attack_object")
	__ = get_node("PlayerArea1").connect("player_entered", self, "_attack_npc")

func _select_item() -> void:
	player.hide_message()
	player.message_target(get_node("Player/Player/HUD/UI/Inventory/Background/MC/VBC/SC/SlotsContainer"), "Clique droit pour équiper")
	get_node("Player/Player/HUD/UI/Inventory").disconnect("visibility_changed", self, "_select_item")

var nb = 0
func _attack_object(_item, _slot) -> void:
	nb += 1
	if nb != 2:
		return
	player.hide_message()
	player.message_target(get_node("Crate"), "Clique gauche pour frapper")
	player.message_target(get_node("Crate2"), "Clique gauche pour frapper")
	player.message_target(get_node("Crate3"), "Clique gauche pour frapper")
	EVENTS.disconnect("inventory_item_equip", self, "_attack_object")

func _attack_npc() -> void:
	get_node("PlayerArea1").disconnect("player_entered", self, "_attack_npc")
	player.hide_message()
	player.message_target(get_node("NPC/NPC"), "Clique droit pour bloquer")
	yield(get_tree().create_timer(2.5), "timeout")
	player.hide_message()

	get_node("NPC/NPC").attack(player)
	

#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
