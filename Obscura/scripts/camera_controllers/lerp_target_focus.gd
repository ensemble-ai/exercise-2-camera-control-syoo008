class_name LerpTargetFocus
extends CameraControllerBase

#Export new variables for lerp smoothing target lock camera
@export var lead_speed:float = 25
@export var catchup_speed:float = 40
@export var catchup_delay_duration:float = 0.5
@export var leash_distance:float = 7.5

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
	
	#If the vessel is moving, check direction of velocity
	if !target.velocity.is_zero_approx():
		#Based off velocity direction, lerp to point further in that direction ahead of vessel
		if target.velocity.x > 0:
			global_position.x = lerp(global_position.x, target.global_position.x + leash_distance, lead_speed/100)
		if target.velocity.x < 0:
			global_position.x = lerp(global_position.x, target.global_position.x - leash_distance, lead_speed/100)
		if target.velocity.z < 0:
			global_position.z = lerp(global_position.z, target.global_position.z - leash_distance, lead_speed/100)
		if target.velocity.z > 0:
			global_position.z = lerp(global_position.z, target.global_position.z + leash_distance, lead_speed/100)
	#if the vessel is not moving, and the camera is not ontop of the vessel, 
	#lerp with catchup_speed after waiting the catchup_delay_duration
	elif target.velocity.is_zero_approx():
		if tpos != cpos:
			await get_tree().create_timer(catchup_delay_duration).timeout
			global_position = global_position.lerp(target.global_position, catchup_speed/100)

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
