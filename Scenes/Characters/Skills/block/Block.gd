extends Skill
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_right_weapon_hit(body) -> void:
	if body == self or !body is Sword:
		print(body.name)
		return
	var bodyParent = body.weapon_handler_node
	if is_instance_valid(bodyParent):
		bodyParent.set_stunned(true)
		parent_character.remove_stamina(bodyParent.get_attack_power())
