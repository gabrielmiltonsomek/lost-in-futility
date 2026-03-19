extends KinematicBody


var counter = 1
var save_path = 'my_level'

var isFiringLaser = false
#Bubblegun stuff
var spread = 10 
onready var ShotGunPelletContainer = $Head/Camera/ShotGunBlastContainer
export var FinishedCocking = true
var RotateCount = 0
#pistol Stuff
var TotalPistolAmmo = 150
var PistolAmmo = 7
export var DoneReloadingPistol = false 
export var DecreasePistol = false
var isZoomingPistol = false
export var ReloadingPistol = false

export var KnifeSwingFinished = false
var WeaponHold = 0
var PauseMenuActive = false
var Winner1 = false 
var Dead = false
export var speed = 10
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 30
export var mouse_sensitivity = 0.3
var isZooming = false
var isShooting = false
export var DoneReloading = false 
export var Decrease = false
export var Ammo = 30
var TotalAmmo = 150
export var Shoot = false
export var Reloading = false
#onready var Amin = $CameraParent/Camera/machinegun2/AnimationPlayer
var Health = 100
onready var HealthBar = $Head/Camera/Control/TextureProgress
onready var head = $Head
onready var camera = $Head/Camera
onready var MoveButton = $Head/Camera/MarginContainer2/VBoxContainer/Control3/Health/TouchScreenButton
var velocity = Vector3()
var camera_x_rotation = 0
#onready var scene = preload("res://Tutorial.tscn")
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#if get_tree().get_current_scene().get_name() == "Level1":
		#var projectile = scene.instance()
		#$Head/Camera.add_child(projectile)
	counter = _load(counter, save_path)
	if get_tree().get_current_scene().get_name() == "Level1" or get_tree().get_current_scene().get_name() == "Level2":
		$Head/Camera/shield2.visible = false
		$Head/Camera/shield2/Area/CollisionShape.disabled = true
		$Head/Camera/Control/ShieldHealth.visible = false
		
	if get_tree().get_current_scene().get_name() == "Level4":
		gravity = 0.1625
	elif get_tree().get_current_scene().get_name() == "Level5":
		gravity = 0.98
		jump_power = 1000
		speed = 100
	else: gravity = 0.98
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func FireShotGun():
	if FinishedCocking:
		FinishedCocking = false
		$ShotGunTimer.start()
		$Bubbles.play()
		$Head/Camera/bubblegun/Particles.emitting = true 
		$Head/Camera/bubblegun/Particles2.emitting = true 
		$Head/Camera/bubblegun/Particles3.emitting = true 
		$Head/Camera/bubblegun/Particles4.emitting = true 
		$Head/Camera/bubblegun/Particles5.emitting = true 
		$Head/Camera/bubblegun/Particles6.emitting = true
		$Head/Camera/bubblegun/Particles7.emitting = true
		$Head/Camera/bubblegun/Particles8.emitting = true   
		#for r1 in $Head/Camera/bubblegun.get_children():
		#	r1.emitting = true
		for r in ShotGunPelletContainer.get_children():
			r.cast_to.x = rand_range(-spread, spread)
			r.cast_to.y = rand_range(-spread, spread)
			if r.is_colliding():
				var Enemy = r.get_collider()
				if Enemy.is_in_group("Enemies"):
					get_parent().get_node(Enemy.name).TakeDamage(5)
				if Enemy.is_in_group("alien"):
					if !$AlienHitSound.playing:
						$AlienHitSound.play()
					get_parent().get_node(Enemy.name).TakeDamage(5)
				if Enemy.is_in_group("GreenAlien"):
					if !$AlienHitSound.playing:
						$AlienHitSound.play()
					get_parent().get_node(Enemy.name).TakeDamage(5)
				if Enemy.is_in_group("RedAlien"):
					if !$AlienHitSound.playing:
						$AlienHitSound.play()
					get_parent().get_node(Enemy.name).TakeDamage(5)
				if Enemy.is_in_group("FinalBoss"):
				#	if !$AlienHitSound.playing:
				#		$AlienHitSound.play()
					get_parent().get_node(Enemy.name).TakeDamage(100)
