@tool # Lets the script run in the editor
class_name SceneOpener extends Area2D


@export_file("*.tscn") var level


@export_range(1,12,1, "or_greater") var size: int = 2 :
	set( value ): 
		size = value
		_update_area()


@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint(): # If the script runs in the editor
		return
	
	body_entered.connect( _player_entered )
	body_exited.connect( _player_exited)


func _player_entered( _p: Node2D) -> void:
	if !PlayerManager.interact_pressed.is_connected(change_scene):
		PlayerManager.interact_pressed.connect(change_scene)

func _player_exited(_p: Node2D) -> void:
	if PlayerManager.interact_pressed.is_connected(change_scene):
		PlayerManager.interact_pressed.disconnect(change_scene)

func change_scene() -> void:
	SceneManager.load_new_scene(level)
	print("Scene Changed")


func _update_area() -> void:
	var new_rect: Vector2 = Vector2(16, 16)
	var new_pos: Vector2 = Vector2.ZERO
	
	new_rect.x *= size
	new_rect.y *= size
	
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
	
	collision_shape.shape.size = new_rect
	collision_shape.position = new_pos
