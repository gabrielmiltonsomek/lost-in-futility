extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity
var N
func _ready():
	#self.position = get_parent().get_global_transform().origin
	velocity = get_parent().get_global_transform().basis.x
	#velocity = velocity.normalized()
	N = Vector3(90,0,0)
	N = N.normalized()
	$Timer.start()

func _physics_process(delta):
	rotate(N, 5)
	move_and_slide(velocity * 15, Vector3.UP)
	move_and_slide(Vector3(0, -0.98, 0), Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Timer_timeout():
	queue_free()
