extends State
class_name CharacterAttackState

func is_class(value: String): return value == "CharacterAttackState" or .is_class(value)
func get_class() -> String: return "CharacterAttackState"

#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####

# Override of State's enter_state
func enter_state():
	if is_instance_valid(owner):
		owner.velocity_factor = 0.3
		owner.rotation_factor = 0.2
		if "weapons_node" in owner and "weapon_node" in owner:
			owner.weapons_node.get_node_or_null("AnimationPlayer").play("attack")
			owner.weapon_node.hitbox.call_deferred("set_disabled", false)

# Override of State's exit_state
func exit_state():
	if is_instance_valid(owner):
		owner.velocity_factor = 1.0
		owner.rotation_factor = 1.0

# Override of State's update_state
func update(_delta):
	pass

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
