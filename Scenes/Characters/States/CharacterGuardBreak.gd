extends StateMachine
class_name CharacterGuardBreakState
func is_class(value: String): return value == "CharacterGuardBreakState" or .is_class(value)
func get_class() -> String: return "CharacterGuardBreakState"

var readyToHit : bool = false
var tryingToHit : bool = false

#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####
func enter_state():
	tryingToHit = false
	readyToHit = false
	var __ = owner.weapons_node.connect("animation_finished", self, "_on_weapons_anim_finished")
	if is_instance_valid(owner):
		owner.velocity_factor = 0.1
		owner.rotation_factor = 0.1
		owner.stamina_regen_factor = -1.0
		if is_instance_valid(owner.weapons_node) and is_instance_valid(owner.weapon_node):
			set_state("Prep")

func exit_state():
	if is_instance_valid(owner):
		owner.velocity_factor = 1.0
		owner.rotation_factor = 1.0
		owner.stamina_regen_factor = 1.0
		var __ = owner.weapons_node.disconnect("animation_finished", self, "_on_weapons_anim_finished")
		
		owner.weapons_node.get_node_or_null("AnimationPlayer").play("unblock")
		if is_instance_valid(owner.weapon_node) and is_instance_valid(owner.weapon_node):
			owner.shield_node.hitbox.call_deferred("set_disabled", true)

#### LOGIC ####
func hit():
	if !is_instance_valid(owner):
		return
	if !(is_instance_valid(owner.weapons_node) and is_instance_valid(owner.weapon_node)):
		return

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

#### INPUTS ####

#### SIGNAL RESPONSES ####
func _on_weapons_anim_finished() :
	if get_state_name() == "Recovery":
		owner.set_state("Idle")
	if get_state_name() == "Hitting":
		recovery()
	if get_state_name() == "Prep":
		readyToHit = true
		if tryingToHit:
			hit()
