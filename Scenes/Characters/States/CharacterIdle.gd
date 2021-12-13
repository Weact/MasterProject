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
func update_state(_delta):
	pass

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
