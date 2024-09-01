extends Button

@export var state : GlobalRefs.GlobalStates
signal on_pressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(func(): _start_game())

func _start_game():
	GlobalRefs._update_global_state(state)
	on_pressed.emit()
