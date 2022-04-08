extends State
class_name CharacterSkillingState

func is_class(value: String): return value == "CharacterSkillingState" or .is_class(value)
func get_class() -> String: return "CharacterSkillingState"

#### ACCESSORS ####

#### BUILT-IN ####
func exit_state():
	owner.get_available_skills().set_state(null)


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
