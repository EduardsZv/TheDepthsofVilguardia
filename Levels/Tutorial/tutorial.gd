extends CanvasLayer


@onready var start_button: Button = $VBoxContainer/StartButton



func _on_start_button_pressed() -> void:
	SceneManager.load_new_scene("res://Levels/Vilguardia/vilguardia.tscn")
