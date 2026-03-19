extends Control

func _on_BackButton_pressed():
	var val = get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	print(val)



func _on_Volume_value_changed(value):
	#AudioServer.set_bus_volume_db(2, value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
