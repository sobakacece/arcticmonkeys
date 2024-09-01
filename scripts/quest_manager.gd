extends Node

signal peng_picked_up

@export var Player_Bag1: Node3D
@export var Player_Bag2: Node3D
@export var Player_Bag3: Node3D

@export var Player_Peng1: Node3D
@export var Player_Peng2: Node3D
@export var Player_Peng3: Node3D
@export var Player_Peng4: Node3D
@export var Player_Peng5: Node3D

var peng_counter = 0

func _ready() -> void:
	peng_picked_up.connect(func_peng_picked_up)
	#func_peng_picked_up()

func func_peng_picked_up():
	peng_counter += 1
	update_players_peng_count()

func update_players_peng_count():
	match peng_counter:
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
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
