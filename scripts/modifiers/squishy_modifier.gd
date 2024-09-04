extends Node

@export var min_animation_duration: float = 1.0
@export var squish_factor: float = 0.1  # Increased for more prominent squish
@export var attenuation: float = 5  # Reduced for slower decay
@export var speed_divider: float = 10  # Decreased for more pronounced effect
@export var number_of_jiggles = 4

var parent_rigidbody
var original_scale: Vector3
var is_jelly_active: bool = false
var animation_time
var velocity
var impact_speed
var scale_factor
var animation_duration
var buffer
var buffer1
var buffer2

func _ready():
	parent_rigidbody = get_parent()
	original_scale = parent_rigidbody.scale
	if typeof(parent_rigidbody) == typeof(CharacterBody2D):
		parent_rigidbody.connect("landed", Callable(self, "_activate_jelly_effect"))
	else:
		parent_rigidbody.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node3D):
	print("is_jelly_active")
	if body.is_in_group("Ground"):
		_activate_jelly_effect()

func _activate_jelly_effect():
	if not is_jelly_active:
		is_jelly_active = true
		animation_time = 0.0
		scale_factor = squish_factor * (clamp((impact_speed * impact_speed), 0, speed_divider*100)  / speed_divider)
		animation_duration = min_animation_duration + scale_factor

func _physics_process(delta: float):
	if is_jelly_active:
		var animation_percent = animation_time / animation_duration
		var squish_amount = clamp(scale_factor, 0, 0.5) * sin(animation_percent * PI * 2 * number_of_jiggles) * exp(-attenuation * animation_percent)
		var xyz_scale = Vector3(1.0 + squish_amount, 1.0 - squish_amount, 1.0 + squish_amount)

		parent_rigidbody.scale = original_scale * xyz_scale

		animation_time += delta

		if animation_time >= animation_duration:
			is_jelly_active = false
			parent_rigidbody.scale = original_scale
	else:
		if typeof(parent_rigidbody) == typeof(CharacterBody2D):
			buffer_speed()
			velocity = parent_rigidbody.velocity
		else:
			buffer_speed()
			velocity = parent_rigidbody.linear_velocity
		if typeof(buffer2) != TYPE_NIL:
			impact_speed = abs(buffer2.y)
			
func buffer_speed():
	buffer2 = buffer
	buffer1 = buffer
	buffer = velocity
