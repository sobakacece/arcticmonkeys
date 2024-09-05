extends PlayerState
class_name Landed
var land_timer : SceneTreeTimer
@export var landed_state_time : float
#@export var jump_velocity : float
@export var fall_state : PlayerState
@export var slide_state : PlayerState
func _on_state_added() -> void:
	super()
	land_timer = get_tree().create_timer(landed_state_time, false, true)
	land_timer.timeout.connect(func(): _check_next_state())

func _on_state_exit():
	super()
	land_timer=null
		
func _check_next_state():
	state_machine._change_state(slide_state)
