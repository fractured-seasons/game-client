extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer
@onready var inventory = preload("res://scenes/objects/inventory/player_inventory.tres")

var itemStackGUI: ItemStackGUI
var index: int


func insert(isg: ItemStackGUI):
	itemStackGUI = isg
	container.add_child(itemStackGUI)
	
	if !itemStackGUI.inventorySlot || inventory.slots[index] == itemStackGUI.inventorySlot:
		return
	
	inventory.insertSlot(index, itemStackGUI.inventorySlot)

func takeItem():
	var item = itemStackGUI
	
	inventory.removeSlot(itemStackGUI.inventorySlot)
	
	return item

func isEmpty():
	return !itemStackGUI

func clear() -> void:
	if itemStackGUI:
		container.remove_child(itemStackGUI)
		itemStackGUI = null
