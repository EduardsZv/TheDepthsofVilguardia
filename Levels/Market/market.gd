extends CanvasLayer

signal shown
signal hidden

signal sell_pressed

@onready var exit_button: Button = $Control/ExitContainer/ExitButton


@onready var sell_res_count: Label = $Control/VBoxContainer/SellResCount
@onready var grid_container: InventoryUI = $Control/PlayerInv/GridContainer

@onready var player_money_label: Label = $Control/PlayerMoneyLabel
@onready var sellable_item_label: Label = $Control/SellableItemLabel



var selected_item_count: int = 1
var selected_slot: ItemData

var market_open := false

func _ready() -> void:
	visible = false
	
	

func _process(delta: float) -> void:
	update_player_money_label()
	update_sell_res_count()
	grid_container.update_selected_items(selected_slot)

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("plus"):
		_on_plus_button_pressed()
	if Input.is_action_just_pressed("minus"):
		_on_minus_button_pressed()

func update_sell_res_count() -> void:
	sell_res_count.text = str(selected_item_count)

func toggle_market_visibility() -> void:
	if !market_open:
		open_market()
	else:
		close_market()

func _on_exit_button_pressed() -> void:
	close_market()


func _on_plus_button_pressed() -> void:
	selected_item_count += 1

func _on_minus_button_pressed() -> void:
	if selected_item_count > 1:
		selected_item_count -= 1


# Opens the inventory, restricts player movement
func open_market() -> void:
	
	if Inventory.inv_open:
		Inventory.close_inventory()
	
	PlayerManager.player.restricted_movement = true
	await TransitionAnimation.fade_out()
	visible = true
	market_open = true
	PlayerManager.player.restricted_movement = true
	shown.emit()
	await TransitionAnimation.fade_in()


# Closes the inventory, allows player movement
func close_market() -> void:
	PlayerManager.player.restricted_movement = false
	await TransitionAnimation.fade_out()
	visible = false
	market_open = false
	PlayerManager.player.restricted_movement = false
	hidden.emit()
	await TransitionAnimation.fade_in()

func update_player_money_label() -> void:
	player_money_label.text = "Available money: " + str(PlayerManager.coins) + "c"


func update_sellable_item_value(value: int) -> void:
	sellable_item_label.text = "Value: " + str(value) + "c"


func _on_sell_button_pressed() -> void:
	sell_pressed.emit()
