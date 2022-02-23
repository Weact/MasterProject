extends Skill
class_name AttackSkill
func is_class(value: String): return value == "AttackSkill" or .is_class(value)
func get_class() -> String: return "AttackSkill"

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
			damageable.take_damage(parent_character.get_attack_power())
			body.set_stunned(true)
		return
