extends State
class_name CharacterDodgeState
func is_class(value: String): return value == "CharacterDodgeState" or .is_class(value)
func get_class() -> String: return "CharacterDodgeState"

#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####

# Override of State's enter_state
func enter_state():
	if "is_dodging" in owner:
		owner.is_dodging = false
	if owner.has_method("set_movement_speed"):
		owner.set_movement_speed(owner.get_movement_speed() * 3)
	if owner.has_method("remove_stamina"):
		owner.remove_stamina(owner.dodge_cost)

# Override of State's exit_state
func exit_state():
	if "is_dodging" in owner:
		owner.is_dodging = false
	if owner.has_method("set_movement_speed"):
		owner.set_movement_speed(owner.get_movement_speed() / 3)

# Override of State's update_state
func update(_delta):
	owner.animate_dodging()

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
