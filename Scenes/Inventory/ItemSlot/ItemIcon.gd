extends TextureRect

const size := Vector2(42,42)

func get_drag_data(_position: Vector2):
	if texture == null:
		return
	
	var inv_slot = get_parent().get_name() # Inv1, Inv2, Inv..., Inv34
	
	# [1] to get the number after "Inv" string, minus 1 for the player inventory array index
	var slot : int = int( inv_slot.split("Inv")[1] ) - 1
	
	var inv = CharacterInventory.get_character_inv_data_as_array()
	var current_item_slot = inv[slot]
	if current_item_slot != null:
		var data = {}
		data["origin_node"] = self
		data["origin_panel"] = "Inventory"
		data["origin_item_id"] = ItemsDatabase.get_item_id(current_item_slot.get_name())
		data["origin_texture"] = texture
		data["origin_slot"] = slot
	
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
	var target_inv_slot_name = get_parent().get_name()
	var origin_inv_slot_name = data["origin_node"].get_parent().get_name()
	
	var origin_inv_slot_index : int = int( origin_inv_slot_name.split("Inv")[1] ) - 1
	var target_inv_slot_index : int = int( target_inv_slot_name.split("Inv")[1] ) - 1
	
	data["origin_node"].texture = data["target_texture"]
	
	CharacterInventory.replace_item(origin_inv_slot_index, target_inv_slot_index)
	texture = data["origin_texture"]
