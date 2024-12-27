extends Area2D

@onready var timer: Timer = $Timer
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var target: Node2D




func makepath():
	nav_agent.target_position = target.global_position
	
	
	
func _on_timer_timeout():
	makepath()
