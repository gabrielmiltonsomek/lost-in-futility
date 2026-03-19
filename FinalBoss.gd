extends KinematicBody
var my_random_number3 = 0
var velocity1 = Vector3()
var speed = 400
var Gravity = 0.98
var Move = Vector3(0,0,0)
var Health = 10000
var Animation_State = 1
var MoveCounter = 0
onready var HealthBar = $CenterContainer/Control/TextureProgress
var scene = preload("res://Scenes/LightningBolt.tscn")
var Location = Vector3(-180.576, 292, 188.438)
var Time = 0 
var Time2 = 0
var BossState = 0
	#$HealthBar3D.update(Health, 100)
func _physics_process(_delta):
	var distance2Hero = Location.distance_to(transform.origin)
	if BossState == 0:
		$ProjectileCooldown.stop()
		Time2 += _delta
		print(str(distance2Hero))
		var dir = Location - transform.origin
		dir = move_and_slide(dir)
		if distance2Hero < 1 or Time2 > 3:
			BossState = 1
			Time2 = 0
	else: 
		look_at(get_parent().get_node("Player").transform.origin, Vector3.UP)
		self.rotate_object_local(Vector3(0,1,0), 3.14/2*3.14 - 3.14/8)
		if $ProjectileCooldown.time_left <= 0:
			$ProjectileCooldown.start()
		Time += _delta
		if Time >= 3:
					if MoveCounter == 0:
						Location = Vector3(-145.275, 0, 0)
						MoveCounter = 1
						Time = 0
					elif MoveCounter == 1:
						Location = Vector3(-180.576, 0, 180.438)
						MoveCounter = 2
						Time = 0
					elif MoveCounter == 2: 
						Location = Vector3(0, -292, 0)
						MoveCounter = 0
						Time = 0
					BossState = 0
		
		#Location = Vector3(-145.275, -292, 0)
	if self.get_global_transform().origin.y < 0:
		Die()
	
	
	Move.y -= Gravity
	move_and_slide(Move)
	#var _velocity = move_and_slide(Move, Vector3(0, 1, 0))
	#rotate_y(5 * .1 * _delta)
# warning-ignore:unused_variable

func TakeDamage(var Damage):
	Health -= Damage
	#print(Health)
	$CenterContainer/Control/hEALTHS.text = str(Health)
	HealthBar.value = Health
	if Health <= 0:
		Die()
func Die():
	get_parent().KillCounter = get_parent().KillCounter + 500
	get_parent().get_node("Player/Head/Camera/EnemyCounter/EnemyCounterLabel").text = str(get_parent().KillCounter) + "/" + "5" + " Enemies Killed"
	Health = 100
	HealthBar.value = Health
	visible = false
	queue_free()

func _on_ProjectileCooldown_timeout():
	#var scene = load("res://Scenes/Projectile.tscn")
	var projectile = scene.instance()
	$ProjectileSpawnPoint.add_child(projectile)
	projectile.set_global_transform($ProjectileSpawnPoint.get_global_transform())
	var projectile2 = scene.instance()
	$ProjectileSpawnPoint.add_child(projectile2)
	projectile2.set_global_transform($ProjectileSpawnPoint2.get_global_transform())


