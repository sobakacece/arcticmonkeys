extends CharacterBody3D

class_name Player

@export_category("Movement")
@export var jump_velocity = 4.5
@export var fall_acceleration = 75
@export var turn_speed : float = 1
@export var turn_curve : Curve

@export_category("Acceleration")
@export var acceleration_curve : Curve
@export var slowdown_curve : Curve
@export var acceleration_time : float = 0.2
@export var max_speed = 50
@export var dash_boost : float
#@export var slowdown_time : float = 0.2
#var acceleration = 0.0
#var deacceleration = 0.0

#@export var slow_curve : float = 1
var target_velocity = Vector3.ZERO
var direction

@export_category("Camera Rotation")
@export var rotation_weight = 0.1;
@export var rotation_speed_mod : float = 1
var target_camera_rotation: Vector3
var smooth_rotation: Vector3

#should be hidden later
@export_category("General")
@export var mouse_sensitivity = 0.01

#nodes
var spring_arm
var visuals

var time_elapsed = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spring_arm = find_child("SpringArm")
	visuals = find_child("Visuals")
	GlobalRefs._add_player_ref(self)
	#tween = get_tree().create_tween()

func _input(event):
	if event is InputEventMouseMotion:
		#rotate_y(deg_to_rad(event.relative.x))
		#target_rotation.x = clamp(target_rotation.x, deg_to_rad(-80), deg_to_rad(50))
		target_camera_rotation.y -= event.relative.x * mouse_sensitivity * rotation_speed_mod
		#target_rotation.y = wrapf(target_rotation.y, 0, 360)
		target_camera_rotation.x -= event.relative.y * mouse_sensitivity * rotation_speed_mod
		target_camera_rotation.x = clamp(target_camera_rotation.x, deg_to_rad(-90), deg_to_rad(90))
		#print(target_rotation.x);
		

		
func _process(delta: float) -> void:
	smooth_rotation = smooth_rotation.lerp(target_camera_rotation, delta * rotation_weight)
	spring_arm.rotation = smooth_rotation
	spring_arm.position = position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (Basis(spring_arm.transform.basis.x, Vector3.UP, spring_arm.transform.basis.z).orthonormalized() * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var target_velocity_x = direction.x * calculate_max_speed()
		var target_velocity_z = direction.z * calculate_max_speed()
		time_elapsed+=delta
		time_elapsed = clamp(time_elapsed, 0, acceleration_time)
		var normalized_time = remap(time_elapsed, 0, acceleration_time, 0, 1)
		print(normalized_time)
		velocity.x = lerp(velocity.x, target_velocity_x, acceleration_curve.sample(normalized_time) * delta)
		velocity.z = lerp(velocity.z, target_velocity_z, acceleration_curve.sample(normalized_time) * delta)
	else:
		time_elapsed-=delta
		velocity.x = lerp(velocity.x, 0.0, -slowdown_curve.sample(0) * delta)
		velocity.z = lerp(velocity.z, 0.0, -slowdown_curve.sample(0) * delta)
	
	move_and_slide()
	
	if velocity.length() > 0.2:
		rotate_visuals(delta)
		
	else:
		on_stop()
		#time_elapsed = 0.0	

func rotate_visuals(delta : float):
	var current_rot = visuals.rotation_degrees
	var current_quat = Quaternion(Basis.from_euler(visuals.rotation))

	var target_rotation = Vector3(current_rot.x, atan2(-velocity.x, -velocity.z), current_rot.z)
	var target_quat = Quaternion(Basis.from_euler(target_rotation))

	# Slerp between current and target Quaternions
	var smooth_rot_quat = current_quat.slerp(target_quat, turn_speed * delta)

	# Convert back to Euler for visuals.rotation
	visuals.rotation = smooth_rot_quat.get_euler()
func on_stop():
	return
	#print("stopped")
	
func calculate_max_speed() -> float:
	var tmp_speed = 0.0
	if Input.is_action_pressed("dash"):
		return max_speed + dash_boost
	else: 
		return max_speed
		
