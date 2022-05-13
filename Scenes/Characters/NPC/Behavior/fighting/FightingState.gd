extends State
class_name FightingState

func is_class(value: String): return value == "FightingState" or .is_class(value)
func get_class() -> String: return "FightingState"

var global_variable : Variable = Variable.new(1.0)
export var time_variable_factor : float = 1.0
var time_variable : Variable = Variable.new(0.0)
export var distance_variable_factor : float = 1.0
var distance_variable : Variable = Variable.new(1.0)
export var offensive_variable_factor : float = 1.0
var offensive_variable : Variable = Variable.new(1.0)
export var difficulty_variable_factor : float = 0.0
var difficulty_variable : Variable = Variable.new(1.0)

#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	var __ = time_variable.add_variable("time_variable_factor", time_variable_factor, 2)
	__ = distance_variable.add_variable("distance_variable_factor", distance_variable_factor, 2)
	__ = offensive_variable.add_variable("offensive_variable_factor", offensive_variable_factor, 2)
	__ = difficulty_variable.add_variable("difficulty_variable_factor", difficulty_variable_factor, 2)
	
func enter_state() -> void:
	var __ = time_variable.add_variable("time", 2, 0)
	
func update(delta) -> void:
	var value = time_variable.get_variable("time").get_value() - delta
	var __ = time_variable.add_variable("time", value, 0)

func exit_state() -> void:
	var __ = time_variable.add_variable("time", 0, 0)
	__ = global_variable.add_variable("has_skill", 1, 2)

func get_chance_value() -> float:
	var time_factor = time_variable.get_value()/2
	var distance_factor = state_machine.get_target_distance_factor() * distance_variable.get_value()
	var offensive_factor = state_machine.get_offensive_factor() * offensive_variable.get_value()
	var difficulty_factor = (owner.difficulty) * difficulty_variable.get_value()
	return (max(0,time_factor+distance_factor+offensive_factor+difficulty_factor)*100+1)*global_variable.get_value()

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
