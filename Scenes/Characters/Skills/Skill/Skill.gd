extends StateMachine
class_name Skill

func is_class(value: String): return value == "Skill" or .is_class(value)
func get_class() -> String: return "Skill"

var parent_character : Node2D = null

onready var anim_player : AnimationPlayer = get_node_or_null("AnimationPlayer")
#### ACCESSORS ####
func get_stamina_cost() -> float:
	var cost : float = 0.0
	for state in get_children():
		if !state is SkillState:
			continue
		cost = cost + state.stamina_cost
		
	return cost
	
#### BUILT-IN ####
func exit_state() -> void:
	.exit_state()
	

#### VIRTUALS ####


#### LOGIC ####
func is_cancelable() -> bool:
	return current_state.cancelable

func play_current_state_anim() -> void:
	if !is_instance_valid(parent_character):
		return
	
	parent_character.weapons_animation_player_node.play(String(name) +"_"+ String(current_state.name))

func prepare() -> void:
	if state_machine.current_state != self:
		return
	set_state("Preparation")
	
func execute() -> void:
	if state_machine.current_state != self:
		return
	set_state("Execute")
	
func recover() -> void:
	if state_machine.current_state != self:
		return
	set_state("Recovery")

func is_ready() -> bool:
	if is_instance_valid(current_state):
		return current_state.ready
	return false
	
	
func new_owner(new_owner : Node2D) -> void:
	if !is_instance_valid(new_owner):
		return
	if is_instance_valid(parent_character):
		parent_character.weapons_node.disconnect("animation_finished", self, "_on_weapons_animation_finished")
		parent_character.weapon_node.disconnect("collided", self, "_on_left_weapon_hit")
		parent_character.shield_node.disconnect("collided", self, "_on_right_weapon_hit")

	state_machine = get_parent()
	owner = new_owner
	parent_character = new_owner
	if parent_character is Character:
		transfer_animations(parent_character.weapon_point.get_path(), parent_character.shield_point.get_path(), parent_character.weapons_animation_player_node)
		parent_character.weapons_node.connect("animation_finished", self, "_on_weapons_animation_finished")
		parent_character.weapon_node.connect("collided", self, "_on_left_weapon_hit")
		parent_character.shield_node.connect("collided", self, "_on_right_weapon_hit")
		
func transfer_animations(weapon_left_path : NodePath, weapon_right_path : NodePath, new_anim_player : AnimationPlayer) -> void:
	if !is_instance_valid(parent_character) or !parent_character is Character:
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
			var lastDotPos = String(trackPath).find_last(":")
			
			var currentAnimName = String(trackPath).right(lastDashPos)
			currentAnimName = currentAnimName.left(String(currentAnimName).find_last(":"))
			var currentTrackSubName = String(trackPath).right(lastDotPos)
			
			if currentAnimName != animNodeName and animNodeName != "":
				rightWeapon = true
				
			animNodeName = currentAnimName
			
			var completeNodePath = String(weapon_left_path) + String(currentTrackSubName)
			
			if rightWeapon:
				completeNodePath = String(weapon_right_path) + String(currentTrackSubName)
			
			anim.track_set_path(i, NodePath(completeNodePath))
		
		var __ = new_anim_player.add_animation(name+"_"+anim_name, anim)

#### INPUTS ####

#### SIGNAL RESPONSES ####
func _on_left_weapon_hit(_body) -> void:
	pass
	
func _on_right_weapon_hit(_body) -> void:
	pass
	
func _on_weapons_animation_finished() -> void:
	if !is_instance_valid(parent_character) or parent_character.state_machine.current_state.name != "Skilling" or state_machine.current_state != self:
		return
	
	current_state.ready = true
	if current_state.auto_advance == true:
		if get_state_name() == "Recovery":
			owner.state_machine.set_state("Idle")
		if get_state_name() == "Execute":
			recover()
		if get_state_name() == "Preparation":
			execute()
