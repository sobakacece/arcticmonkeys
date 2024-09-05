extends PlayerState
class_name Jump_State
var jump_timer : SceneTreeTimer	
@export var jump_state_time : float
@export var jump_velocity : float
@export var fall_state : PlayerState
@export var landed_state : PlayerState
func _on_state_added() -> void:
	super()
	jump_timer = get_tree().create_timer(jump_state_time, false, true)
	jump_timer.timeout.connect(func(): _check_next_state())
	my_player.velocity.y = jump_velocity

func _on_state_exit():
	super()
	jump_timer=null
	

func _check_next_state():
	if my_player.is_on_floor():
		state_machine._change_state(landed_state)
	else:
		state_machine._change_state(fall_state)
