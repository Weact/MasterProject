extends Skill
class_name DodgeSkill

func is_class(value: String): return value == "DodgeSkill" or .is_class(value)
func get_class() -> String: return "DodgeSkill"

onready var dodge_sprite_animation : PackedScene = preload("res://Scenes/Characters/Skills/Dodge/DodgeSprite/DodgeSprite.tscn")

#### ACCESSORS ####

#### BUILT-IN ####


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