func _input(event):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
		
		if event is InputEventMouseButton:
			#if event.button_index == BUTTON_LEFT and event.pressed:
				# print("Left button was clicked at ", event.position)
			if event.button_index == BUTTON_WHEEL_UP and event.pressed:
				 SwitchWeapon2()
			if event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
				 SwitchWeapons()
		if event is InputEventMouseMotion:
				
				camera.rotate_x(deg2rad(event.relative.y * mouse_sensitivity * -1))
				head.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))

				var camera_rot = camera.rotation_degrees
				camera_rot.x = clamp(camera_rot.x, -90, 90)
				camera.rotation_degrees = camera_rot
		if event is InputEventScreenDrag:
				if event.index == MoveButton.ongoing_drag:
					return
		#	if event.index == 1:
				camera.rotate_x(deg2rad(event.relative.y * mouse_sensitivity * -1))
				head.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))

				var camera_rot = camera.rotation_degrees
				camera_rot.x = clamp(camera_rot.x, -90, 90)
				camera.rotation_degrees = camera_rot

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func ZoomIn():
	camera.fov = 40
	speed = 5
	$Head/Camera/machinegun/ZoomInAnimation.play("ZoomIn")
func ZoomOut():
	camera.fov = 70
	speed = 10
	$Head/Camera/machinegun/ZoomInAnimation2.play("ZoomOut")
func ZoomInPistol():
	camera.fov = 50
	speed = 8
	$Head/Camera/Pistol/ZoomInPistol.play("ZoomInPis")
func ZoomOutPistol():
	camera.fov = 70
	speed = 10
	$Head/Camera/Pistol/ZoomOutPistol.play("ZoomOutPis")
func SwitchWeapons():
	$Head/Camera/MarginContainer/VBoxContainer/CenterContainer/AmmoPopup.hide()
	if !isZooming and !isZoomingPistol:
		if WeaponHold < 2: 
			WeaponHold = WeaponHold + 1
		else: 
			WeaponHold = 0
func SwitchWeapon2():
	$Head/Camera/MarginContainer/VBoxContainer/CenterContainer/AmmoPopup.hide()
	if !isZooming and !isZoomingPistol:
		if WeaponHold > 0: 
			WeaponHold = WeaponHold - 1
		else: 
			WeaponHold = 2
