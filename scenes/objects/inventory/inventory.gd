extends Resource

class_name Inventory

signal updated
# var max_stack: int = 64
@export var slots: Array[InventorySlot]

func add_item_to_inventory(item: InventoryItem):
	var item_slots = slots.filter(func(slot): return slot.item == item)
	if !item_slots.is_empty():
		# if item_slots[0].amount < max_stack:
		item_slots[0].amount += 1
	else:
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = item
			empty_slots[0].amount = 1
	updated.emit()

func removeItemAtIndex(index: int):
	slots[index] = InventorySlot.new()

func insertSlot(index: int, inventorySlot: InventorySlot):
	var oldIndex: int = slots.find(inventorySlot)
	removeItemAtIndex(oldIndex)
	
	slots[index] = inventorySlot
