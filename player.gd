extends CharacterBody3D

@export_category("Movement")
@export var jump_velocity = 4.5
@export var speed = 5.0
@export var fall_acceleration = 75
@export var turn_speed : float = 1 
var target_velocity = Vector3.ZERO
var direction

@export_category("Camera Rotation")
@export var rotation_weight = 0.1;
@export var rotation_speed_mod : float = 1
var smooth_rotation: Vector3

#should be hidden later
@export_category("General")
@export var mouse_sensitivity = 0.01

#nodes
var spring_arm
var tween
var visuals

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spring_arm = find_child("SpringArm")
	visuals = find_child("Visuals")
	#tween = get_tree().create_tween()

func _input(event):
	if event is InputEventMouseMotion:
		#rotate_y(deg_to_rad(event.relative.x))
		#target_rotation.x = clamp(target_rotation.x, deg_to_rad(-80), deg_to_rad(50))
		target_rotation.y -= event.relative.x * mouse_sensitivity * rotation_speed_mod
		#target_rotation.y = wrapf(target_rotation.y, 0, 360)
		target_rotation.x -= event.relative.y * mouse_sensitivity * rotation_speed_mod
		target_rotation.x = clamp(target_rotation.x, deg_to_rad(-90), deg_to_rad(90))
		#print(target_rotation.x);

		
func _process(delta: float) -> void:
	smooth_rotation = smooth_rotation.lerp(target_rotation, delta * rotation_weight)
	spring_arm.rotation = smooth_rotation
	spring_arm.position = position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (spring_arm.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if velocity.length() > 0.2:
		rotate_visuals(delta)
		
		#visuals.rotation.y = lerpf(spring_arm.rotation.y, atan2(-velocity.x, -velocity.z), turn_speed * delta)
	move_and_slide()

func rotate_visuals(delta : float):
	var current_rot = visuals.rotation_degrees
	var current_quat = Quaternion(Basis.from_euler(visuals.rotation))

	var target_rotation = Vector3(current_rot.x, atan2(-velocity.x, -velocity.z), current_rot.z)
	var target_quat = Quaternion(Basis.from_euler(target_rotation))

	# Slerp between current and target Quaternions
	var smooth_rot_quat = current_quat.slerp(target_quat, turn_speed * delta)

	# Convert back to Euler for visuals.rotation
	visuals.rotation = smooth_rot_quat.get_euler()