func _physics_process(delta):
	if self.get_global_transform().origin.y < 0:
		Die()

	var head_basis = head.get_global_transform().basis
	
	var direction = Vector3()

	if MoveButton.get_value().y < 0 or Input.is_key_pressed(KEY_W):
		direction -= head_basis.z
	elif MoveButton.get_value().y > 0 or Input.is_key_pressed(KEY_S):
		direction += head_basis.z
	if MoveButton.get_value().x < 0 or Input.is_key_pressed(KEY_A):
		direction -= head_basis.x
	elif MoveButton.get_value().x > 0 or Input.is_key_pressed(KEY_D):
		direction += head_basis.x
	
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	if Input.is_action_just_pressed("Switch"):
		SwitchWeapons()
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y += jump_power
		$AnimationPlayer.play("JumpSounds")
	velocity = move_and_slide(velocity, Vector3.UP)
	if get_tree().get_current_scene().get_name() == "Level4":
			$Head/Camera/MarginContainer/VBoxContainer/Control/Control5.visible = false 
			$Head/Camera/MarginContainer/VBoxContainer/Control/Control6.visible = false 
			$Head/Camera/MarginContainer/VBoxContainer/Control/Control7.visible = false 
			$Head/Camera/LaserG.visible = true
			$Head/Camera/bubblegun.visible = false
			if isFiringLaser == true:
				if !$LaserSound.playing:
					$LaserSound.play()
			else:
				$LaserSound.stop()
			$Head/Camera/machinegun.visible = false
			#if WeaponHold == 0:
			if Input.is_action_just_pressed("Fire"):
				isFiringLaser = true

				$Head/Camera/LaserG/CSGCylinder.visible = true
				$Head/Camera/LaserGunCollider.enabled = true
					
			elif Input.is_action_just_released("Fire"):
				isFiringLaser = false
				$Head/Camera/LaserG/CSGCylinder.visible = false
				$Head/Camera/LaserGunCollider.enabled = false
			if $Head/Camera/LaserGunCollider.is_colliding():
					var Enemy = $Head/Camera/LaserGunCollider.get_collider()
					if Enemy.is_in_group("Enemies"):
						get_parent().get_node(Enemy.name).TakeDamage(1)
					if Enemy.is_in_group("alien"):
						if !$AlienHitSound.playing:
							$AlienHitSound.play()
						get_parent().get_node(Enemy.name).TakeDamage(1)
					if Enemy.is_in_group("GreenAlien"):
						if !$AlienHitSound.playing:
							$AlienHitSound.play()
						get_parent().get_node(Enemy.name).TakeDamage(1)
					if Enemy.is_in_group("RedAlien"):
						if !$AlienHitSound.playing:
							$AlienHitSound.play()
						get_parent().get_node(Enemy.name).TakeDamage(1)
	elif get_tree().get_current_scene().get_name() == "Level5":
		$Head/Camera/MarginContainer/VBoxContainer/Control/Control5.visible = false 
		$Head/Camera/MarginContainer/VBoxContainer/Control/Control6.visible = false 
		$Head/Camera/MarginContainer/VBoxContainer/Control/Control7.visible = false 
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var my_random_number = rng.randf_range(-1.5, 0)
		var my_random_number2 = rng.randf_range(0, 1.5)
		if RotateCount == 0:
			camera.rotate_x(deg2rad(my_random_number * -1))
			head.rotate_x(deg2rad(my_random_number * -1))
			RotateCount = 1
		else:
			camera.rotate_x(deg2rad(my_random_number2 * -1))
			head.rotate_x(deg2rad(my_random_number2 * -1))
			RotateCount = 0
		$Head/Camera/bubblegun.visible = true
		if Input.is_action_just_pressed("Fire"):
			FireShotGun()
	elif get_tree().get_current_scene().get_name() != "Level4" and get_tree().get_current_scene().get_name() != "Level5":
		$Head/Camera/LaserG.visible = false
		$Head/Camera/bubblegun.visible = false
		if WeaponHold == 0:
			if TotalAmmo <= 0 and Ammo == 0:
				$Head/Camera/MarginContainer/VBoxContainer/CenterContainer/AmmoPopup.popup()
			if Input.is_action_just_pressed("ZoomIn"):
				if isZooming:
					ZoomOut()
					isZooming = false
				else:
					ZoomIn()
					isZooming = true
			if $Head/Camera/machinegun.visible == false:
				$Head/Camera/machinegun.visible = true
				$Head/Camera/MarginContainer/VBoxContainer/Control/Control6.visible = true
				$Head/Camera/Knife.visible = false
				$Head/Camera/Pistol.visible = false
			if DoneReloading:
					if isZooming:
						ZoomIn()
					DoneReloading = false 
					$Head/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
			if Input.is_action_just_pressed("Reload"):
				if TotalAmmo > 0:
					$Head/Camera/machinegun/AnimationPlayer2.play("PlayerReload")
					Reloading = true
			if Reloading:
				if !Decrease:
					Decrease = true
					if TotalAmmo >= 30: 
						var Difference = 30 - Ammo
						TotalAmmo -= Difference
						Ammo = 30
						$Head/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
					else: 
						var Difference = TotalAmmo
						Ammo = Difference
						TotalAmmo = 0
						$Head/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
			if Input.is_action_just_pressed("Fire"):
				isShooting = true
				#MachineGunFlash.visible = true
			elif Input.is_action_just_released("Fire"):
				isShooting = false
			if isShooting:
				if Shoot == false:
					if Ammo > 0 and !Reloading:
					#	Ammo = Ammo - 1
						$Head/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
						Shoot = true
							#if $CameraParent/Camera/machinegun2/HitScan.is_colliding():
								
					else:
						if TotalAmmo > 0:
							$Head/Camera/machinegun/AnimationPlayer3.stop()
							Reloading = true 
							$Head/Camera/machinegun/AnimationPlayer2.play("PlayerReload")
							$Head/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
							
						#reload
				if !$Head/Camera/machinegun/AnimationPlayer3.is_playing():
					if Ammo > 0 and !Reloading:
						#print(Ammo)
						Ammo = Ammo - 1
						CheckCollision()
						$Head/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
						$Head/Camera/machinegun/AnimationPlayer3.play("FireGun")
					else:
						if TotalAmmo > 0:
							Reloading = true 
							$Head/Camera/machinegun/AnimationPlayer2.play("PlayerReload")
							$Head/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
						
			else:
				$Head/Camera/machinegun/AnimationPlayer3.stop()
				$Head/Camera/machinegun/MuzzleFlash.visible = false
		elif WeaponHold == 1: 
			if TotalPistolAmmo <= 0 and PistolAmmo == 0:
								$Head/Camera/MarginContainer/VBoxContainer/CenterContainer/AmmoPopup.popup()
			if WeaponHold == 1:
				if Input.is_action_just_pressed("ZoomIn"):
					if isZoomingPistol:
						ZoomOutPistol()
						isZoomingPistol = false
					else:
						ZoomInPistol()
						isZoomingPistol = true
			Shoot = false
			isShooting = false
			if $Head/Camera/Pistol.visible == false:
				$Head/Camera/machinegun.visible = false
				$Head/Camera/MarginContainer/VBoxContainer/Control/Control6.visible = true
				$Head/Camera/Knife.visible = false
				$Head/Camera/Pistol.visible = true
				$Head/Camera/AmmoControl/bullet2/Label.text = str(PistolAmmo) + "\n" + "Total " + str(TotalPistolAmmo)
			if Input.is_action_just_pressed("Reload"):
				if TotalPistolAmmo > 0:
					ZoomOut()
					isZoomingPistol = false
					$Head/Camera/Pistol/PistolAnimation.play("PistolReload")
					ReloadingPistol = true
			if ReloadingPistol:
				if !DecreasePistol:
					DecreasePistol = true
					if TotalPistolAmmo >= 7: 
						var Difference = 7 - PistolAmmo
						TotalPistolAmmo -= Difference
						PistolAmmo = 7
						$Head/Camera/AmmoControl/bullet2/Label.text = str(PistolAmmo) + "\n" + "Total " + str(TotalPistolAmmo)
					else: 
						var Difference = TotalPistolAmmo
						PistolAmmo = Difference
						TotalPistolAmmo = 0
						$Head/Camera/AmmoControl/bullet2/Label.text = str(PistolAmmo) + "\n" + "Total " + str(TotalPistolAmmo)
			if Input.is_action_just_pressed("Fire") and $Head/Camera/Pistol/MuzzleFlashPistol.visible == false:
					if PistolAmmo > 0 and !ReloadingPistol:
						$Head/Camera/Pistol/FirePistol.play("FirePistol")
						PistolAmmo = PistolAmmo - 1
						$Head/Camera/AmmoControl/bullet2/Label.text = str(PistolAmmo) + "\n" + "Total " + str(TotalPistolAmmo)
						CheckCollisionPistol()
					else:
						if TotalPistolAmmo > 0:
							$Head/Camera/Pistol/FirePistol.stop()
							ReloadingPistol = true 
							ZoomOut()
							isZoomingPistol = false
							$Head/Camera/Pistol/PistolAnimation.play("PistolReload")
							ReloadingPistol = true
							$Head/Camera/AmmoControl/bullet2/Label.text = str(PistolAmmo) + "\n" + "Total " + str(TotalPistolAmmo)
					#	$Head/Camera/machinegun/AnimationPlayer3.stop()
					#	$Head/Camera/machinegun/MuzzleFlash.visible = false
		elif WeaponHold == 2: 
			Shoot = false
			isShooting = false
			
			if $Head/Camera/Knife.visible == false:
				$Head/Camera/MarginContainer/VBoxContainer/Control/Control6.visible = false
				$Head/Camera/machinegun.visible = false
				$Head/Camera/Knife.visible = true
				$Head/Camera/Pistol.visible = false
			if Input.is_action_just_pressed("Fire"):
				$Head/Camera/Knife/KnifeAnimation.play("KnifeAnimation")
				CheckCollisionKnife()
