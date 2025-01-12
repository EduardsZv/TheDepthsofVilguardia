extends CanvasLayer

@onready var points_label: Label = $PointsLabel


func _ready() -> void:
	hide_death_screen()
	PlayerManager.died.connect(show_death_screen)

func _process(_delta: float) -> void:
	update_points()


func show_death_screen() -> void:
	visible = true


func hide_death_screen() -> void:
	visible = false




func _on_main_title_button_pressed() -> void:
	hide_death_screen()
	await SceneManager.load_new_scene("res://Levels/Title/title_screen.tscn")
	PlayerManager.remove_player_instance()

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func update_points() -> void:
	points_label.text = "YOUR POINTS: " + str(PlayerManager.points)
