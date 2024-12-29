extends Camera2D

@onready var camera: Camera2D = $"."



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("zoom_in") && camera.zoom[0] < 5:
		camera.zoom *= 1.01
		
	if Input.is_action_pressed("zoom_out") && camera.zoom[0] > 3:
		camera.zoom *= 0.99
