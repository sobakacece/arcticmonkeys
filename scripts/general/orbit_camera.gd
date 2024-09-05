extends SpringArm3D

@export var rotate_speed : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalRefs.camera_menu = $OrbitCamera
	#$OrbitCamera.make_current()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#rotation.x += rotate_speed * delta
	rotation.y += rotate_speed * delta
	#rotation.x += rotate_speed * delta
	#rotation.y += rotate_speed * delta
	#if rotation.x < -PI/2:
		#rotation.x = -PI/2
	#else:
		#rotation.x = PI/2
		#
	#self.set_identity()
	#self.translate_object_local(Vector3(0,0,distance))
	#anchor.transform.basis = Basis(Quaternion.from_euler(rotation))
