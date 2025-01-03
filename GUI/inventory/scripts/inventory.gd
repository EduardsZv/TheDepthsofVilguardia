extends CanvasLayer

signal shown
signal hidden

@onready var item_desc: Label = $Control/ItemDesc
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


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
	PlayerManager.toggle_movement()
	hidden.emit()

func open_inventory() -> void:
	visible = true
	inv_open = true
	PlayerManager.toggle_movement()
	shown.emit()

func update_item_description(new_text: String) -> void:
	item_desc.text = new_text


func play_sound(sound: AudioStream) -> void:
	audio_stream_player.stream = sound
	audio_stream_player.play()
