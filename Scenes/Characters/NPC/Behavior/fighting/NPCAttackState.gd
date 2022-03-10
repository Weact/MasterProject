extends FightingState
class_name NpcAttackBehavior
func is_class(value: String): return value == "NpcAttackBehavior" or .is_class(value)
func get_class() -> String: return "NpcAttackBehavior"

var randDist = 0
onready var timer = get_node("AttackTimer")

func _ready() -> void:
	var __ = timer.connect("timeout", self, "_on_attackTimer_timeout")

func enter_state() -> void:
	.enter_state()
	if owner.state_machine == null or !is_instance_valid(owner.target):
		return
	
	var weapon = owner.weapon_node
	owner.set_look_direction(state_machine.get_target_direction())
	owner.update_move_path(owner.target.position)
	if is_instance_valid(weapon) and weapon.is_class("Sword"):
		state_machine.tryDodge()
	var timer_dur = 0.2+randf()/2
	timer.start(timer_dur)
	if !is_instance_valid(weapon):
		return
		
	randDist = 0
	if weapon.is_class("Sword"):
		if is_instance_valid(owner.target):
			owner.update_move_path(owner.target.position)
			if is_instance_valid(owner.target.weapon_node):
				if owner.target.weapon_node.is_class("Sword"):
					state_machine.kite()
					randDist += randi() % 3
				
				
	else:
		weapon.press()
		state_machine.kite()
	
func update(_delta : float) ->void:
	.update(_delta)
	if owner.state_machine == null or !is_instance_valid(owner.target):
		return

	var weapon = owner.weapon_node
	var dist_tar = owner.get_path_dist_to(owner.target.position)
	if is_instance_valid(owner.target.weapon_node):
		if owner.target.weapon_node.is_class("Bow"):
			owner.update_move_path(owner.target.position)
	if dist_tar <= randDist:
		weapon.press()
	if dist_tar <= 0:
		weapon.release()
	owner.set_look_direction(state_machine.get_target_direction())
	
func exit_state() -> void:
	.exit_state()
	if !is_instance_valid(owner.target):
		return
		
	var dist_tar = owner.get_path_dist_to(owner.target.position)
	
	var weapon = owner.weapon_node
	if is_instance_valid(weapon):
		if dist_tar <= (state_machine.kite_dist)/16.0+1:
			weapon.press()
		weapon.release()
	
func _on_attackTimer_timeout() -> void:
	state_machine.set_state("Kiting")
	
