extends Button
class_name ButtonStart

@export var state : GlobalRefs.GlobalStates
var main_menu
signal on_pressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(func(): _start_game())
	GlobalRefs.main_menu_ref = main_menu

func _start_game():
	GlobalRefs._update_global_state(state)
	on_pressed.emit()
