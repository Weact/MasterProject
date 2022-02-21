extends State
class_name CharacterMoveState

func is_class(value: String): return value == "CharacterMoveState" or .is_class(value)
func get_class() -> String: return "CharacterMoveState"

#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####

# Override of State's enter_state
func enter_state():
	if !is_instance_valid(owner):
		return
	owner.stamina_regen_factor = 0.9

# Override of State's exit_state
func exit_state():
	if !is_instance_valid(owner):
		return
	owner.stamina_regen_factor = 1.0

# Override of State's update_state
func update(_delta):
	if(owner.get_velocity() == Vector2.ZERO):
		owner.set_state("Idle")
	

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
