tool
extends TextureButton

export var skill_texture : Texture = null
export var learned : bool = false
export var skill_name : String = ""
export var weapon_exp_upgrade_cost : float = 1.0

func _ready() -> void:
	if is_instance_valid($Icon):
		$Icon.set_texture(skill_texture)
		
		if not learned:
			$Icon.set_self_modulate(Color(0.3, 0.3, 0.3, 1.0))
			set_self_modulate(Color(1.0, 0.0, 0.0, 1.0))
		else:
			$Icon.set_self_modulate(Color(1.0, 1.0, 1.0, 1.0))
			set_self_modulate(Color(1.0, 1.0, 1.0, 1.0))
	else:
		push_error("Skill Icon does not have Icon child")
		return

func get_learn_exp_cost() -> float:
	return weapon_exp_upgrade_cost

func get_skill_name() -> String:
	return skill_name
