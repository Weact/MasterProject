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
	__ = get_node("PlayerArea2").connect("player_entered", self, "_attack_npc2")
	__ = get_node("PlayerArea3").connect("player_entered", self, "_attack_npc3")
	__ = get_node("PlayerArea4").connect("player_entered", self, "_attack_npc4")
	__ = get_node("PlayerArea5").connect("player_entered", self, "_attack_npc5")
	__ = get_node("NPC/NPC3").connect("selected", self, "_selected_npc3")
	__ = get_node("NPC/NPC13").connect("die", self, "_play_win")
	__ = get_node("NPC/NPC2").connect("die", self, "_play_space")
	__ = player.connect("attacking", self, "_order_npc3")

func _play_space() -> void:
	player.message_target(get_node("NPC/NPC9"), "Espace pour esquiver")
	get_node("Player/Player/HUD/UI/Inventory").disconnect("die", self, "_play_space")
	yield(get_tree().create_timer(4.0), "timeout")
	player.hide_message()

	
func _select_item() -> void:
	get_node("NPC/NPC").disconnect("visibility_changed", self, "_select_item")
	player.message_target(get_node("Player/Player/HUD/UI/Inventory/Background/MC/VBC/SC/SlotsContainer"), "Clique droit pour équiper")
	
var nb = 0
func _attack_object(_item, _slot) -> void:
	nb += 1
	if nb != 2:
		return
	player.hide_message()
	player.message_target(get_node("Objects/Crate"), "Clique gauche pour frapper")
	player.message_target(get_node("Objects/Crate2"), "Clique gauche pour frapper")
	player.message_target(get_node("Objects/Crate3"), "Clique gauche pour frapper")
	EVENTS.disconnect("inventory_item_equip", self, "_attack_object")

func _attack_npc() -> void:
	get_node("PlayerArea1").disconnect("player_entered", self, "_attack_npc")
	player.hide_message()
	player.message_target(get_node("NPC/NPC"), "Clique droit pour bloquer")
	yield(get_tree().create_timer(4.0), "timeout")
	player.hide_message()

	get_node("NPC/NPC").attack(player)
	
func _attack_npc2() -> void:
	get_node("PlayerArea2").disconnect("player_entered", self, "_attack_npc2")
	
	get_node("NPC/NPC2").attack(player)
	
func _order_npc3() -> void:
	player.disconnect("attacking", self, "_order_npc3")
	player.hide_message()	
	
func _selected_npc3() -> void:
	get_node("NPC/NPC3").disconnect("selected", self, "_selected_npc3")
	player.hide_message()
	player.message_target(get_node("NPC/NPC6"), "Clique droit pour envoyer vos vassaux attaquer")
	
func _attack_npc3() -> void:
	get_node("PlayerArea3").disconnect("player_entered", self, "_attack_npc3")
	player.hide_message()
	player.message_target(get_node("NPC/NPC3"), "Ces personnages sont vos vassaux ! Maintenir A appuyé pour les sélectionner")
	get_node("NPC/NPC3").set_liege(player)
	get_node("NPC/NPC4").set_liege(player)
	
func _attack_npc4() -> void:
	get_node("PlayerArea4").disconnect("player_entered", self, "_attack_npc4")
	get_node("NPC/NPC15").set_liege(player)
	
func _attack_npc5() -> void:
	get_node("PlayerArea5").disconnect("player_entered", self, "_attack_npc5")
	get_node("NPC/NPC9").attack(player)
	
func _play_win() -> void:
	player.play_win()
	
#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
