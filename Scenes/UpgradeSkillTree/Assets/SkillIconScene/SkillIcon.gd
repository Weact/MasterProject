extends TextureButton

#######################################################

### How to get a skill information ?
### Use SKILL_LIST Global Class

#######################################################

# GET NAME
### SKILL_LIST._get_skill_by_name(skill_name : String)

# GET ID
### SKILL_LIST._get_skill_by_id(skill_id : int)

#######################################################

### Skills methods :
####	func get_skill_id() -> int
####	func get_skill_icon() -> Texture
####	func get_skill_name() -> String
####	func get_skill_cost() -> float
####	func is_skill_learned() -> bool
####	func get_skill_category() -> int

#######################################################

export var skill_name : String = ""

var skill_texture : Texture = null
var learned : bool = false
var weapon_exp_upgrade_cost : float = 0.0

var current_skill : Resource = null

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
	
	learned = learn

func is_learned() -> bool:
	return learned

func _ready() -> void:
	if skill_name != "":
		current_skill = SKILL_LIST._get_skill_by_name(skill_name)
		
		skill_texture = current_skill.get_skill_icon()
		learned = current_skill.is_skill_learned()
		weapon_exp_upgrade_cost = current_skill.get_skill_cost()
		
		if is_instance_valid($Icon):
			$Icon.set_texture(skill_texture)
			set_learned(learned)
		else:
			push_error("Skill Icon does not have Icon child")
			return
	else:
		if GAME.PRINT_DEBUG:
			push_warning("No skill_name for node " + get_path())
		return

func get_learn_exp_cost() -> float:
	return weapon_exp_upgrade_cost

func get_skill_name() -> String:
	return skill_name
