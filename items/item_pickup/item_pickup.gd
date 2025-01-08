@tool
class_name ItemPickup extends Node2D

@export var item_data: ItemData : set = _set_item_data

@onready var area: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var pickup_invincibility: Timer = $PickupInvincibility
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D




func _ready() -> void:
	update_texture()
	if Engine.is_editor_hint():
		return
	
	pickup_invincibility_onspawn()
	area.body_entered.connect( _on_body_entered )
	

func _set_item_data(value: ItemData) -> void:
	item_data = value
	update_texture()
	pass


func _on_body_entered(body) -> void:
	if body.name == "Player":
		if item_data:
			if PlayerManager.INVENTORY_DATA.add_item(item_data) == true:
				item_picked_up()
	
	pass

func item_picked_up() -> void:
	area.body_entered.disconnect( _on_body_entered)
	audio_stream_player.play()
	visible = false
	await audio_stream_player.finished
	queue_free()


func update_texture() -> void:
	if item_data && sprite:
		sprite.texture = item_data.texture
	pass

func pickup_invincibility_onspawn() -> void:
	collision_shape.disabled = true
	pickup_invincibility.start()
	await pickup_invincibility.timeout
	collision_shape.disabled = false
