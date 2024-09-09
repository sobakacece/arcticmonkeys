extends Node
class_name StateMachine

var current_state : PlayerState
var states_dic : Dictionary
var str : String
signal state_changed(new_state : PlayerState)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is PlayerState:
			states_dic.get_or_add(child.name, child)
			child.my_player = get_parent()
			child.state_machine = self
			
	current_state = states_dic["Slide"]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	current_state._state_process(delta)

func _change_state(state: PlayerState):
	#var state = states_dic[state_name]
	state._on_state_added()
	current_state._on_state_exit()
	current_state = state
	if state:
		state_changed.emit(state)
	
func _change_state_by_name(state_name: String):
	var state = states_dic[state_name]
	state._on_state_added()
	current_state._on_state_exit()
	current_state = state

func _initial_state_check():
	if get_parent().is_on_floor():
		_change_state($Slide)
	else:
		_change_state($Fall)
