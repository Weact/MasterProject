extends Skill
class_name BlockSkill

func is_class(value: String): return value == "BlockSkill" or .is_class(value)
func get_class() -> String: return "BlockSkill"

#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_right_weapon_hit(body) -> void:
	if body == self or !body is Sword:
		return
		
	var bodyParent = body.weapon_handler_node
	if is_instance_valid(bodyParent):
		bodyParent.set_stunned(true)
		bodyParent.weapon_node.hitbox.call_deferred("set_disabled", true)
		
		parent_character.remove_stamina(bodyParent.get_attack_power())
