extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text

var speed

const sensi = 0.5

var haveMove:=false

onready var camera = $InnerGimbal/Camera
onready var raycast = $InnerGimbal/Camera/RayCast
onready var innerGimbal = $InnerGimbal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		speed = event.relative
		haveMove = true

func draw_line(ig:ImmediateGeometry, v:Vector3, v1:Vector3, c:Color):
	ig.set_color(c)
	ig.add_vertex(v)
	ig.add_vertex(v1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(2) and haveMove:
		var sendel = sensi*delta
		
		rotate_y(-speed.x*sendel)
		
		$InnerGimbal.rotate_x(-speed.y*sendel)
		
		haveMove = false
		
	if Input.is_action_just_pressed("mouse_left"):
		var pos = camera.project_ray_origin(get_viewport().get_mouse_position())
		
		pos = camera.to_local(pos)
		
		raycast.translation = Vector3(pos.x, pos.y, 0)
		
		raycast.force_raycast_update()
		
		if raycast.is_colliding():
			var normal = raycast.get_collision_normal()
			
			var dir = $InnerGimbal/Camera.global_transform.basis.z
			
			var normal_x = Vector2(normal.x, normal.z)
			
			var normal_y = Vector2(normal_x.length(), normal.y)
			var normal_y3 = Vector3(normal_y.x, normal_y.y, 0)
			
			var dir_x = Vector2(dir.x, dir.z)
			var dir_x3 = Vector3(dir.x, 0, dir.z)
			
			var dir_y = Vector2(dir_x.length(), dir.y)
			var dir_y3 = Vector3(dir_y.x, dir_y.y, 0)
			
			var angle_y = dir_y.angle_to(normal_y)
			
#			if abs(innerGimbal.rotation.x)+abs(angle_y) > PI:
#				angle_y = -angle_y
			
			var angle_x = dir_x.angle_to(normal_x)
			
			var normal_node = $"../normal"
			normal_node.clear()
			normal_node.begin(Mesh.PRIMITIVE_LINES)
			draw_line(normal_node, Vector3.ZERO, normal*2, Color.red)
			draw_line(normal_node, Vector3.ZERO, dir*2, Color.blue)
			draw_line(normal_node, Vector3.ZERO, dir_x3*2, Color.cyan)
			draw_line(normal_node, Vector3.ZERO, dir_y3*2, Color.yellow)
			draw_line(normal_node, Vector3.ZERO, normal_y3*2, Color.green)
			normal_node.end()
			
			printt(dir, normal, innerGimbal.rotation_degrees, rad2deg(angle_y), abs(innerGimbal.rotation.x)+abs(angle_y))
			
#			rotate_y(-angle_x)

			if innerGimbal.rotation.x >= -PI/2 and innerGimbal.rotation.x <= PI/2:
				angle_y = -angle_y
#
			print(rad2deg(angle_y))
				
			innerGimbal.rotate_x(angle_y)
		
		pass
#	pass
