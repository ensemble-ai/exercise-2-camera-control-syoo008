class_name FourWaySpeedup
extends CameraControllerBase

# Export all the vars for FourWaySpeedupPushCamera
@export var push_ratio:float = 0.75
@export var pushbox_top_left:Vector2 = Vector2(-7.5, -7.5)
@export var pushbox_bottom_right:Vector2 = Vector2(7.5, 7.5)
@export var speedup_zone_top_left:Vector2 = Vector2(-4, -4)
@export var speedup_zone_bottom_right:Vector2 = Vector2(4, 4)


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
	
	# If vessel is moving, check if vessel is outside speedbox and is going in correct direction
	if not(target.velocity.is_zero_approx()):
		#left
		var in_left_zone = (tpos.x - target.WIDTH / 2.0) - (cpos.x + speedup_zone_top_left[0])
		if in_left_zone < 0 and target.velocity.x < 0:
			global_position.x -= push_ratio
		#right
		var in_right_zone = (tpos.x + target.WIDTH / 2.0) - (cpos.x + speedup_zone_bottom_right[0])
		if in_right_zone > 0 and target.velocity.x > 0:
			global_position.x += push_ratio
		#top
		var in_top_zone = (tpos.z - target.HEIGHT / 2.0) - (cpos.z + speedup_zone_top_left[1])
		if in_top_zone < 0 and target.velocity.z < 0:
			global_position.z -= push_ratio
		#bottom
		var in_bottom_zone= (tpos.z + target.HEIGHT / 2.0) - (cpos.z + speedup_zone_bottom_right[1])
		if in_bottom_zone > 0 and target.velocity.z > 0:
			global_position.z += push_ratio
	
	# Boundary checks for the push box; has vessel push push box
	#left
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x + pushbox_top_left[0])
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
	#right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + pushbox_bottom_right[0])
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
	#top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z + pushbox_top_left[1])
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
	#bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + pushbox_bottom_right[1])
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	# Draw 2 squares, push box and speedup box
	var push_left:float = pushbox_top_left[0]
	var push_right:float = pushbox_bottom_right[0]
	var push_top:float = pushbox_top_left[1]
	var push_bottom:float = pushbox_bottom_right[1]
	
	var speed_left:float = speedup_zone_top_left[0]
	var speed_right:float = speedup_zone_bottom_right[0]
	var speed_top:float = speedup_zone_top_left[1]
	var speed_bottom:float = speedup_zone_bottom_right[1]
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(push_right, 0, push_top))
	immediate_mesh.surface_add_vertex(Vector3(push_right, 0, push_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(speed_right, 0, speed_top))
	immediate_mesh.surface_add_vertex(Vector3(speed_right, 0, speed_bottom))
	
	
	immediate_mesh.surface_add_vertex(Vector3(push_right, 0, push_bottom))
	immediate_mesh.surface_add_vertex(Vector3(push_left, 0, push_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(speed_right, 0, speed_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speed_left, 0, speed_bottom))
	
	
	immediate_mesh.surface_add_vertex(Vector3(push_left, 0, push_bottom))
	immediate_mesh.surface_add_vertex(Vector3(push_left, 0, push_top))
	
	immediate_mesh.surface_add_vertex(Vector3(speed_left, 0, speed_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speed_left, 0, speed_top))
	
	
	immediate_mesh.surface_add_vertex(Vector3(push_left, 0, push_top))
	immediate_mesh.surface_add_vertex(Vector3(push_right, 0, push_top))
	
	immediate_mesh.surface_add_vertex(Vector3(speed_left, 0, speed_top))
	immediate_mesh.surface_add_vertex(Vector3(speed_right, 0, speed_top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
