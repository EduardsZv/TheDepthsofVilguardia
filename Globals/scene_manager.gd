extends Node

signal scene_load_started
signal scene_loaded

var target_transition: String
var position: Vector2

var prev_scene: String = ""
var curr_scene: String = ""

func load_new_scene(
		level_path: String, 
		_target_transition: String, 
		_position: Vector2
		) -> void:
	
	
	get_tree().paused = true
	target_transition = _target_transition
	position = _position
	
	scene_load_started.emit()
	
	await TransitionAnimation.fade_out()
	
	get_tree().change_scene_to_file(level_path)
	
	get_tree().paused = false
	
	await get_tree().process_frame
	
	scene_loaded.emit()
	
	PlayerManager.set_player_pos(
		get_tree().current_scene.entrance_spawn_pos
	)
	
	await TransitionAnimation.fade_in()
