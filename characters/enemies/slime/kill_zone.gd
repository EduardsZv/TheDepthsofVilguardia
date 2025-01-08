extends Area2D

signal attacking

var inside_killzone := false
var saved_body: Node2D
var damage: int = 0

@onready var slime: Node2D = $".."


func _process(_delta: float) -> void:
	if inside_killzone:
		if saved_body.name == "Player":
			saved_body.damage_player(damage)




func _on_area_entered(area: Area2D) -> void:
	if area == null: # If function runs multiple times
		inside_killzone = true
		saved_body.damage_player(damage)
		attacking.emit()
		return
	if area.name == "HurtBox": # Function runs for the first time
		saved_body = area.get_parent() # Saves the body which entered
		inside_killzone = true
		saved_body.damage_player(damage)
		attacking.emit()


func _on_area_exited(_area: Area2D) -> void:
	inside_killzone = false
