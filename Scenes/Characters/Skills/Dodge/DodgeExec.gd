extends ExecuteSkill
class_name DodgeExecSkill

func is_class(value: String): return value == "DodgeExecSkill" or .is_class(value)
func get_class() -> String: return "DodgeExecSkill"

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	.call_state()
	state_machine.play_current_state_anim()
	
# Override of State's exit_state

# Override of State's update_state
func update(_delta):
	animate_dodging()

func animate_dodging() -> void:
	var dodge_anim = state_machine.dodge_sprite_animation.instance()
	dodge_anim.global_position = state_machine.parent_character.global_position
	get_parent().add_child(dodge_anim)

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
