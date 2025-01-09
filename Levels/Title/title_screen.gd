extends CanvasLayer

var default_spawn_pos = Vector2.ZERO
var entrance_spawn_pos = Vector2.ZERO

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var exit_button: Button = $VBoxContainer/ExitButton




func _on_start_button_pressed() -> void:
	SceneManager.load_new_scene("res://Levels/Tutorial/tutorial.tscn")



func _on_exit_button_pressed() -> void:
	get_tree().quit()
