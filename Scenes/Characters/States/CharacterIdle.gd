extends State
class_name CharacterIdleState

func is_class(value: String): return value == "CharacterIdleState" or .is_class(value)
func get_class() -> String: return "CharacterIdleState"

#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####

# Override of State's enter_state
func enter_state():
	pass

# Override of State's exit_state
func exit_state():
	pass

# Override of State's update_state
func update(_delta):
	var is_moving : bool = owner.get_velocity() != Vector2.ZERO
	if is_moving:
		owner.set_state("Move")

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
