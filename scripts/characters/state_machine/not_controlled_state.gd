extends PlayerState
class_name Uncontrollable
# Called when the node enters the scene tree for the first time.
func _on_state_added() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_state_exit() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
