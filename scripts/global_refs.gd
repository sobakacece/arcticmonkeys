extends Node

static var player_ref : Player
# Called when the node enters the scene tree for the first time.\\
static func _add_player_ref(player : Player) -> void:
	player_ref = player
	

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
