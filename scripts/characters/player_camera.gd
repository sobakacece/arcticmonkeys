extends SpringArm3D
@export_category("Camera Rotation")
@export var rotation_weight = 0.1;
@export var rotation_speed_mod : float = 1
@export var camera_range_y_axis : Vector2 = Vector2(-90, 90)
var target_camera_rotation: Vector3
var smooth_rotation: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		#rotate_y(deg_to_rad(event.relative.x))
		#target_rotation.x = clamp(target_rotation.x, deg_to_rad(-80), deg_to_rad(50))
		target_camera_rotation.y -= event.relative.x * GlobalRefs.mouse_sensitivity * rotation_speed_mod
		#target_rotation.y = wrapf(target_rotation.y, 0, 360)
		target_camera_rotation.x -= event.relative.y * GlobalRefs.mouse_sensitivity * rotation_speed_mod
		#target_camera_rotation.x = clamp(target_camera_rotation.x, deg_to_rad(camera_range_y_axis.x), deg_to_rad(camera_range_y_axis.y))
		#print(target_rotation.x);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var right_stick_x = Input.get_action_strength("gamepad_look_right") - Input.get_action_strength("gamepad_look_left")
	var right_stick_y = Input.get_action_strength("gamepad_look_down") - Input.get_action_strength("gamepad_look_up")
	target_camera_rotation.y -= right_stick_x * GlobalRefs.gamepad_sensitivity * rotation_speed_mod * delta
	target_camera_rotation.x -= right_stick_y * GlobalRefs.gamepad_sensitivity * rotation_speed_mod * delta
	target_camera_rotation.x = clamp(target_camera_rotation.x, deg_to_rad(camera_range_y_axis.x), deg_to_rad(camera_range_y_axis.y))


	smooth_rotation = smooth_rotation.lerp(target_camera_rotation, delta * rotation_weight)
	smooth_rotation.x = clamp(smooth_rotation.x, deg_to_rad(-60), deg_to_rad(60))
	rotation = smooth_rotation
	position = lerp(position, get_parent().position, delta * 25)