func CheckCollision():
	if $Head/Camera/RayCast.is_colliding():
		var Enemy = $Head/Camera/RayCast.get_collider()
		if Enemy.is_in_group("Enemies"):
			get_parent().get_node(Enemy.name).TakeDamage(5)
		if Enemy.is_in_group("alien"):
			if !$AlienHitSound.playing:
				$AlienHitSound.play()
			get_parent().get_node(Enemy.name).TakeDamage(5)
		if Enemy.is_in_group("GreenAlien"):
			if !$AlienHitSound.playing:
				$AlienHitSound.play()
			get_parent().get_node(Enemy.name).TakeDamage(5)
		if Enemy.is_in_group("RedAlien"):
			if !$AlienHitSound.playing:
				$AlienHitSound.play()
			get_parent().get_node(Enemy.name).TakeDamage(5)
func CheckCollisionPistol():
	if $Head/Camera/PistolCast.is_colliding():
		var Enemy = $Head/Camera/PistolCast.get_collider()
		if Enemy.is_in_group("Enemies"):
			get_parent().get_node(Enemy.name).TakeDamage(5)
			$ZombieDamage.play()
			if !$ZombieDamage.playing:
				$ZombieDamage.play()
		if Enemy.is_in_group("alien"):
			if !$AlienHitSound.playing:
				$AlienHitSound.play()
			get_parent().get_node(Enemy.name).TakeDamage(5)
		if Enemy.is_in_group("GreenAlien"):
			if !$AlienHitSound.playing:
				$AlienHitSound.play()
			get_parent().get_node(Enemy.name).TakeDamage(5)
		if Enemy.is_in_group("RedAlien"):
			if !$AlienHitSound.playing:
				$AlienHitSound.play()
			get_parent().get_node(Enemy.name).TakeDamage(5)
