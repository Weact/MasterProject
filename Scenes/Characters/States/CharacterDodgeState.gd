extends State
class_name CharacterDodgeState
func is_class(value: String): return value == "CharacterDodgeState" or .is_class(value)
func get_class() -> String: return "CharacterDodgeState"

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
	owner.animate_dodging()

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
