extends Skill
class_name ChargedAttackSkill
func is_class(value: String): return value == "ChargedAttackSkill" or .is_class(value)
func get_class() -> String: return "ChargedAttackSkill"


#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####
#### LOGIC ####

#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_left_weapon_hit(body: Node2D):
	if body != self and is_instance_valid(body.get_node_or_null("DamageableBehavior")):
		var damageable = body.get_node_or_null("DamageableBehavior")
		if damageable != null:
			damageable.take_damage(parent_character.get_attack_power(), parent_character)
			if body.has_method("set_stunned"):
				body.set_stunned(true)
		return
