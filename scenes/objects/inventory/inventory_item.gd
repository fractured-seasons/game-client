class_name InventoryItem
extends Resource

@export var name: String = ""
@export var texture: Texture2D
@export var maxAmountPrStack: int = 64

func can_be_used(player: Player):
	return true
