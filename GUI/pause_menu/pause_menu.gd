extends CanvasLayer

var is_paused: bool = false

@onready var resume_button: Button = $VBoxContainer/ResumeButton
@onready var main_title_button: Button = $VBoxContainer/MainTitleButton
@onready var exit_button: Button = $VBoxContainer/ExitButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_pause_menu()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if !is_paused:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()


func show_pause_menu() -> void:
	get_tree().paused = true # Pauses the game
	visible = true
	is_paused = true


func hide_pause_menu() -> void:
	get_tree().paused = false # Unpauses the game
	visible = false
	is_paused = false

func resume_clicked() -> void:
	hide_pause_menu()

func _on_resume_button_pressed() -> void:
	resume_clicked()

func _on_main_title_button_pressed() -> void:
	pass

func _on_exit_button_pressed() -> void:
	get_tree().quit()
