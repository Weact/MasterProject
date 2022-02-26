extends State
class_name SkillState

func is_class(value: String): return value == "SkillState" or .is_class(value)
func get_class() -> String: return "SkillState"

export var cancelable : bool = true
export var auto_advance : bool = true
export var stamina_cost : float = 0.0
export var state_velocity_factor : float = 1.0
export var state_rotation_factor : float = 1.0
export var state_stamina_regen_factor : float = 1.0
var ready : bool = false

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	if !is_instance_valid(state_machine.parent_character):
		return
	if !state_machine.parent_character is Character:
		return
	ready = false
	state_machine.parent_character.remove_stamina(stamina_cost)
	state_machine.parent_character.velocity_factor.add_variable(state_machine.name+name, state_velocity_factor, 1)
	state_machine.parent_character.rotation_factor.add_variable(state_machine.name+name, state_rotation_factor, 1)
	state_machine.parent_character.regen_stamina.add_variable(state_machine.name+name, state_stamina_regen_factor, 0)

func exit_state() -> void:
	if !is_instance_valid(state_machine.parent_character):
		return
	if state_machine.parent_character is Character:
		state_machine.parent_character.velocity_factor.remove_variable(state_machine.name+name)
		state_machine.parent_character.rotation_factor.remove_variable(state_machine.name+name)
		state_machine.parent_character.regen_stamina.remove_variable(state_machine.name+name)

#### VIRTUALS ####



#### LOGIC ####


#### INPUTS ####



#### SIGNAL RESPONSES ####
