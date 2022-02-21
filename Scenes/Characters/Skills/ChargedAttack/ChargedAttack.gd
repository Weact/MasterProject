extends StateMachine
class_name ChargedAttackSkillStateMachine
func is_class(value: String): return value == "ChargedAttackSkillStateMachine" or .is_class(value)
func get_class() -> String: return "ChargedAttackSkillStateMachine"

export(bool) var is_unlocked = false
export(float) var attack_power = 25.0
export(float) var stamina_cost = 30.0
export(float) var skill_cooldown = 3.0

export(float) var casting_time = 1.0

var cooldown_timer : Timer = Timer.new()

var on_cooldown : bool = false
var ready_hit : bool = false

#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	var __
	__ = cooldown_timer.connect("timeout", self, "_on_cooldown_timer_timeout")
	
	init_timers()


#### VIRTUALS ####

func enter_state() -> void:
	if not is_instance_valid(owner):
		return
	
	if "weapons_animation_player_node" in owner:
		var __ = owner.weapons_animation_player_node.connect("animation_finished", self, "_on_animation_finished")
	
	set_state("Prep")
	
func exit_state() -> void:
	if "weapon_animation_player_node" in owner:
		var __
		
		if owner.weapon_animation_player_node.is_connected("animation_finished", self, "_on_animation_finished"):
			owner.weapon_animation_player_node.disconnect("animation_finished", self, "_on_aniamtion_finished")

#### LOGIC ####

func init_timers() -> void:
	cooldown_timer.set_wait_time(skill_cooldown)
	cooldown_timer.set_one_shot(true)
	cooldown_timer.set_autostart(false)

func trigger_attack() -> void:
	if not ready_hit and not on_cooldown:
		on_cooldown = true
		cooldown_timer.start()

#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_cooldown_timer_timeout() -> void:
	on_cooldown = false

func _on_animation_finished(_anim_name: String) -> void:
	match(get_state_name()):
		"Recovery":
			owner.set_state("Idle")
		"Hitting":
			set_state("Recovery")
		"Prep":
			ready_hit = true
		_:
			pass
