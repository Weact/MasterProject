extends Skill
class_name GuardBreakSkill
func is_class(value: String): return value == "GuardBreakSkill" or .is_class(value)
func get_class() -> String: return "GuardBreakSkill"

#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
func _on_right_weapon_hit(body : PhysicsBody2D) -> void:
	if body == self or !body is Shield:
		return
	var bodyParent = body.weapon_handler_node
	if is_instance_valid(bodyParent):
		bodyParent.set_stunned(true)
		bodyParent.remove_stamina(parent_character.get_attack_power())
