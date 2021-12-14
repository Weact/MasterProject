extends State
class_name StateMachine

func is_class(value: String) -> bool : return value == "StateMachine" or .is_class(value)
func get_class() -> String: return "StateMachine"

var current_state : Node = null setget set_state, get_state
var previous_state : Node = null setget set_state, get_previous_state

signal state_changed(state)
signal state_changed_recursive(state)

#### ACCESSORS ####

func set_state(state)->void:
	if state is String:
		state = get_node_or_null(state)
		
	if state == current_state:
		return
	
	if current_state != null:
		current_state.exit_state()
		
	previous_state = current_state
	current_state = state
	
	if current_state != null:
		current_state.enter_state()
		
	emit_signal("state_changed", current_state)
func get_state() -> Node: return current_state
func get_state_name() -> String :
	if current_state == null:
		return ""
	return current_state.name
func get_previous_state() -> Node: return current_state

#### BUILD IN ####

func _ready()->void:
	var __ = connect("state_changed", self, "_on_state_changed")
	
	if state_machine.is_class("StateMachine"):
		__ = connect("state_changed_recursive", state_machine, "_on_state_changed_recursive")
	
	set_to_default_state()

func _physics_process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)

#### LOGIC ####

func enter_state() -> void:
	set_to_default_state()
	
func exit_state() -> void:
	set_state(null)

func update_animation(state) -> void:
	var state_name = state.name
	var animated_sprite = owner.get_node_or_null("AnimatedSprite")
	
	if animated_sprite == null:
		return

	var sprite_frames = animated_sprite.get_sprite_frames()
	if sprite_frames == null:
		return
		
	if sprite_frames.has_animation(state_name):
		animated_sprite.play(state_name)

func set_to_default_state() -> void:
	 set_state(get_child(0))
	
func _on_state_changed(state : Node) -> void:
	update_animation(state)
	emit_signal("state_changed_recursive", current_state)

func _on_state_changed_recursive(_state : Node) -> void:
	emit_signal("state_changed_recursive", current_state)
