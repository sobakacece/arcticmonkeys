extends Area3D

#var quest : Node
@export var quest_manager: Node
@export var parent: Node3D
#
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("PlayerGroup"):
		quest_manager.func_peng_picked_up()
		parent.queue_free()
