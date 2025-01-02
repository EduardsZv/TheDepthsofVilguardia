extends Area2D

@onready var player: CharacterBody2D = $".."


var damage: int

func _ready() -> void:
	damage = player.damage
