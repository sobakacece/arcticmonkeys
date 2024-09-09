extends CharacterBody3D

class_name Player

@export_category("Movement")
@export var fall_acceleration = 75
@export var turn_speed : float = 1
#@export var turn_curve : Curve

@export_category("Acceleration")
@export var acceleration_curve : Curve
@export var slowdown_curve : Curve
@export var acceleration_time : float = 0.2
@export var max_speed = 50

@export_category("Dash")
@export var dash_boost : float
@export var dash_acceleration: float
@export var dash_boost_time: float


var target_velocity = Vector3.ZERO
var direction


@export_category("General")
@export var snapping_distance : float = 1 
@export var mass = 3

var slope_const = 2


#nodes
var spring_arm
var camera
var visuals
var raycast
var slope_check
var dash_timer : SceneTreeTimer
var state_machine : StateMachine
#dynamic_values
var current_acceleration_boost
var time_elapsed = 0.0

func _ready():
	spring_arm = find_child("SpringArm")
	visuals = find_child("Visuals")
	GlobalRefs._add_player_ref(self)
	camera = $SpringArm/Camera3D
	state_machine = $StateMachine
	raycast = $RayCast3D
	slope_check = $Slope_check
	state_machine.state_changed.connect(func(state: PlayerState): $Squishy_Modifier._on_state_changed(state))
	



func _physics_process(delta: float) -> void:
	buffer_speed()
	
	if state_machine.current_state is not Uncontrollable:
		update_velocity_input(delta)
		move_and_slide()
			
		if velocity.length() > 0.2:
			rotate_visuals(delta)

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
		
func rotate_visuals(delta: float):
	var current_rot = visuals.rotation
	var target_rotation = Vector3(current_rot.x, atan2(-velocity.x, -velocity.z), current_rot.z)
	
	var current_quat = Quaternion(Basis.from_euler(current_rot))
	var target_quat = Quaternion(Basis.from_euler(target_rotation))
	
	var smooth_rot_quat = current_quat.slerp(target_quat, turn_speed * delta)
	
	visuals.rotation = smooth_rot_quat.get_euler()

func check_snap_distance() -> bool:
	return $RayCast3D.get_collision_point().distance_to(position) < snapping_distance && $Slope_check.is_colliding()
		#position = $RayCast3D.get_collision_point()
		#var target_position = $RayCast3D.get_collision_point()
		#position = lerp(position, target_position, 0,5)
#PROPERTIES
func get_dash_boost() -> float:
	if Input.is_action_just_pressed("dash") && !dash_timer:
			dash_timer = get_tree().create_timer(dash_boost_time, false, true)
			dash_timer.timeout.connect(func(): dash_timer = null)
	
	var dash_mod : float
	if dash_timer:
		dash_mod =  dash_timer.time_left / dash_boost_time
	else:
		dash_mod = 0
	return dash_boost * dash_mod

func get_max_speed() -> float:
	if Input.is_action_pressed("dash") && is_on_floor():
		return max_speed + get_dash_boost()
	else:
		return max_speed
		
func get_acceleration_boost() -> float:
	if Input.is_action_pressed("dash"):
		return dash_acceleration
	else: 
		return 1

func get_normal():
	if $RayCast3D.is_colliding():
		return $RayCast3D.get_collision_normal()
	else:
		return Vector3.UP

var buffer = Vector3.ZERO
var buffer1 = Vector3.ZERO
var buffer2 = Vector3.ZERO

func buffer_speed():
	buffer2 = buffer1
	buffer1 = buffer
	buffer = self.velocity

func get_land_velocity():
	return abs(buffer1.y)
