tool
extends TextureButton

export var skill_texture : Texture = null
export var learned : bool = false
export var skill_name : String = ""
export var weapon_exp_upgrade_cost : float = 1.0

const learned_modulate : Color = Color(1.0, 1.0, 1.0, 1.0)
const unlearned_modulate : Color = Color(0.3, 0.3, 0.3, 1.0)
const unlearned_bg_modulate : Color = Color(1.0, 0.0, 0.0, 1.0)

func set_learned(learn : bool) -> void:
	if learn:
		$Icon.set_self_modulate(learned_modulate)
		set_self_modulate(learned_modulate)
	else:
		$Icon.set_self_modulate(unlearned_modulate)
		set_self_modulate(unlearned_bg_modulate)

func is_learned() -> bool:
	return learned

func _ready() -> void:
	if is_instance_valid($Icon):
		$Icon.set_texture(skill_texture)
		set_learned(learned)
		
	else:
		push_error("Skill Icon does not have Icon child")
		return

func get_learn_exp_cost() -> float:
	return weapon_exp_upgrade_cost

func get_skill_name() -> String:
	return skill_name
