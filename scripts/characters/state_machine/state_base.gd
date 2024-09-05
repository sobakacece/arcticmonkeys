extends Node
class_name PlayerState

var state_machine : StateMachine
var my_player : Player
#@export var state_name : StringName
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#state_machine = get_parent()
	
func _on_state_added() -> void:
	#print(name + " enter")
	pass # Replace with function body.

func _state_process(delta: float) -> void:
	pass

func _on_state_exit() -> void:
	#print(name + " exit")
	pass
