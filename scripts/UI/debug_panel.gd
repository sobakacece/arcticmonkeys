extends Control

@export var speed_label : Label
@export var velocity_label : Label
@export var state_label : Label
var format_string_speed = "Current Speed %f"
var format_string_velocity = "Current Speed %v"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#speed_label = find_child("Speed")
	#velocity_label = find_child("Velocity")
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalRefs.player_ref:
		speed_label.text = format_string_speed % [GlobalRefs.player_ref.velocity.length()]
		velocity_label.text = format_string_velocity % [GlobalRefs.player_ref.velocity]
		state_label.text = GlobalRefs.player_ref.state_machine.current_state.name
