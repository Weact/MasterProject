extends Node
class_name State

func get_class() -> String : return "State"
func is_class(value: String) -> bool: return value == "State" or .is_class(value)

# Abstract base class for a state in a statemachine

# Defines the behaviour of the entity possesing the statemachine 
# when the entity is in this state

# The enter_state is called every time the state is entered and exit_state when its exited
# the update_state of the currrent state is called every physics tick,  
# by the physics_process of the StateMachine 

onready var state_machine = get_parent()

# Called when the current state of the state machine is set to this node
func enter_state():
	pass

# Called when the current state of the state machine is switched to another one
func exit_state():
	pass

# Called every frames, for real time behaviour
# Use a return "State_node_name" or return Node_reference to change the current state of the state machine at a given time
func update(_delta):
	pass


# Check if the entity is in this state. Check reccursivly in cas of nested StateMachines/PushdownAutomata
func is_current_state() -> bool:
	if state_machine.has_method("is_current_state"):
		return state_machine.current_state == self && state_machine.is_current_state()
	else:
		return state_machine.current_state == self
