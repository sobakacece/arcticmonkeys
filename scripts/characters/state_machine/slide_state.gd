extends PlayerState
class_name SlideState

@export var jump_state : PlayerState
@export var fall_state : PlayerState

func _state_process(delta: float) -> void:
	if Input.is_action_pressed("jump"):
		state_machine._change_state(jump_state)
	elif !my_player.is_on_floor():
		state_machine._change_state(fall_state)
