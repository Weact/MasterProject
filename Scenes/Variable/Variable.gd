extends Node
class_name Variable

func is_class(class_value: String): return class_value == "Variable" or .is_class(class_value)
func get_class() -> String: return "Variable"

enum TYPE {sum, value_factor, factor}
export var value : float = 0.0
export(TYPE) var type = TYPE.sum

#### ACCESSORS ####
func get_value() -> float :
	var final_value : float = value
	var factors_total : float = 0.0
	var sums_total : float = 0.0
	var mults_total : float = 1.0
	var children = get_children()
	for child in children:
		if !child.is_class("Variable"): #Only check variables
			continue	
			
		var child_value : float = child.get_value() #Recursive get_value()
		if child.type == TYPE.value_factor:
			factors_total += child_value
		elif child.type == TYPE.factor:
			mults_total *= child_value
		else:
			sums_total += child_value
			
	return ((final_value+sums_total)+(final_value* factors_total))*mults_total


#### BUILT-IN ####

#### VIRTUALS ####

#### LOGIC ####
func add_variable(v_name : String, v_value : float = 0.0, v_type = TYPE.sum) -> Variable:
	var new_variable = get_variable(v_name)
	if is_instance_valid(new_variable):
		update_variable(new_variable, v_value)
		return new_variable
	
	new_variable = load("res://Scenes/Variable/Variable.tscn").instance()
	new_variable.type = v_type
	new_variable.value = float(v_value)
	new_variable.name = v_name
	
	add_child(new_variable)
	
	return new_variable

func _init(v_value: float = 0, v_type = TYPE.sum):
	value = v_value
	type = v_type
	
	
func update_variable(variable : Variable, v_value: float) -> void:
	if !is_instance_valid(variable) :
		return
	
	variable.value = v_value

func get_variable(v_name : String) -> Variable:
	var variable = null
	for child in get_children():
		if child.name == v_name:
			variable = child
			return variable
			
	return null

func remove_variable(v_name : String) -> bool:
	var variable = get_variable(v_name)
	if is_instance_valid(variable):
		variable.queue_free()
		return true
	
	return false
	
#### INPUTS ####



#### SIGNAL RESPONSES ####
