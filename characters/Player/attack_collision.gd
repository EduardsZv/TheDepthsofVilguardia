extends Area2D

@onready var player: Player = $"../.."



var damage: int

# Assigns damage to the player's attack zone
func _ready() -> void:
	damage = player.damage
