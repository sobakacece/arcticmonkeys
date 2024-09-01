extends Node3D

var spawn_points : Array
var scene : PackedScene
@export var spawn_amount : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene = load("res://assets/3D/peng_on_map.tscn")
	spawn_points = get_children()
	spawn_amount = clamp(spawn_amount, 0, spawn_points.size())
	spawn_points.shuffle()
	for n in spawn_amount:
		_spawn(spawn_points[n])

func _spawn(node: Node3D) -> void:
	var spawn_position = node.position
	node.queue_free()
	var penguin = scene.instantiate()
	add_child(penguin)
	penguin.position = spawn_position
