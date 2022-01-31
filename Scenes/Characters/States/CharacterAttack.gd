extends State
class_name CharacterAttackState

func is_class(value: String): return value == "CharacterAttackState" or .is_class(value)
func get_class() -> String: return "CharacterAttackState"

#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####

# Override of State's enter_state
func enter_state():
	if is_instance_valid(owner) and "weapon_node" in owner:
		owner.weapon_node.hitbox.call_deferred("set_disabled", false)
		owner.weapon_node.get_node_or_null("AnimationPlayer").play("attack")

# Override of State's exit_state
func exit_state():
	pass

# Override of State's update_state
func update(_delta):
	pass

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
