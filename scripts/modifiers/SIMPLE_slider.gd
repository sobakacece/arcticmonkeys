extends Node3D

# Called every physics frame.
func _physics_process(delta: float) -> void:
	# Ensure the parent exists and the RayCast3D has a collision
	if get_parent() and $RayCast3D.is_colliding():
		var n = $RayCast3D.get_collision_normal()
		var parent_transform = get_parent().global_transform
		var xform = align_with_y(parent_transform, n)
		get_parent().global_transform = parent_transform.interpolate_with(xform, 0.2)

func align_with_y(xform: Transform3D, new_y: Vector3) -> Transform3D:
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
