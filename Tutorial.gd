extends Control



var Count = 0
func _ready():
	$JoyStickPopUp.show()
func _input(_event):
			if Input.is_action_just_pressed("Move") and Count == 0:
				$JoyStickPopUp.hide()
				$ShootPopup.show()
				Count = Count + 1
			elif Input.is_action_just_pressed("Fire") and Count == 1: 
				$ShootPopup.hide()
				$SwitchWeaponPopup.show()
				Count = Count + 1
			elif Input.is_action_just_pressed("Switch") and Count == 2:
				$SwitchWeaponPopup.hide()
				$JumpPopup.show()
				Count = Count + 1
			elif Input.is_action_just_pressed("ui_up") and Count == 3:
				$JumpPopup.hide()
				$ReloadPopup.show()
				Count = Count + 1
			elif Input.is_action_just_pressed("Reload") and Count == 4:
				$ReloadPopup.hide()
				$AimPopup.show()
				Count = Count + 1
			elif Input.is_action_just_pressed("ZoomIn") and Count == 5:
				$AimPopup.hide()
				$AimPopup2.show()
				#$DirectionsHowTOPlay.visible = true
				Count = Count + 1
			elif Count == 6:
				#$AimPopup2.hide()
				$DirectionsHowTOPlay.visible = true
				Count = Count + 1
			elif Count == 7 and Input.is_action_just_pressed("ZoomIn"):
				$DirectionsHowTOPlay.visible = false
				$AimPopup2.hide()

