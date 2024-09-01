extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.set_value_no_signal(GlobalRefs.mouse_sensitivity)
	self.value_changed.connect(func(value: float): GlobalRefs.update_sense(value))
