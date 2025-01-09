extends CanvasLayer



func _ready() -> void:
	hide_death_screen()
	PlayerManager.died.connect(show_death_screen)




func show_death_screen() -> void:
	visible = true


func hide_death_screen() -> void:
	visible = false




func _on_main_title_button_pressed() -> void:
	hide_death_screen()
	await SceneManager.load_new_scene("res://Levels/Title/title_screen.tscn")
	PlayerManager.player.queue_free()
	PlayerManager.player = null
	PlayerManager.INVENTORY_DATA.clear_inventory()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
