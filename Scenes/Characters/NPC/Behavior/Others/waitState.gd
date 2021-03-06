extends State

class_name waitState

export var min_wait_time : float = 1.0
export var max_wait_time : float = 3.2

signal waitTimeFinished

func _ready()->void:
	var __ = $Timer.connect("timeout", self, "_on_Timer_timeout")

func enter_state() -> void:
	if !is_instance_valid(owner):
		return
	
	var wait_time = rand_range(min_wait_time, max_wait_time)
	$Timer.start(wait_time)
	
func _on_Timer_timeout() -> void:
	emit_signal("waitTimeFinished")
