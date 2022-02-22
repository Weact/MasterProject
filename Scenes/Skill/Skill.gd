extends StateMachine
class_name Skill

func is_class(value: String): return value == "Skill" or .is_class(value)
func get_class() -> String: return "Skill"

export var min_stamina_cost : float = 0.0

var parent_character :Node2D = null
export var auto_advance = true

onready var anim_player : AnimationPlayer = $AnimationPlayer
#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####



#### LOGIC ####
func enter_state() -> void:
	prepare()

func prepare() -> void:
	set_state("Preparation")
	
func execute() -> void:
	set_state("Execute")
	
func recover() -> void:
	set_state("Recovery")
	
func add_skill(new_owner : Node2D) -> void:
	if !is_instance_valid(new_owner):
		return
	if is_instance_valid(parent_character):
		parent_character.weapons_node.disconnect("animation_finished", self, "_on_weapons_animation_finished")
	
	parent_character = new_owner
	if parent_character is Character:
		transfer_animations(parent_character.weapon_point.get_path(), parent_character.shield_point.get_path(), parent_character.weapons_animation_player_node)
		parent_character.weapons_node.connect("animation_finished", self, "_on_weapons_animation_finished")

func transfer_animations(weapon_left_path : NodePath, weapon_right_path : NodePath, new_anim_player : AnimationPlayer) -> void:
	if !is_instance_valid(owner) or !owner is Character:
		print("No valid owner to this skill")
		return
	var anim_name_list = anim_player.get_animation_list()
	
	for anim_name in anim_name_list:
		var anim = anim_player.get_animation(anim_name)
		var animNodeName = ""
		var rightWeapon = false
		
		for i in range(0, anim.get_track_count()):
			var trackPath = anim.track_get_path(i)
			var lastDashPos = String(trackPath).find_last("/")
			var currentAnimName = String(trackPath).left(lastDashPos)
			var currentTrackSubName = String(trackPath).right(String(trackPath).find_last(":"))
			
			if currentAnimName == animNodeName:
				rightWeapon = true
				
			animNodeName = currentAnimName
			
			if rightWeapon:
				anim.track_set_path(i, NodePath(String(weapon_right_path) + String(currentTrackSubName)))
			else:
				anim.track_set_path(i, NodePath(String(weapon_left_path) + String(currentTrackSubName)))
		
		var __ = new_anim_player.add_animation(name+"_"+anim_name, anim)

#### INPUTS ####

#### SIGNAL RESPONSES ####
func _on_weapons_animation_finished() -> void:
	if !is_instance_valid(parent_character):
		return
	
	if current_state.auto_advance == true:
		if get_state_name() == "Recovery":
			owner.set_state("Idle")
		if get_state_name() == "Execute":
			recover()
		if get_state_name() == "Preparation":
			prepare()
