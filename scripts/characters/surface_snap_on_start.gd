extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var raycast = $RayCast3D
	position = raycast.get_collision_point()
