extends Area3D
class_name penguin_object
#var quest : Node
var quest_manager: Node
var parent: Node3D
var raycast : RayCast3D
#
func _ready() -> void:
	quest_manager = GlobalRefs.quest_manager

func _on_body_entered(body: Node3D) -> void:
	
	if body.is_in_group("PlayerGroup"):
		quest_manager.func_peng_picked_up()
		get_parent().queue_free()
