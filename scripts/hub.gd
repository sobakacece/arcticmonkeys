extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalRefs.start_position = self.global_position
	GlobalRefs.player_ref.position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	
	if body.is_in_group("PlayerGroup") && GlobalRefs.quest_manager.peng_counter == GlobalRefs.quest_manager.win_condition:
		GlobalRefs._update_global_state(GlobalRefs.GlobalStates.MenuWin)
		
