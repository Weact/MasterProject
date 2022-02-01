extends State
class_name CharacterMoveState

func is_class(value: String): return value == "CharacterMoveState" or .is_class(value)
func get_class() -> String: return "CharacterMoveState"

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
	if(owner.rot_velocity != 0.0):
		owner.update_weapon_rotation(_delta, owner.rot_velocity)
		
	if(owner.get_velocity() != Vector2.ZERO):
		var __ = owner.move_and_slide(owner.get_velocity())
	else:
		owner.set_state("Idle")
	

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
