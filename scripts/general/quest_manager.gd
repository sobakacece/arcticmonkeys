extends Node

class_name QuestManager
signal peng_picked_up
@export_category("Quest Properties")
@export var quest_time : float = 60
@export var win_condition = 5

@export_category("Meshes")
@export var Player_Bag1: Node3D
@export var Player_Bag2: Node3D
@export var Player_Bag3: Node3D

@export var Player_Peng1: Node3D
@export var Player_Peng2: Node3D
@export var Player_Peng3: Node3D
@export var Player_Peng4: Node3D
@export var Player_Peng5: Node3D

var picked_up_sound : AudioStreamPlayer3D

var peng_counter = 0
var State : GlobalRefs.GlobalStates
var quest_timer : Timer
var timer_label
var penguin_label
#var spawner : Spawner
func _ready() -> void:
	GlobalRefs._add_quest_ref(self)
	#spawner = get_tree().root.find_child("spawner") 
	peng_picked_up.connect(func_peng_picked_up)
	timer_label = $Control/Time_Left
	penguin_label = $Control/Penguin_Counter
	update_players_peng_count()
	picked_up_sound = $AudioList/Picked_UP

func func_peng_picked_up():
	picked_up_sound.pitch_scale = 1 + float(peng_counter)/12
	picked_up_sound.play()
	peng_counter += 1
	update_players_peng_count()

func update_players_peng_count():
	penguin_label.text = str(peng_counter) + "/" + str(win_condition)
	match peng_counter:
		0: 
			Player_Peng1.hide()
			Player_Peng2.hide()
			Player_Peng3.hide()
			Player_Peng4.hide()
			Player_Peng5.hide()
			Player_Bag2.hide()
			Player_Bag3.hide()
			Player_Bag1.show()
		
		1:
			Player_Bag1.hide()
			Player_Bag2.show()
			Player_Peng1.show()
		2:
			Player_Bag2.hide()
			Player_Bag3.show()
			Player_Peng2.show()
		3:
			Player_Peng3.show()
		4:
			Player_Peng4.show()
		5:
			Player_Peng5.show()
	
	if GlobalRefs.quest_manager.peng_counter == GlobalRefs.quest_manager.win_condition:
		GlobalRefs._update_global_state(GlobalRefs.GlobalStates.MenuWin)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if quest_timer:
		_update_timer_label()
		#print("ahuel_pes")

func _update_timer_label():
	var total = quest_timer.time_left
	var minutes = int(total)/60
	total-= minutes*60
	total = 999
	var seconds = int(total)
	timer_label.text = str("%0*d" % [2, minutes]) + ":" + str("%0*d" % [2, seconds])
	#print(str("%0*d" % [2, minutes]) + ":" + str("%0*d" % [2, seconds]))

func check_quest_timer():
	if !quest_timer:
		quest_timer = Timer.new()
		add_child(quest_timer)
		#quest_timer.timeout.connect(func() : GlobalRefs._update_global_state(GlobalRefs.GlobalStates.MenuGameOver))
	quest_timer.wait_time = quest_time
	quest_timer.start()
		
func _update_quest_state(state : GlobalRefs.GlobalStates):
	match state:
		GlobalRefs.GlobalStates.Gameplay:
			check_quest_timer()

func _reset_state():
	peng_counter = 0
	update_players_peng_count()
	check_quest_timer()
	GlobalRefs.spawner._restart()