func CheckCollisionKnife():
	if $Head/Camera/KnifeCast.is_colliding():
		var Enemy = $Head/Camera/KnifeCast.get_collider()
		if Enemy.is_in_group("Enemies") and !KnifeSwingFinished:
			get_parent().get_node(Enemy.name).TakeDamage(20)
			if !$ZombieDamage.playing:
				$ZombieDamage.play()
		if Enemy.is_in_group("alien"):
			if !$AlienHitSound.playing:
				$AlienHitSound.play()
			get_parent().get_node(Enemy.name).TakeDamage(20)
		if Enemy.is_in_group("GreenAlien"):
			if !$AlienHitSound.playing:
				$AlienHitSound.play()
			get_parent().get_node(Enemy.name).TakeDamage(20)
		if Enemy.is_in_group("RedAlien"):
			if !$AlienHitSound.playing:
				$AlienHitSound.play()
			get_parent().get_node(Enemy.name).TakeDamage(20)
func PlayShieldBreakSound():
	$BreakingSound.play()
func TakeDamage(var Damage):
	$PlayerDamage.play()
	Health -= Damage
	HealthBar.value = Health
	if Health <= 0:
		Die()
func Die():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_parent().get_node("DeathCam").current = true
	Health = 100
	HealthBar.value = Health
	Dead = true
	$Head/Camera/MarginContainer.visible = false
	$Head/Camera/MarginContainer2.visible = false
	$Head/Camera/CenterContainer.visible = false
	$Head/Camera/Control.visible = false
	$Head/Camera/AmmoControl.visible = false 
	if !Winner1:
		$Head/Camera/Death/DeathWindow.visible = true 
		$Head/Camera/Death/DeathMessage.visible = true
	$CollisionShape.disabled = true
	self.visible = false
			#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func Winner():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Winner1 = true
	get_parent().get_node("DeathCam").current = true
	Health = 100
	HealthBar.value = Health
	$Head/Camera/MarginContainer.visible = false
	$Head/Camera/MarginContainer2.visible = false
	$Head/Camera/CenterContainer.visible = false
	$Head/Camera/Control.visible = false
	$Head/Camera/AmmoControl.visible = false 
	#print("Scene: ")
	#print(get_tree().get_current_scene().get_name())
	if get_tree().get_current_scene().get_name() == "Level1":
		$Head/Camera/WinScreen/NetLevelButtonContainer.visible = true
		$Head/Camera/WinScreen/WinMessage.visible = true 
		$Head/Camera/WinScreen/WinMenu.visible = true
		#var p = counter
		if counter < 2:
			counter = 2
			_save(counter, save_path)
	elif get_tree().get_current_scene().get_name() == "Level2":
		if counter < 3:
			counter = 3
			_save(counter, save_path)
		$Head/Camera/WinScreen/NetLevelButtonContainer.visible = true
		$Head/Camera/WinScreen/WinMessage.text = "Level 2 Complete!"
		$Head/Camera/WinScreen/WinMessage.visible = true 
		$Head/Camera/WinScreen/WinMenu.visible = true
	elif get_tree().get_current_scene().get_name() == "Level3":
		if counter < 4:
			counter = 4
			_save(counter, save_path)
		$Head/Camera/WinScreen/NetLevelButtonContainer.visible = true
		$Head/Camera/WinScreen/WinMessage.text = "Level 3 Complete!"
		$Head/Camera/WinScreen/WinMessage.visible = true 
		$Head/Camera/WinScreen/WinMenu.visible = true
	elif get_tree().get_current_scene().get_name() == "Level4":
		if counter < 5:
			counter = 5
			_save(counter, save_path)
		$Head/Camera/WinScreen/NetLevelButtonContainer.visible = true
		$Head/Camera/WinScreen/WinMessage.text = "Level 4 Complete!"
		$Head/Camera/WinScreen/WinMessage.visible = true 
		$Head/Camera/WinScreen/WinMenu.visible = true
	elif get_tree().get_current_scene().get_name() == "Level5":
		if counter < 5:
			counter = 5
			_save(counter, save_path)
		#$Head/Camera/WinScreen/NetLevelButtonContainer.visible = true
		$Head/Camera/WinScreen/WinMessage.text = "You are officially Lost in Futility!"
		$Head/Camera/WinScreen/WinMessage.visible = true 
		$Head/Camera/WinScreen/WinMenu.visible = true
	$CollisionShape.disabled = true
	self.visible = false
