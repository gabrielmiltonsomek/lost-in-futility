extends Control



func _on_Button_pressed():
	var val = get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	print(val)
