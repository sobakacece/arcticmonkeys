extends Control
class_name MainMenu
@onready var States = GlobalRefs.GlobalStates
@export var Pause_Button : Button
@export var Start_Button : Button
@export var Restart_Button : Button
#var current_state : States = States.Start
var button_dic : Dictionary
# Called when the node enters the scene tree for the first time.
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("full_screen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
func _input(event):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			GlobalRefs._update_global_state(GlobalRefs.GlobalStates.Gameplay)
		else:
			GlobalRefs._update_global_state(GlobalRefs.GlobalStates.MenuPause)

func _ready() -> void:
	await(1)
	button_dic = {States.MenuPause : $VBoxContainer/Pause_Button,
	States.MenuStart : $VBoxContainer/Start_Button,
	States.MenuGameOver : $VBoxContainer/RestartButton,
	GlobalRefs.GlobalStates.MenuWin : $VBoxContainer/RestartButton}
	
	GlobalRefs.main_menu_ref = self
	GlobalRefs.global_state_changed.connect(func(state : GlobalRefs.GlobalStates): on_global_state_change(state))
	GlobalRefs._update_global_state(States.MenuStart)

	#GlobalRefs._update_global_state(GlobalRefs.GlobalStates.MenuStart)

func on_global_state_change(state : GlobalRefs.GlobalStates):
	match state:
		States.Gameplay:
			self.hide()
			get_tree().paused = false
		States.MenuStart:
			get_tree().paused = false
			_update_visibility(state)
			$MenuLabel.text = "GATHER ALL PENGUINS UNTIL THEY ALL DIE FROM THE GLOBAL HEATING OR SOMETHING"
		States.MenuGameOver:
			get_tree().paused = true
			set_process_input(true)
			_update_visibility(state)
			$MenuLabel.text = "LOL, LOL, YOU DIED"
		States.MenuPause:
			_update_visibility(state)
			Restart_Button.show()
			get_tree().paused = true
			set_process_input(true)
			$MenuLabel.text = "GAME PAUSED"
		States.MenuWin:
			_update_visibility(state)
			get_tree().paused = true
			set_process_input(true)
			$MenuLabel.text = "GOOD JOB, ALL PENGUINS ARE SAVED"

func _update_visibility(key : GlobalRefs.GlobalStates):
	self.show()
	for button in button_dic:
		if button_dic[button]:
			button_dic[button].hide()
	
	button_dic[key].show()
