extends Node

signal global_state_changed(state : GlobalStates)

static var player_ref : Player
static var quest_manager : QuestManager
static var mouse_sensitivity : float = 0.01
static var gamepad_sensitivity = 5
static var start_position : Vector3 
static var main_menu_ref : MainMenu
static var camera_menu : Camera3D
static var spawner : Spawner
enum GlobalStates {Gameplay, MenuPause, MenuGameOver, MenuStart, MenuWin}
# Called when the node enters the scene tree for the first time.\\
func _add_player_ref(player : Player) -> void:
	player_ref = player
	
static func _add_quest_ref(quest : QuestManager) -> void:
	quest_manager = quest

func _ready() -> void:
	get_tree().root.find_child("start")

func update_sense(value: float):
	mouse_sensitivity = value

func _update_global_state(state: GlobalStates):
	global_state_changed.emit(state)
	match state:
		GlobalStates.Gameplay:
			player_ref.state_machine._initial_state_check()
			player_ref.camera.make_current()
	#		main_menu_ref.change_state(main_menu_ref.States.Gameplay)
			quest_manager._update_quest_state(state)
		GlobalStates.MenuPause:
			player_ref.state_machine._change_state_by_name("Uncontrollable")
		#	main_menu_ref.change_state(main_menu_ref.States.Pause)
		
		GlobalStates.MenuGameOver:
			player_ref.state_machine._change_state_by_name("Uncontrollable")
	#		main_menu_ref.change_state(main_menu_ref.States.GameOver)
		
		GlobalStates.MenuStart:
			#player_ref.focused = false
			player_ref.state_machine._change_state_by_name("Uncontrollable")
			camera_menu.make_current()
	#		main_menu_ref.change_state(main_menu_ref.States.Start)
		
		GlobalStates.MenuWin:
			player_ref.state_machine._change_state_by_name("Uncontrollable")
			camera_menu.make_current()
		#	main_menu_ref.change_state(main_menu_ref.States.Win)

func Restart():
	quest_manager._reset_state()
	player_ref.position = start_position
	player_ref.velocity = Vector3.ZERO
