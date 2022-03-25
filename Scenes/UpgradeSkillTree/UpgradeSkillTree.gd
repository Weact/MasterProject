extends Control
class_name UpradeSkillTree
func is_class(value: String): return value == "UpradeSkillTree" or .is_class(value)
func get_class() -> String: return "UpradeSkillTree"

onready var skill_upgrades_container : HBoxContainer = get_node_or_null("NinePatchRect/MarginContainer/VBoxContainer/SkillContainer")

var skill_upgrades : PoolStringArray = []

## ACCESSORS

## BUILTIN

func _ready() -> void:
	if skill_upgrades_container.get_child_count() > 0:
		for skill_upgrade in skill_upgrades_container.get_children():
			skill_upgrades.append(skill_upgrade.get_name())

## LOGIC

## SIGNALS
