extends Level


@onready var entrance_door: Area2D = $EntranceDoor

var market_door_spawn_pos: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_spawn_pos = Vector2(28, -16)
	entrance_spawn_pos = entrance_door.global_position
	market_door_spawn_pos = Vector2(-405, 9)
	PlayerManager.set_player_pos(default_spawn_pos)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_market_door_area_entered(_area: Area2D) -> void:
	PlayerManager.interact_pressed.connect(Market.toggle_market_visibility)


func _on_market_door_area_exited(_area: Area2D) -> void:
	PlayerManager.interact_pressed.disconnect(Market.toggle_market_visibility)
