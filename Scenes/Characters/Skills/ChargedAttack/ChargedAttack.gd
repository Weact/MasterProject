extends StateMachine
class_name ChargedAttackSkillStateMachine
func is_class(value: String): return value == "ChargedAttackSkillStateMachine" or .is_class(value)
func get_class() -> String: return "ChargedAttackSkillStateMachine"

export(bool) var is_unlocked = false
export(float) var attack_power = 25.0
export(float) var stamina_cost = 30.0

var ready_to_hit : bool = false

#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	var __


#### VIRTUALS ####

func enter_state() -> void:
	if not is_instance_valid(owner) or not is_unlocked:
		return
	
	if "weapons_animation_player_node" in owner:
		if not is_instance_valid(owner.weapons_animation_player_node):
			return
		
		if not owner.weapons_animation_player_node.is_connected("animation_finished", self, "_on_animation_finished"):
			var __ = owner.weapons_animation_player_node.connect("animation_finished", self, "_on_animation_finished")
	set_state("Prep")
	
func exit_state() -> void:
	if "weapons_animation_player_node" in owner:
		var __
		
		if owner.weapons_animation_player_node.is_connected("animation_finished", self, "_on_animation_finished"):
			owner.weapons_animation_player_node.disconnect("animation_finished", self, "_on_animation_finished")
	
	if "is_charging_attack" in owner:
		owner.is_charging_attack = false
	
	owner.velocity_factor = 1.0
	owner.rotation_factor = 1.0
	owner.stamina_regen_factor = 1.0
#### LOGIC ####

func trigger_attack() -> void:
	set_state("Hitting")

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_animation_finished(_anim_name: String) -> void:
	match(get_state_name()):
		"Recovery":
			owner.set_state("Idle")
		"Hitting":
			set_state("Recovery")
		"Prep":
			if get_state_name() == "Prep":
				owner.charged_ready = true
		_:
			pass
