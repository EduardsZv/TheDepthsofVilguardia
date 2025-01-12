extends Node

signal scene_load_started
signal scene_loaded

signal new_cycle_started

enum SCENES {MARKET, MAIN_LEVEL, TUTORIAL}

var prev_scene: int

# If a new game has been started (if is on title or tutorial screen)
var game_started: bool = false 


func load_new_scene(level_path: String, door_name: String = "") -> bool:
	
	
	var prev_scene_name = get_tree().current_scene.name
	
		
	get_tree().paused = true # Pauses the game
	
	await TransitionAnimation.fade_out() # Starts scene change animation
	
	scene_load_started.emit() # Emits signal that says that scene load has started
	
	
	get_tree().change_scene_to_file(level_path) # Changes the active scene
	
	get_tree().paused = false # Unpauses the game
	
	await get_tree().process_frame # Waits till the scene process has finishhed
	
	scene_loaded.emit() # Emits signal that the scene has been changed
	
	# Player position set
	if get_tree().current_scene.name == "Title Screen": # No player_pos set needed
		game_started = false
		await TransitionAnimation.fade_in() # Plays the scene change animation
	
	if get_tree().current_scene.name == "Tutorial": # No player_pos set needed
		game_started = false
		await TransitionAnimation.fade_in()
	
	# If player enters the village for the first time, sets player pos 
	# to spawn. If player has come from the cave, sets it at the entrance
	if get_tree().current_scene.name == "Vilguardia": 
		if !game_started:
			game_started = true # The game has started
			# Adds the player character to the game
			PlayerManager.add_player_instance()
			

		if door_name == "cave_entrance": # Player finishes cave level
			new_cycle_started.emit()
			PlayerManager.set_player_pos( 
				get_tree().current_scene.entrance_spawn_pos
			)
		elif prev_scene_name == "Tutorial": # Player starts the game
			PlayerManager.set_player_pos( 
				get_tree().current_scene.default_spawn_pos
			)

	
	# Sets position at the entrance door
	if get_tree().current_scene.name == "Main Level":
		if !game_started:
			game_started = true
			PlayerManager.add_player_instance()
			PlayerManager.set_player_pos(
			get_tree().current_scene.default_spawn_pos
		)
		else:
			PlayerManager.set_player_pos(
			get_tree().current_scene.entrance_spawn_pos
		)
	
	
	
	
	await TransitionAnimation.fade_in()
	return true
