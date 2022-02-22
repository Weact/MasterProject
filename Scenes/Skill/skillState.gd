extends State
class_name SkillState

func is_class(value: String): return value == "SkillState" or .is_class(value)
func get_class() -> String: return "SkillState"

export var auto_advance : bool = true
export var state_velocity_factor = 1.0
export var state_rotation_factor = 1.0
export var state_stamina_regen_factor = 1.0

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	if !is_instance_valid(state_machine.parent_character):
		return
	if !state_machine.parent_character is Character:
		state_machine.parent_character.velocity_factor = state_velocity_factor
		state_machine.parent_character.rotation_factor = state_rotation_factor
		state_machine.parent_character.stamina_regen_factor = state_stamina_regen_factor

func exit_state() -> void:
	if !is_instance_valid(state_machine.parent_character):
		return
	if !state_machine.parent_character is Character:
		state_machine.parent_character.velocity_factor = 1.0
		state_machine.parent_character.rotation_factor = 1.0
		state_machine.parent_character.stamina_regen_factor = 1.0

#### VIRTUALS ####



#### LOGIC ####


#### INPUTS ####



#### SIGNAL RESPONSES ####
