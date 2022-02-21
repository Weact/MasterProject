extends StateMachine
class_name ChargedAttackSkillStateMachine
func is_class(value: String): return value == "ChargedAttackSkillStateMachine" or .is_class(value)
func get_class() -> String: return "ChargedAttackSkillStateMachine"

export(bool) var is_unlocked = false
export(float) var attack_power = 25.0
export(float) var stamina_cost = 30.0
export(float) var skill_cooldown = 3.0

var cooldown_timer : Timer = Timer.new()

var on_cooldown : bool = false

#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	var __
	__ = cooldown_timer.connect("timeout", self, "_on_cooldown_timer_timeout")
	
	init_timers()


#### VIRTUALS ####



#### LOGIC ####

func init_timers() -> void:
	cooldown_timer.set_wait_time(skill_cooldown)
	cooldown_timer.set_one_shot(true)
	cooldown_timer.set_autostart(false)

#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_cooldown_timer_timeout() -> void:
	on_cooldown = false
