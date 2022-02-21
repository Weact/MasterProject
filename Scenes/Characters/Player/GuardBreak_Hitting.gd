extends State
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state() -> void:
	var b = owner.weapons_node.get_node_or_null("AnimationPlayer").current_animation
	owner.weapons_node.get_node_or_null("AnimationPlayer").play("GuardBreak_hit")
	var a = owner.weapons_node.get_node_or_null("AnimationPlayer").current_animation
	owner.shield_node.hitbox.call_deferred("set_disabled", false)
	owner.remove_stamina(15)


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
