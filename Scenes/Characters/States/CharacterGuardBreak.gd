extends StateMachine
class_name CharacterGuardBreakState
func is_class(value: String): return value == "CharacterGuardBreakState" or .is_class(value)
func get_class() -> String: return "CharacterGuardBreakState"

var readyToHit : bool = false
var tryingToHit : bool = false

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state():
	tryingToHit = false
	readyToHit = false
	var __ = owner.shield_node.connect("anim_done", self, "_on_shield_anim_finished")
	if is_instance_valid(owner):
		owner.velocity_factor = 0.1
		owner.rotation_factor = 0.1
		owner.stamina_regen_factor = -1.0
		if is_instance_valid(owner.weapons_node) and is_instance_valid(owner.weapon_node):
			set_state("Prep")

func hit():
	if !is_instance_valid(owner):
		return
	if !(is_instance_valid(owner.weapons_node) and is_instance_valid(owner.weapon_node)):
		return
	var statename : String = get_state_name()
	if !readyToHit:
		tryingToHit = true
		return
	set_state("Hitting")
	readyToHit = false

func recovery():
	if !is_instance_valid(owner):
		return
	if !(is_instance_valid(owner.weapons_node) and is_instance_valid(owner.weapon_node)):
		return
	
	set_state("Recovery")
	owner.weapons_node.get_node_or_null("AnimationPlayer").play("GuardBreak_recov")
	owner.shield_node.hitbox.call_deferred("set_disabled", true)
	
#### VIRTUALS ####
func exit_state():
	if is_instance_valid(owner):
		owner.velocity_factor = 1.0
		owner.rotation_factor = 1.0
		owner.stamina_regen_factor = 1.0
		var __ = owner.shield_node.disconnect("anim_done", self, "_on_shield_anim_finished")
		
		owner.weapons_node.get_node_or_null("AnimationPlayer").play("unblock")
		if is_instance_valid(owner.weapon_node) and is_instance_valid(owner.weapon_node):
			owner.shield_node.hitbox.call_deferred("set_disabled", true)



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_shield_anim_finished() :
	if get_state_name() == "Recovery":
		owner.set_state("Idle")
	if get_state_name() == "Hitting":
		recovery()
	if get_state_name() == "Prep":
		readyToHit = true
		if tryingToHit:
			hit()
