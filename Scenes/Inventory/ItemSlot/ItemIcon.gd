extends TextureRect

const size := Vector2(42,42)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("inventory_equip_item"):
		if texture == null:
			return
			
		var inv_slot_name : String = get_parent().get_name() # Inv1, Inv2, Inv..., Inv34
		
		if inv_slot_name == "DropItemSlot":
			return
		
		var inv_slot : int = int ( inv_slot_name.split("Inv")[1] ) - 1
		var inv_item : ItemResource = CharacterInventory.get_item(inv_slot)
		
		if inv_item == null:
			return
		
		texture = null
		equip_item(inv_item, inv_slot)

func get_drag_data(_position: Vector2):
	var inv_slot = get_parent().get_name() # Inv1, Inv2, Inv..., Inv34
	if texture == null or inv_slot == "DropItemSlot":
		return
	
	# [1] to get the number after "Inv" string, minus 1 for the player inventory array index
	var slot : int = int( inv_slot.split("Inv")[1] ) - 1
	if slot >= CharacterInventory.character_inv_size:
		return
	
	var inv = CharacterInventory.get_character_inv_data_as_array()
	var current_item_slot = inv[slot]
	if current_item_slot != null:
		var data = {}
		data["origin_node"] = self
		data["origin_panel"] = "Inventory"
		data["origin_item_id"] = ItemsDatabase.get_item_id(current_item_slot.get_name())
		data["origin_texture"] = texture
		data["origin_slot"] = slot
		data["item_dropped"] = false
	
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = texture
		drag_texture.rect_size = size
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.rect_position = -0.5 * drag_texture.rect_size
		
		set_drag_preview(control)
		
		return data
	else:
		push_error("Slot %d is null in inventory" % slot)
		return null

func can_drop_data(_position: Vector2, data) -> bool:
	var target_slot_name = get_parent().get_name()
	
	# check if its the dropitemslot, outside of the inventory
	if target_slot_name == "DropItemSlot":
		data["item_dropped"] = true
		data["target_item_id"] = null
		data["target_texture"] = null
		return true
		
	var target_slot_index : int = int( target_slot_name.split("Inv")[1] ) - 1
	
	var target_inv_item_slot = CharacterInventory.get_character_inv_data_as_array()[target_slot_index]
	if target_inv_item_slot == null:
		data["target_item_id"] = null
		data["target_texture"] = null
		return true
	else: #swap item
		data["target_item_id"] = ItemsDatabase.get_item_id(target_inv_item_slot.get_name())
		data["target_texture"] = texture
		return true

func drop_data(_position: Vector2, data) -> void:
	if not is_instance_valid(data["origin_node"]):
		return
	
	if data["item_dropped"] == true:
		var targetted_item_slot : int = int ( data["origin_node"].get_parent().get_name().split("Inv")[1] ) - 1
		var targetted_item : ItemResource = CharacterInventory.get_item(targetted_item_slot)
		var tagetted_item_name : String = targetted_item.get_name()
		var _generated_item = GAME.generate_item(tagetted_item_name)
		
		if is_instance_valid(GAME.PLAYER_NODE):
			_generated_item.set_position(GAME.PLAYER_NODE.get_position())
		else:
			_generated_item.set_position(Vector2(0,0))
			
		CharacterInventory.remove_item(targetted_item_slot)
		data["origin_node"].texture = data["target_texture"]
		texture = null
		return
	
	var target_inv_slot_name = get_parent().get_name()
	var origin_inv_slot_name = data["origin_node"].get_parent().get_name()
	
	var origin_inv_slot_index : int = int( origin_inv_slot_name.split("Inv")[1] ) - 1
	var target_inv_slot_index : int = int( target_inv_slot_name.split("Inv")[1] ) - 1
	
	data["origin_node"].texture = data["target_texture"]
	
	CharacterInventory.replace_item(origin_inv_slot_index, target_inv_slot_index)
	texture = data["origin_texture"]

func equip_item(item : ItemResource, slot : int) -> void:
	CharacterInventory.remove_item(slot)
	EVENTS.emit_signal("inventory_item_equip", item, slot)
