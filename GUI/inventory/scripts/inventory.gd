extends CanvasLayer

signal shown
signal hidden

@onready var item_desc: Label = $Control/ItemDesc


var inv_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	close_inventory()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		if !inv_open:
			open_inventory()
		else:
			close_inventory()


func close_inventory() -> void:
	visible = false
	inv_open = false
	get_tree().paused = false
	hidden.emit()

func open_inventory() -> void:
	visible = true
	inv_open = true
	get_tree().paused = true
	shown.emit()

func update_item_description(new_text: String) -> void:
	item_desc.text = new_text
