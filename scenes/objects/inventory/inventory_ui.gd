extends Control

@onready var inventory: Inventory = preload("res://scenes/objects/inventory/player_inventory.tres")
@onready var ItemStackGuiClass = preload("res://scenes/objects/inventory/itemsStackGUI.tscn")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var is_open: bool = false

var itemInHand: ItemStackGUI

signal opened
signal closed

func _ready():
	connectSlots()
	inventory.updated.connect(update)
	update()

func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		
		slot.pressed.connect(_onSlotClicked.bind(slot))

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		
		if !inventorySlot.item: continue
		
		var itemStackGUI: ItemStackGUI = slots[i].itemStackGUI
		if !itemStackGUI:
			itemStackGUI = ItemStackGuiClass.instantiate()
			slots[i].insert(itemStackGUI)
			
		itemStackGUI.inventorySlot = inventorySlot
		itemStackGUI.update()

func open():
	visible = true
	is_open = true
	opened.emit()

func close():
	visible = false
	is_open = false
	closed.emit()


func _onSlotClicked(slot):
	if slot.isEmpty() && itemInHand:
		insertItemInSlot(slot)
		return
		
	if !itemInHand:
		takeItemFromSlot(slot)

func takeItemFromSlot(slot):
	print("yes")
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	updateItemInHand()

func insertItemInSlot(slot):
	var item = itemInHand
	
	remove_child(itemInHand)
	itemInHand = null
	
	slot.insert(item)


func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size / 2

func _input(event):
	updateItemInHand()
