extends Level

@onready var entrance_door: Area2D = $EntranceDoor




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_spawn_pos = entrance_door.global_position
	entrance_spawn_pos = entrance_door.global_position
	PlayerManager.set_player_pos(default_spawn_pos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
