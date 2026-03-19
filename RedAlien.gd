extends KinematicBody
var scene = preload("res://Scenes/RedProjectile.tscn")
var my_random_number3 = 0
var velocity1 = Vector3()
var Time = 0
var jumpTime = 0
var random_jump_interval = 4
var Target
var speed = 400
var Gravity = 0.98
var Move = Vector3(0,0,0)
var Health = 100
var Animation_State = 0
var StartJump = false
var HasJumped = false
onready var HealthBar = $HealthBar/Viewport/HealthBar2D
onready var Check_Ground = get_node("GroundCollider")
	#$HealthBar3D.update(Health, 100)
#func _ready():
	#HealthBar.value = Health
	
func _physics_process(_delta):
	if self.get_global_transform().origin.y < 0:
		Die()
	Time += _delta
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randf_range(-5.0, 5.0)
	var my_random_number2 = rng.randf_range(-5.0, 5.0)
	if HasJumped == true and Check_Ground.is_colliding(): 
		Animation_State = 1
		HasJumped = false
		$Timer.start()
		$JumpShit.stop()
	if Animation_State == 2 and Check_Ground.is_colliding():
		$RedAlien/AnimationPlayer.play("Armature|jumping")
		Move.y += 30
		if abs(self.get_global_transform().origin.z) < 100 and abs(self.get_global_transform().origin.x) < 100:
			var my_random_numberx = rng.randf_range(-0.5, 0.5)
			var my_random_numberz = rng.randf_range(-0.5, 0.5)
			Move.x += my_random_numberx
			Move.z += my_random_numberz
		$JumpShit.start()
	elif Animation_State == 0:
		$Timer.stop()
		$WalkAgainBitch.stop()
		$RedAlien/AnimationPlayer.play("Armature|Walking")
	elif Animation_State == 1:
		$RedAlien/AnimationPlayer.play("Armature|landing.001")
		#$Timer.start()
		#$Timer.stop()
	if jumpTime > random_jump_interval:
		Animation_State = 2
		random_jump_interval = rng.randf_range(3.0, 5.0)
		jumpTime = 0
	if Check_Ground.is_colliding() and HasJumped == false:
		jumpTime += _delta
		if Animation_State == 1:
			if StartJump == false:
				StartJump = true
				$WalkAgainBitch.start()
			#Animation_State = 0
	if Time > 0.3:
		my_random_number3 = rng.randf_range(-180.0, 180.0)
			#look_at(Target.global_transform.origin, Vector3.UP)
			#self.rotate_object_local(Vector3(my_random_number3 * _delta * 10,1,my_random_number3 * _delta * 10), 3.14)
		velocity1 = Vector3(my_random_number, 0 , my_random_number2)
		velocity1 = velocity1.linear_interpolate(velocity1, 1 * _delta)
		my_random_number = 0
		my_random_number2 = 0
		Time = 0
	

		#$alien/AnimationPlayer.stop()
	if Target:
		#Animation_State = 0
		look_at(Target.global_transform.origin, Vector3.UP)
		self.rotate_object_local(Vector3(0,1,0), 3.14/2)
		#print(Target)
		if $ProjectileCooldown.time_left <= 0:
			$ProjectileCooldown.start() 
	else: 
		self.rotate_y(deg2rad(my_random_number3 * _delta))
		$ProjectileCooldown.stop() 
	
		#projectile.get_global_transform().origin.x = -50
	Move.y -= Gravity
	var _velocity = move_and_slide(Move, Vector3(0, 1, 0))
# warning-ignore:unused_variable
	var veloctiy1 = move_and_slide(velocity1, Vector3.UP)
func TakeDamage(var Damage):
	Target = get_parent().get_node("Player")
	Health -= Damage
	#print(Health)
	HealthBar.value = Health
	if Health <= 0:
		Die()
func Die():
	get_parent().KillCounter = get_parent().KillCounter + 1
	get_parent().get_node("Player/Head/Camera/EnemyCounter/EnemyCounterLabel").text = str(get_parent().KillCounter) + "/" + "5" + " Enemies Killed"
	Health = 100
	HealthBar.value = Health
	visible = false
	queue_free()
func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		Target = body


func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		Target = null
func reparent(node):
  node.get_parent().remove_child(node) # error here  
  get_parent().add_child(node) 
# warning-ignore:unused_variable
  var pos = node.get("Transform/translation")
  pos = $ProjectileSpawnPoint.get("Transform/translation")
func _on_ProjectileCooldown_timeout():
	#var scene = load("res://Scenes/Projectile.tscn")
	var projectile = scene.instance()
	$ProjectileSpawnPoint.add_child(projectile)
	projectile.set_global_transform($ProjectileSpawnPoint.get_global_transform())
	#proj = projectile
	#call_deferred("reparent",projectile)
	#$ReparentTIme.start()
	#projectile.get_parent().remove_child(projectile) # error here  
	#get_parent().add_child(projectile) 





func _on_JumpShit_timeout():
	HasJumped = true


func _on_Timer_timeout():
	HasJumped = false
	$Timer.stop()
	#Animation_State = 0


func _on_WalkAgainBitch_timeout():
	Animation_State = 0
	StartJump = false
	#$WalkAgainBitch.stop()
