extends CharacterBody3D

class_name Player

@export_category("Movement")
@export var jump_velocity = 17
@export var fall_acceleration = 75
@export var jump_state_time = 0.2
@export var turn_speed : float = 1
@export var turn_curve : Curve

@export_category("Acceleration")
@export var acceleration_curve : Curve
@export var slowdown_curve : Curve
@export var acceleration_time : float = 0.2
@export var max_speed = 50

@export_category("Dash")
@export var dash_boost : float
@export var dash_acceleration: float
@export var dash_boost_time: float
#@export var slowdown_time : float = 0.2
#var acceleration = 0.0
#var deacceleration = 0.0

#@export var slow_curve : float = 1
var target_velocity = Vector3.ZERO
var direction

@export_category("Camera Rotation")
@export var rotation_weight = 0.1;
@export var rotation_speed_mod : float = 1
@export var camera_range_y_axis : Vector2 = Vector2(-90, 90)
var target_camera_rotation: Vector3
var smooth_rotation: Vector3

#should be hidden later
@export_category("General")
@export var mouse_sensitivity = 0.01
@export var snapping_distance = 2
@export var mass = 3

var slope_const = 2
#nodes
var spring_arm
var visuals
var dash_timer : SceneTreeTimer
var jump_timer : SceneTreeTimer
var is_jumping : bool = false

#dynamic_values
var current_acceleration_boost
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
		target_camera_rotation.x = clamp(target_camera_rotation.x, deg_to_rad(camera_range_y_axis.x), deg_to_rad(camera_range_y_axis.y))
		#print(target_rotation.x);
		

		
func _process(delta: float) -> void:
	smooth_rotation = smooth_rotation.lerp(target_camera_rotation, delta * rotation_weight)
	spring_arm.rotation = smooth_rotation
	spring_arm.position = position
	#camera_range_y_axis.y=clamp(camera_range_y_axis.y + Vector3.FORWARD.angle_to(get_normal()), -90, -10)
	#print(spring_arm.spring_length)
	#if ($SpringArm/Camera3D.position.distance_to(Vector3.ZERO) < 2):
		#print($SpringArm/Camera3D.position)

func slope_process(delta : float):
	return Vector3(get_normal().normalized().x, 0, get_normal().normalized().z) * delta * slope_const
	#return Vector3(get_normal().normalized()) * delta * slope_const
	
func get_normal():
	if $RayCast3D.is_colliding():
		return $RayCast3D.get_collision_normal()
	else:
		return Vector3.UP


func _physics_process(delta: float) -> void:
	# Add the gravity.
	
		#print("NOT ON FLOOR")
	#else:
		#var normal = get_normal().normalized()
		##var temp_rotation = Quaternion(get_normal(), Vector3.UP).normalized()
		#var gravity_vector = get_gravity().project(normal)
		#velocity += slope_process(delta) - gravity_vector  * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		is_jumping = true
		if !jump_timer:
			jump_timer = get_tree().create_timer(jump_state_time, false, true)
			jump_timer.timeout.connect(func(): jump_end_handle())
	
	update_velocity_input(delta)
	#print(is_jumping)
	if not is_on_floor():
		print($Slop_end_check.is_colliding())
		if ($RayCast3D.get_collision_point().distance_to(position) < snapping_distance && $Slop_end_check.is_colliding() && !is_jumping):
			position = $RayCast3D.get_collision_point()
			#is_jumping = false
			#print("SNAPPED")
		
		velocity += get_gravity() * delta * mass
	move_and_slide()
	#$SpringArm/Camera3D.position = clamp($SpringArm/Camera3D.position, Vector3(-1, -1, 4), Vector3(5,5,5))
	
	if velocity.length() > 0.2:
		rotate_visuals(delta)
		
	else:
		on_stop()
		#time_elapsed = 0.0	
		
func update_velocity_input(delta : float):
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (Basis(spring_arm.transform.basis.x, Vector3.UP, spring_arm.transform.basis.z).orthonormalized() * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction += get_normal()
	#print(direction)
	if direction:
		var target_velocity_x = direction.x * get_max_speed()
		var target_velocity_z = direction.z * get_max_speed()
		time_elapsed+=delta
		time_elapsed = clamp(time_elapsed, 0, acceleration_time)
		var normalized_time = remap(time_elapsed, 0, acceleration_time, 0, 1)
		#print(normalized_time)
		velocity.x = lerp(velocity.x, target_velocity_x, acceleration_curve.sample(normalized_time) * delta * get_acceleration_boost())
		velocity.z = lerp(velocity.z, target_velocity_z, acceleration_curve.sample(normalized_time) * delta * get_acceleration_boost())
	else:
		time_elapsed -= delta
		time_elapsed = clamp(time_elapsed, 0, acceleration_time)
		var normalized_time = remap(time_elapsed, 0, acceleration_time, 0, 1)
		velocity.x = lerp(velocity.x, 0.0, -slowdown_curve.sample(normalized_time) * delta) 
		velocity.z = lerp(velocity.z, 0.0, -slowdown_curve.sample(normalized_time) * delta)
		
func rotate_visuals(delta : float):
	var current_rot = visuals.rotation_degrees
	var current_quat = Quaternion(Basis.from_euler(visuals.rotation))

	var target_rotation = Vector3(current_rot.x, atan2(-velocity.x, -velocity.z), current_rot.z)
	var target_quat = Quaternion(Basis.from_euler(target_rotation))
#	print(camera_range_y_axis)
	# Slerp between current and target Quaternions
	var smooth_rot_quat = current_quat.slerp(target_quat, turn_speed * delta)
	# Convert back to Euler for visuals.rotation
	visuals.rotation = smooth_rot_quat.get_euler()
func on_stop():
	return
	#print("stopped")
func jump_end_handle():
	jump_timer = null
	is_jumping = false

func get_dash_boost() -> float:
	if Input.is_action_just_pressed("dash") && !dash_timer:
			dash_timer = get_tree().create_timer(dash_boost_time, false, true)
			dash_timer.timeout.connect(func(): dash_timer = null)
	
	var dash_mod : float
	if dash_timer:
		dash_mod =  dash_timer.time_left / dash_boost_time
	else:
		dash_mod = 0
	#print(dash_boost)
	return dash_boost * dash_mod

func get_max_speed() -> float:
	#print(dash_timer.get_paath())
	if Input.is_action_pressed("dash"):
		#print(get_dash_boost())
		return max_speed + get_dash_boost()
	else:
		return max_speed
		
func get_acceleration_boost() -> float:
	if Input.is_action_pressed("dash"):
		return dash_acceleration
	else: 
		return 1
