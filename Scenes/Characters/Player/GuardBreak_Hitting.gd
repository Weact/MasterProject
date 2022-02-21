extends State
class_name CharacterGuardBreakHittingState
func is_class(value: String): return value == "CharacterGuardBreakHittingState" or .is_class(value)
func get_class() -> String: return "CharacterGuardBreakHittingState"

var staminaCost : float = 15.0

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state() -> void:
	if "weapons_animation_player_node" in owner:
		owner.weapons_animation_player_node.play("GuardBreak_hit")
		owner.shield_node.hitbox.call_deferred("set_disabled", false)
		owner.remove_stamina(staminaCost)


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
