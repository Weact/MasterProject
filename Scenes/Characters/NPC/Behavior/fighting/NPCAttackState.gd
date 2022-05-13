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
	launch_timer()
	if !is_instance_valid(weapon):
		return
		
	randDist = 1
	if weapon.is_class("Sword"):
		if is_instance_valid(owner.target):
			owner.update_move_path(owner.target.position)
			if is_instance_valid(owner.target.weapon_node):
				if owner.target.weapon_node.is_class("Sword"):
					state_machine.kite()
					randDist += randi() % 2
				
				
	else:
		randDist += 6+randi() % 6
		weapon.press()
		state_machine.kite()
		
func launch_timer(mini_time = 0.25) -> void:
	if !timer.is_stopped():
		return
	var timer_dur = mini_time+randf()/4
	timer.start(timer_dur)
	
func update(_delta : float) ->void:
	.update(_delta)
	var weapon = owner.weapon_node
	if owner.state_machine == null or !is_instance_valid(owner.target) or !is_instance_valid(weapon):
		return

	var dist_tar = owner.get_path_dist_to(owner.target.position)
	#if dist_tar == 0:
	#	weapon.release()
	if dist_tar <= randDist:
		weapon.press()
	else:
		state_machine.forward()
	
	if is_instance_valid(owner.weapon_node):
		if owner.weapon_node.is_class("Bow"):
			launch_timer(dist_tar*0.2)
		elif owner.weapon_node.is_class("Sword"):
			launch_timer(0)
			
	if is_instance_valid(owner.target.weapon_node):
		if owner.target.weapon_node.is_class("Bow"):
			owner.update_move_path(owner.target.position)
		
	owner.set_look_direction(state_machine.get_target_direction())
	
func exit_state() -> void:
	.exit_state()
	var weapon = owner.weapon_node
	if !is_instance_valid(owner.target):
		if is_instance_valid(weapon):
			weapon.cancel()
		return
		
	var dist_tar = owner.get_path_dist_to(owner.target.position)
	
	if is_instance_valid(weapon):
		if dist_tar <= (state_machine.kite_dist)/16.0+1:
			weapon.press()
			
		var collider = owner.ray_cast_to(owner.target.position- owner.position)
		var can_attack = true
		if collider != owner.target:
			can_attack = false
		if can_attack:
			weapon.release()
		else:
			weapon.cancel()
	
func _on_attackTimer_timeout() -> void:
	var weapon = owner.weapon_node
	if state_machine.current_state != self or !is_instance_valid(weapon) or !is_instance_valid(owner.target):
		return
	var collider = owner.ray_cast_to(owner.target.position - owner.position)
	var can_attack = true
	if collider != owner.target:
		can_attack = false
	if can_attack:
		weapon.release()
	else:
		launch_timer()
	
