extends PlayerState

@export var landed_state : PlayerState

func _state_process(delta) -> void:
	if my_player.is_on_floor():
		state_machine._change_state(landed_state)

	my_player.snap_to_ground()
	my_player.velocity += my_player.get_gravity() * delta * my_player.mass
