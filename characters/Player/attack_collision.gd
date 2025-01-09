extends Area2D

@onready var player: CharacterBody2D = $".."


var damage: int

# Assigns damage to the player's attack zone
func _ready() -> void:
	damage = player.damage
