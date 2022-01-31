extends State
class_name CharacterBlockState

func is_class(value: String): return value == "CharacterBlockState" or .is_class(value)
func get_class() -> String: return "CharacterBlockState"

#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####

# Override of State's enter_state
func enter_state():
	if is_instance_valid(owner) and "shield_node" in owner:
		owner.shield_node.get_node_or_null("AnimationPlayer").play("block")

# Override of State's exit_state
func exit_state():
	if is_instance_valid(owner) and "shield_node" in owner:
		owner.shield_node.get_node_or_null("AnimationPlayer").play("unblock")

# Override of State's update_state
func update(_delta):
	pass

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
