extends State
class_name FightingState

func is_class(value: String): return value == "FightingState" or .is_class(value)
func get_class() -> String: return "FightingState"

export var time_variable_factor : float = 1.0
var time_variable : Variable = Variable.new(0.0)

#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	var __ = time_variable.add_variable("time_variable_factor", time_variable_factor, 2)
	
func update(delta) -> void:
	var __ = time_variable.add_variable("time", delta, 0)

func exit_state() -> void:
	var __ = time_variable.remove_variable("time")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
