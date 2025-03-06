extends CanvasLayer

@onready var inventory = $InventoryUI

func _ready() -> void:
	inventory.close()

func _input(event):
	if event.is_action_pressed("inventory"):
		if inventory.is_open:
			inventory.close()
		else:
			inventory.open()


func _on_inventory_ui_closed() -> void:
	get_tree().paused = false

func _on_inventory_ui_opened() -> void:
	get_tree().paused = true
