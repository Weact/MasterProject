extends Resource

export(int) var id = 0
export(Texture) var icon = null # res://Scenes/UpgradeSkillTree/Assets/SkillIcons
export(String) var name = ""
export(String) var description = ""
export(float) var cost = 1.0
export(bool) var is_learned = false

enum CATEGORY {SWORD = 0, SHIELD, BOW}
export(CATEGORY) var category = CATEGORY.SWORD

### SETTERS
##### Should never be used
func _set_skill_id(new_id : int) -> void:
	id = new_id
func _set_skill_icon(new_icon : Texture) -> void:
	icon = new_icon
func _set_skill_name(new_name : String) -> void:
	name = new_name
func _set_skill_description(new_description : String) -> void:
	description = new_description
func _set_skill_cost(new_cost : float) -> void:
	cost = new_cost
func _set_skill_learned(new_learned : bool) -> void:
	is_learned = new_learned
func _set_skill_category(new_category : int) -> void:
	match(new_category):
		1:
			category = CATEGORY.SWORD
		2:
			category = CATEGORY.SHIELD
		3:
			category = CATEGORY.BOW
		_:
			category = CATEGORY.SWORD

### GETTERS
func get_skill_id() -> int:
	return id
func get_skill_icon() -> Texture:
	return icon
func get_skill_name() -> String:
	return name
func get_skill_description() -> String:
	return description
func get_skill_cost() -> float:
	return cost
func is_skill_learned() -> bool:
	return is_learned
func get_skill_category() -> int:
	return category
func get_skill_category_as_string() -> String:
	match(category):
		0:
			return "SWORD"
		1:
			return "SHIELD"
		2:
			return "BOW"
		_:
			return "skill.weapon.category"