func _on_Button_pressed():
	var val = get_tree().reload_current_scene()
	print("Scene")
	print(" ")
	print(val) 
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_Button2_pressed():
	var val = get_tree().change_scene("res://NewGameScene.tscn")
	print(val)

func _on_TextureButton_pressed():
	if PauseMenuActive == false:
		$Head/Camera/CenterContainer2.visible = true
		#set_process_input(true)
		$Head/Camera/Unpausesss.visible = true 
		$Head/Camera/PauseStuff.visible = false
		#$Head/Camera/PauseStuff/TextureButton.rect_position.x = -300
		#$Head/Camera/Unpausesss/TouchScreenButton.position.x = -127
		PauseMenuActive = true
		get_tree().paused = true

func _on_UnPause_pressed():
	$Head/Camera/CenterContainer2.visible = false
	PauseMenuActive = false
	get_tree().paused = false
	$Head/Camera/Unpausesss.visible = false 
	$Head/Camera/PauseStuff.visible = true
	#$Head/Camera/CenterContainer2/PausePopup.hide()
	$Head/Camera/CenterContainer2.visible = false

func _on_BackToMain_pressed():
#	get_parent().get_node("AdMob").hide_banner()
	PauseMenuActive = false
	get_tree().paused = false
	var val = get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	print(val)


func _on_NextLevelButton_pressed():
	#get_parent().get_node("AdMob").hide_banner()
	if get_tree().get_current_scene().get_name() == "Level1":
		var val = get_tree().change_scene("res://Scenes/Level2.tscn")
		print(val)
	elif get_tree().get_current_scene().get_name() == "Level2":
		var val = get_tree().change_scene("res://Scenes/Level3.tscn")
		print(val)
	elif get_tree().get_current_scene().get_name() == "Level3":
		var val = get_tree().change_scene("res://Scenes/Level4.tscn")
		print(val)
	elif get_tree().get_current_scene().get_name() == "Level4":
		var val = get_tree().change_scene("res://Scenes/Level5.tscn")
		print(val)
	elif get_tree().get_current_scene().get_name() == "Level5":
		var val = get_tree().change_scene("res://Scenes/TitleScreen.tscn")
		print(val)

func _load(counter1, path):
	var file = File.new()
	if not file.file_exists('user://' + path):
		return 1
	file.open('user://' + path, file.READ)
	counter1 = file.get_var(counter1)
	file.close()
	return counter1
func _save(counter1, path):
	var file = File.new()
	file.open('user://' + path, file.WRITE)
	file.store_var(counter1)
	file.close()


func _on_ShotGunTimer_timeout():
		$Head/Camera/bubblegun/ShotGunSound.play()
		$Head/Camera/bubblegun/ShotGunAmin.play("ShotGunCocking")
		$Head/Camera/bubblegun/AnimationPlayer.play("Armature.001|Armature.001Action")
	#	$Head/Camera/bubblegun/AnimationPlayer2.play("Plane.001|Armature.001Action")
		$ShotGunTimer.stop()
		#$Bubbles.stop()
		$Head/Camera/bubblegun/Particles.emitting = false
		$Head/Camera/bubblegun/Particles2.emitting = false 
		$Head/Camera/bubblegun/Particles3.emitting = false 
		$Head/Camera/bubblegun/Particles4.emitting = false 
		$Head/Camera/bubblegun/Particles5.emitting = false 
		$Head/Camera/bubblegun/Particles6.emitting = false
		$Head/Camera/bubblegun/Particles7.emitting = false
		$Head/Camera/bubblegun/Particles8.emitting = false 
	#Play an animation
