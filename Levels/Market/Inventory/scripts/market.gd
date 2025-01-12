extends CanvasLayer

signal shown
signal hidden

signal sell_pressed
signal buy_pressed

signal market_inv_created

signal player_inv_changed

@onready var exit_button: Button = $Control/ExitContainer/ExitButton


@onready var sell_res_count: Label = $Control/VBoxContainer/SellResCount
@onready var player_inv_ui: InventoryUI = $Control/PlayerInv/GridContainer

@onready var market_inv_ui: MarketInvUI = $Control/MarketInv/GridContainer


@onready var player_money_label: Label = $Control/PlayerMoneyLabel
@onready var sellable_item_label: Label = $Control/SellableItemLabel
@onready var buyable_item_label: Label = $Control/BuyableItemLabel


const MARKET_INVENTORY_DATA = preload("res://Levels/Market/Inventory/market_inventory.tres")

var selected_item_count: int = 1
var player_inv_selected_slot: SlotData

var market_inv_selected_slot: SlotData

var market_open := false

func _ready() -> void:
	market_inv_created.emit()
	MARKET_INVENTORY_DATA.set_market_items()
	visible = false



func _process(_delta: float) -> void:
	update_player_money_label()
	update_sell_res_count()
	player_inv_ui.update_selected_items(player_inv_selected_slot)
	market_inv_ui.update_selected_items(market_inv_selected_slot)

func _unhandled_input(_event: InputEvent) -> void:
	
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
	if player_inv_selected_slot:
		if player_inv_selected_slot.quantity > selected_item_count:
			selected_item_count += 1
			update_sellable_item_value(player_inv_selected_slot.item_data.sell_value * selected_item_count)
	else:
		selected_item_count = 1

func _on_minus_button_pressed() -> void:
	if player_inv_selected_slot:
		if selected_item_count > 1:
			selected_item_count -= 1
			update_sellable_item_value(player_inv_selected_slot.item_data.sell_value * selected_item_count)
	else:
		selected_item_count = 1

func reset_market_labels() -> void:
	sellable_item_label.text = ""
	buyable_item_label.text = ""

func reset_selected_item_count() -> void:
	sellable_item_label.text = ""
	selected_item_count = 1
	player_inv_selected_slot = null
	player_inv_ui.update_selected_items(null)

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
	reset_selected_item_count()
	reset_market_labels()

func update_player_money_label() -> void:
	player_money_label.text = "Available money: " + str(PlayerManager.coins) + "c"


func update_sellable_item_value(value: int) -> void:
	sellable_item_label.text = "Value: " + str(value) + "c"


func _on_sell_button_pressed() -> void:
	sell_pressed.emit(selected_item_count)

func _on_sell_all_button_pressed() -> void:
	sell_pressed.emit(null)

func update_buyable_item_value(value: int) -> void:
	buyable_item_label.text = "Cost:" + str(value) + "c"




func _on_buy_button_pressed() -> void:
	buy_pressed.emit()
