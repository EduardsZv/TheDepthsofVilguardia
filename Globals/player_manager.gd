extends Node

const PLAYER = preload("res://characters/Player/player.tscn")
const INVENTORY_DATA = preload("res://characters/Player/player_inv.tres")

signal interact_pressed

var player: Player

func _ready() -> void:
	PlayerManager.add_player_instance()
	pass

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

func set_player_pos( _new_pos: Vector2) -> void:
	player.global_position = _new_pos

func set_as_parent( _p: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_p.add_child(player)


func unparent_player(_p: Node2D) -> void:
	_p.remove_child(player)
