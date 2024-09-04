extends Node

signal on_state_changed

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
static func _add_player_ref(player : Player) -> void:
	player_ref = player
	#player.mouse_sensitivity = mouse_sensitivity
	
static func _add_quest_ref(quest : QuestManager) -> void:
	quest_manager = quest

func _ready() -> void:
	get_tree().root.find_child("start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func emit_state_change():
	on_state_changed.emit()

static func update_sense(value: float):
	mouse_sensitivity = value

static func _update_global_state(state: GlobalStates):
	match state:
		GlobalStates.Gameplay:
			player_ref.focused = true
			player_ref.camera.make_current()
			main_menu_ref.change_state(main_menu_ref.States.Gameplay)
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			quest_manager._update_quest_state(state)
		GlobalStates.MenuPause:
			player_ref.focused = false
			#player_ref.camera.make_current()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			main_menu_ref.change_state(main_menu_ref.States.Pause)
		GlobalStates.MenuGameOver:
			player_ref.focused = false
			#player_ref.camera.make_current()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			main_menu_ref.change_state(main_menu_ref.States.GameOver)
		GlobalStates.MenuStart:
			player_ref.focused = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			camera_menu.make_current()
			main_menu_ref.change_state(main_menu_ref.States.Start)
		GlobalStates.MenuWin:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			camera_menu.make_current()
			main_menu_ref.change_state(main_menu_ref.States.Win)
	#on_state_changed.emit
	#player_ref.focused = !on_menu
static func Restart():
	quest_manager._reset_state()
	player_ref.position = start_position
	player_ref.velocity = Vector3.ZERO
