extends CanvasLayer

signal shown
signal hidden

signal market_shown
signal market_closed

signal use_pressed
signal delete_pressed

signal inv_created

@onready var item_desc: Label = $Control/ItemDesc
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var del_res_count: Label = $Control/VBoxContainer2/DelResCount

@onready var use_button: Button = $Control/VBoxContainer/UseButton
@onready var del_button: Button = $Control/VBoxContainer/DelButton


@onready var grid_container: InventoryUI = $Control/InvContainer/GridContainer

var selected_slot: SlotData

var selected_item_count: int = 1

var inv_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	inv_created.emit()


func _process(_delta: float) -> void:
	# Updates the selected items so that only one is selected
	grid_container.update_selected_items(selected_slot)
	update_del_res_count()
	

func _unhandled_input(event: InputEvent) -> void:
	# Inventory works only if player character exists
	if PlayerManager.player:
		
		# Toggles the inventory
		if Input.is_action_just_pressed("toggle_inventory") && !Market.market_open:
			if !inv_open:
				open_inventory()
			else:
				close_inventory()
		
		# Changes the selected item count to delete
		if Input.is_action_just_pressed("plus"):
			_on_plus_button_pressed()
		if Input.is_action_just_pressed("minus"):
			_on_minus_button_pressed()

# Opens the inventory, restricts player movement
func open_inventory() -> void:
	visible = true
	inv_open = true
	PlayerManager.player.restricted_movement = true
	shown.emit()

# Closes the inventory, allows player movement
func close_inventory() -> void:
	visible = false
	inv_open = false
	PlayerManager.player.restricted_movement = false
	hidden.emit()


# Updates item description that is shown
func update_item_description(new_text: String) -> void:
	item_desc.text = new_text

# Synchronizes the selected_item_count variable with the label
func update_del_res_count() -> void:
	del_res_count.text = str(selected_item_count)

# Plays sound on item use
func play_sound(sound: AudioStream) -> void:
	audio_stream_player.stream = sound
	audio_stream_player.play()


func _on_plus_button_pressed() -> void:
	selected_item_count += 1

func _on_minus_button_pressed() -> void:
	if selected_item_count > 1:
		selected_item_count -= 1

# Focuses on the use button, used in inventory_slot_ui.gd
func focus_on_use_button() -> void:
	use_button.grab_focus()

# Emits a signal to inv slot
func _on_use_button_pressed() -> void:
	use_pressed.emit()

# Emits a signal to inv slot
func _on_del_button_pressed() -> void:
	delete_pressed.emit()
