extends Node

var slide_loop : AudioStreamPlayer3D
var music_loop : AudioStreamPlayer3D
var jump : AudioStreamPlayer3D
var land : AudioStreamPlayer3D
var state_machine
var player : CharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine = $"../StateMachine"
	slide_loop = $Slide_Loop
	music_loop = $Music_Loop
	land = $Land
	jump = $Jump
	state_machine.connect("state_changed", Callable(self, "on_state_changed"))
	player = $".."

func on_state_changed(new_state):
	var new_state_name = str(new_state).split(":")[0]  # Take the part before the colon

	if str(new_state_name) == "Jump":
		jump.play()
		slide_loop.stop()
	if str(new_state_name) == "Landed":
		update_land()
		land.play()
		slide_loop.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	slide_loop.volume_db = player.velocity.length() - 30
	slide_loop.pitch_scale = 0.9 + player.velocity.length()/50
	
	music_loop.volume_db = 12 + player.velocity.length()/50
	
func update_land():
	land.volume_db = (player.get_land_velocity()-2)*1.1
	land.pitch_scale = 1.1 - player.get_land_velocity()/50
