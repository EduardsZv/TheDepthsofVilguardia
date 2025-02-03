# Autoload
extends Node

const PLAYER = preload("res://characters/Player/player.tscn")
const INVENTORY_DATA = preload("res://characters/Player/player_inv.tres")

signal interact_pressed
signal died

var player: Player

var coins: int = 0
var points: int = 0

func _ready() -> void:
	 #Clears inventory on startup
	INVENTORY_DATA.clear_inventory()
	pass

func update_hp(hp: int) -> void:
	player.update_health(hp)

func add_strength(strength: int) -> void:
	player.damage += strength

func get_hp() -> int:
	return player.get_health()

func get_max_hp() -> int:
	return player.get_max_health()

# Adds player to a scene
func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)

# Sets player position
func set_player_pos( _new_pos: Vector2) -> void:
	if player:
		player.global_position = _new_pos

# Sets player as a child to a parent node
func set_as_parent( _p: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_p.add_child(player)

# Removes player from a parent node
func unparent_player(_p: Node2D) -> void:
	_p.remove_child(player)

# Removes player from scene
func remove_player_instance() -> void:
	player.queue_free()
	player = null
	INVENTORY_DATA.clear_inventory()
	coins = 0
	points = 0
