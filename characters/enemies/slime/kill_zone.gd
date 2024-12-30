extends Area2D

signal attacking

var inside_killzone := false
var saved_body: Node2D
var damage: int = 0


func _process(delta: float) -> void:
	if inside_killzone:
		if saved_body.name == "Player":
			saved_body.damage_player(damage)

func _on_body_entered(body: Node2D) -> void:
	if body == null: # If function runs multiple times
		inside_killzone = true
		saved_body.damage_player(damage)
		attacking.emit()
		return
	if body.name == "Player": # Function runs for the first time
		saved_body = body # Saves the body which entered
		inside_killzone = true
		body.damage_player(damage)
		attacking.emit()



func _on_body_exited(body: Node2D) -> void:
	inside_killzone = false
