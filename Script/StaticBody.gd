extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Mesh = preload("res://Art/Guide.obj")

# Called when the node enters the scene tree for the first time.
func _ready():
	$MeshInstance.mesh = Mesh
	
	$CollisionShape.shape = Mesh.create_trimesh_shape()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
