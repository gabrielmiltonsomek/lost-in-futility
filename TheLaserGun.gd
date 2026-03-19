extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var move = Vector3(0,0,90)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _physics_process(_delta):
	move = move.normalized()
	get_node("CSGCylinder").rotate(move, 90)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
