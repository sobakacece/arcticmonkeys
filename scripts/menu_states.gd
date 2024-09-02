extends Control
class_name MainMenu
enum States {Pause, Start, GameOver, Gameplay, Win}
@export var Pause_Button : Button
@export var Start_Button : Button
@export var Restart_Button : Button
var current_state : States = States.Start
var button_dic : Dictionary
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_dic = {States.Pause : $VBoxContainer/Pause_Button,
	States.Start : $VBoxContainer/Start_Button,
	States.GameOver : $VBoxContainer/RestartButton,
	States.Win : $VBoxContainer/RestartButton}
	#Start_Button.start_game.connect(func(): self.hide())
	GlobalRefs.main_menu_ref = self
	GlobalRefs._update_global_state(GlobalRefs.GlobalStates.MenuStart)

func change_state(next_state : States):
	match next_state:
		States.Gameplay:
			self.hide()
			get_tree().paused = false
			if (current_state == States.GameOver || current_state == States.Win):
				GlobalRefs.Restart()
		States.Start:
			get_tree().paused = false
			_update_visibility(next_state)
			$MenuLabel.text = "GATHER ALL PENGUINS UNTIL THEY ALL DIE FROM THE GLOBAL HEATING OR SOMETHING"
		States.GameOver:
			get_tree().paused = true
			_update_visibility(next_state)
			$MenuLabel.text = "LOL, LOL, YOU DIED"
		States.Pause:
			_update_visibility(next_state)
			Restart_Button.show()
			get_tree().paused = true
			$MenuLabel.text = "GAME PAUSED"
		States.Win:
			_update_visibility(next_state)
			get_tree().paused = true
			$MenuLabel.text = "GOOD JOB, ALL PENGUINS ARE SAVED"
	current_state = next_state

func _update_visibility(key : States):
	self.show()
	for button in button_dic:
		if button_dic[button]:
			button_dic[button].hide()
	
	button_dic[key].show()
