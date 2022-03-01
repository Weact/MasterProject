extends Entity
class_name Arrow

func is_class(value: String): return value == "Arrow" or .is_class(value)
func get_class() -> String: return "Arrow"

var shooter = null
var launched = false
var launch_speed = 1500
#### ACCESSORS ####

#### BUILT-IN ####
func _init(body = null) -> void:
	shooter = body
	
func _ready() -> void:
	var __ = $Area2D.connect("body_entered", self, "_on_body_entered")
	__ = $Timer.connect("timeout", self, "_on_timeout")
	
func _physics_process(_delta: float) -> void:
	var vel = get_computed_velocity()
	var __ = move_and_slide(vel)
	
	if launched:
		set_movement_speed(movement_speed - _delta * 700)
		if get_movement_speed() <= 150:
			stop()
	
func stop():
	movement_speed = 0
	launched = false
	$AnimationPlayer.play("Stop")
	$Area2D/CollisionShape2D.call_deferred("set_disabled", true)
	$Timer.start()
	
func prep(duration = 1.0) -> void:
	$AnimationPlayer.play("Charge", -1, 1.0/duration)
	
func launch() -> void:
	$Area2D/CollisionShape2D.call_deferred("set_disabled", false)
	launched = true
	set_movement_speed(launch_speed)
	
#### VIRTUALS ####
#### LOGIC ####
#### INPUTS ####
#### SIGNAL RESPONSES ####
func _on_timeout() -> void:
	queue_free()
	
func _on_body_entered(body) -> void:
	if !is_instance_valid(body) or body == shooter:
		return
	
	var damageable = body.get_node_or_null("DamageableBehavior")
	if !is_instance_valid(damageable):
		stop()
		return
	
	if is_instance_valid(shooter):
		damageable.take_damage(shooter.get_attack_power())
	
	if body.has_method("set_stunned"):
		body.set_stunned(true)
	
	queue_free()
