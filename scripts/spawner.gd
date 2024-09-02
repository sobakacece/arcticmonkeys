extends Node3D
class_name Spawner
var spawn_points : Array
var scene : PackedScene
@export var spawn_amount : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalRefs.spawner=self
	scene = load("res://assets/3D/peng_on_map.tscn")
	spawn_points = get_children()
	spawn_amount = clamp(spawn_amount, 0, spawn_points.size())
	spawn_points.shuffle()
	for n in spawn_amount:
		_spawn(spawn_points[n])

func _spawn(node: Node3D) -> void:
	var spawn_position = node.position
	#node.queue_free()
	var penguin = scene.instantiate()
	add_child(penguin)
	penguin.position = spawn_position


func _restart() -> void:
	for child in get_children():
		if child.is_in_group("collectable"):
			remove_child(child)
			#print("KILLED PENGUIN")
	spawn_points.shuffle()
	for n in spawn_amount:
		_spawn(spawn_points[n])
