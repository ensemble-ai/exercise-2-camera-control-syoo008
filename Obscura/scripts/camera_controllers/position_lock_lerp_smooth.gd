class_name PositionLockLerpSmooth
extends CameraControllerBase

#Export new variables for position lock lerp smoothing camera
@export var follow_speed:float = 5
@export var catchup_speed:float = 50
@export var leash_distance:float = 5

func _ready() -> void:
	super()
	position = target.position
	
func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	#Get x and z distance to compare to leash
	var distanceX = abs(tpos.x - cpos.x)
	var distanceZ = abs(tpos.z - cpos.z)
	
	#If the vessel is moving, lerp with follow_speed
	if not(target.velocity.is_zero_approx()):
		global_position = global_position.lerp(target.global_position, follow_speed/100)
		#Re-utilize push-box logic for leash logic, can't get outside the box/leash
		if distanceX > leash_distance || distanceZ > leash_distance:
			#boundary checks
			#left
			var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - leash_distance)
			if diff_between_left_edges < 0:
				global_position.x += diff_between_left_edges
			#right
			var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + leash_distance)
			if diff_between_right_edges > 0:
				global_position.x += diff_between_right_edges
			#top
			var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - leash_distance)
			if diff_between_top_edges < 0:
				global_position.z += diff_between_top_edges
			#bottom
			var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + leash_distance)
			if diff_between_bottom_edges > 0:
				global_position.z += diff_between_bottom_edges
	#if the vessel is not moving, lerp with catchup_speed
	elif target.velocity.is_zero_approx():
		global_position = global_position.lerp(target.global_position, catchup_speed/100)
	
	#Failed attempt at pos_lock_lerp without lerp
	#if tpos != cpos:
		#if tpos.x > cpos.x:
			#global_position.x += follow_speed
		#elif tpos.x < cpos.x:
			#global_position.x += -follow_speed
			#
		#if tpos.y > cpos.y:
			#global_position.y += follow_speed
		#elif tpos.y < cpos.y:
			#global_position.y += -follow_speed
	#Left and Right
	#If the camera position (x) (global) doesn't equal the target position, make them equal
	#if cpos.x != tpos.x:
		#global_position.x = tpos.x
		
	#Up and Down
	#If the camera position (z) (global) doesn't equal the target position, make them equal
	#if cpos.z != tpos.z:
		#global_position.z = tpos.z

	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	#Vars to draw a cross of 10 units per line
	var left:float = -5
	var right:float = 5
	var top:float = -5
	var bottom:float = 5
	
	#Draw line from top to bottom, then draw line from right to left
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, 0))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
