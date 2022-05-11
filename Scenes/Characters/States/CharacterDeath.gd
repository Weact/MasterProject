extends State
class_name CharacterDeathState

func is_class(value: String): return value == "CharacterDeathState" or .is_class(value)
func get_class() -> String: return "CharacterDeathState"

#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####

# Override of State's enter_state
func enter_state():
	if is_instance_valid(owner):
		owner.collision_shape.call_deferred("set_disabled", true)
		owner.hitbox.call_deferred("set_disabled", true)
		owner.visible = false
		owner.drop_weapon()
		owner.drop_shield()
		owner.set_weight(0)
		owner.set_stunned(true)
		owner.inherit_vassals()

# Override of State's exit_state
func exit_state():
	pass

# Override of State's update_state
func update(_delta):
	pass
#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
