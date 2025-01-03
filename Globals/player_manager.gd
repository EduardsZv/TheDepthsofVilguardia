extends Node

const PLAYER = preload("res://characters/Player/player.tscn")
const INVENTORY_DATA = preload("res://characters/Player/player_inv.tres")

signal interact_pressed

var player: Player

func _ready() -> void:
	add_player_instance()

func update_hp(hp: int) -> void:
	player.update_health(hp)

func get_hp() -> int:
	return player.get_health()

func get_max_hp() -> int:
	return player.get_max_health()

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)

func toggle_movement() -> void:
	player.toggle_movement()
