extends Camera2D

@onready var camera: Camera2D = $"."



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# Zoom in with camera, if inventory isn't open
	if Input.is_action_pressed("zoom_in") && camera.zoom[0] < 5 && !Inventory.inv_open:
		camera.zoom *= 1.01
	
	# Zoom out, if inventory isn't open
	if Input.is_action_pressed("zoom_out") && camera.zoom[0] > 3 && !Inventory.inv_open:
		camera.zoom *= 0.99
