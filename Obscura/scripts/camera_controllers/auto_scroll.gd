class_name AutoScroll
extends CameraControllerBase

#new export variables for autoscroll
@export var top_left:Vector2 = Vector2(-5, -5)
@export var bottom_right:Vector2 = Vector2(5, 5)
@export var autoscroll_speed:Vector3 = Vector3(0.1, 0, 0)

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
	var tWidth = target.WIDTH / 2.0
	
	#Set camera and vessel to move autoscroll_speed units/time together
	global_position = global_position + autoscroll_speed
	target.global_position = target.global_position + autoscroll_speed
	
	#boundary checks
	#If the target tries to move outside the box, put the target back in the box (considering offset from width)
	#left
	if (tpos.x - tWidth) - (cpos.x + top_left[0]) < 0:
		#print(tpos.x, " ", cpos.x + top_left[0])
		target.global_position.x = cpos.x + top_left[0] + tWidth
		#print("Moving Right: ", tpos.x)
	#right
	if (tpos.x + tWidth) - (cpos.x + bottom_right[0]) > 0:
		target.global_position.x = cpos.x + bottom_right[0] - tWidth
	#top
	if (tpos.z - tWidth) - (cpos.z + top_left[1]) < 0:
		target.global_position.z = cpos.z + top_left[1] + tWidth
	#bottom
	if (tpos.z + tWidth) - (cpos.z + bottom_right[1]) > 0:
		target.global_position.z = cpos.z + bottom_right[1] - tWidth
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	#set each variable to its respective value
	var left:float = top_left[0]
	var right:float = bottom_right[0]
	var top:float = top_left[1]
	var bottom:float = bottom_right[1]
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
