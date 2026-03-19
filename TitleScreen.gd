extends Control
onready var ad = $AdMob

var scene_path_to_load

func _ready():
	ad.load_banner()
	ad.show_banner()
	#for button in $Menu2/Center/Buttons.get_children():
	#	button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
#func _on_Button_pressed(scene_to_load):
	#if scene_to_load != "res://NewGameScene.tscn":
	#	ad.hide_banner()
	#scene_path_to_load = scene_to_load
	#$FadeIn.show()
	#$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
	var val = get_tree().change_scene(scene_path_to_load)
	print(val)


func _on_AdMob_banner_failed_to_load(_error_code):
	#$Label2.text = "Failed to load"
	$Label2.visible = true


func _on_AdMob_banner_loaded():
	$Label2.visible = true


func _on_QuitButton_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_NewGameButton2_pressed():
	scene_path_to_load = "res://NewGameScene.tscn"
	$FadeIn.show()
	$FadeIn.fade_in()
	pass # Replace with function body.


func _on_ContinueButton2_pressed():
	scene_path_to_load = "res://Scenes/MainScene.tscn"
	$FadeIn.show()
	$FadeIn.fade_in()
	pass # Replace with function body.


func _on_Options2_pressed():
	scene_path_to_load = "res://Scenes/OptionsMenu.tscn"
	$FadeIn.show()
	$FadeIn.fade_in()
	pass # Replace with function body.


func _on_CreditsButton_pressed():
	scene_path_to_load = "res://Scenes/CreditsScene.tscn"
	$FadeIn.show()
	$FadeIn.fade_in()
	pass # Replace with function body.
