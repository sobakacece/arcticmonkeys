extends CharacterBody3D

@export_category("Movement")
@export var jump_velocity = 4.5
@export var speed = 5.0
@export var fall_acceleration = 75
var target_velocity = Vector3.ZERO

@export_category("Rotation")
@export var rotation_weight = 0.1;
@export var rotation_speed_mod : float = 1
var target_rotation: Vector3
var smooth_rotation: Vector3

#should be hidden later
@export_category("General")
@export var mouse_sensitivity = 0.01

#nodes
var camera
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera = find_child("SpringArm")

func _input(event):
	if event is InputEventMouseMotion:
		#rotate_y(deg_to_rad(event.relative.x))
		#target_rotation.x = clamp(target_rotation.x, deg_to_rad(-80), deg_to_rad(50))
		target_rotation.y -= event.relative.x * mouse_sensitivity * rotation_speed_mod
		target_rotation.x -= event.relative.y * mouse_sensitivity * rotation_speed_mod
		target_rotation.x = clamp(target_rotation.x, deg_to_rad(-90), deg_to_rad(90))
		#print(target_rotation.x);
		
func _process(delta: float) -> void:
	smooth_rotation = smooth_rotation.lerp(target_rotation, delta * rotation_weight)
	camera.rotation = smooth_rotation

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
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
