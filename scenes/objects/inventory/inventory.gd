extends Resource

class_name Inventory

signal updated
@export var slots: Array[InventorySlot]

func add_item_to_inventory(item: InventoryItem) -> bool:
	var item_slots = slots.filter(func(slot): return slot.item and slot.item.name == item.name and slot.amount < item.maxAmountPrStack)
	
	if !item_slots.is_empty():
		item_slots[0].amount += 1
	else:
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = item
			empty_slots[0].amount = 1
		else:
			# Inventarul este plin
			return false
	updated.emit()
	return true
	
func removeSlot(inventorySlot: InventorySlot):
	var index = slots.find(inventorySlot)
	if index < 0: return
	remove_at_index(index)

func remove_at_index(index: int) -> void:
	slots[index] = InventorySlot.new()
	updated.emit()


func insertSlot(index: int, inventorySlot: InventorySlot):
	slots[index] = inventorySlot
	updated.emit()

func select_item_at_index(index: int) -> void:
	if index < 0 || index >= slots.size() || !slots[index].item:
		ToolManager.select_tool(DataTypes.Tools.None)
		return
	var slot = slots[index]
	if slot.item.name in DataTypes.Tools.keys():
		ToolManager.select_tool(DataTypes.Tools[slot.item.name])
	elif slot.item.name in DataTypes.PlantTypes.keys():
		ToolManager.select_tool(DataTypes.Tools.Plant)
		ToolManager.select_seed(DataTypes.PlantTypes[slot.item.name])
		
func use_item_at_index(index: int) -> void:
	if !slots[index].item:
		ToolManager.select_tool(DataTypes.Tools.None)
		return
	var slot = slots[index]
	if slot.item.name in DataTypes.Tools.keys():
		var weapon_name = slot.item.name
		ToolManager.select_tool(DataTypes.Tools[weapon_name])
		# print(slot.item.name)
	elif slot.item.name in DataTypes.PlantTypes.keys():
		# print("hello")
		ToolManager.select_tool(DataTypes.Tools.Plant)
		ToolManager.select_seed(DataTypes.PlantTypes[slot.item.name])
		
		if slot.amount > 1:
			slot.amount -= 1
			CropsCursorComponent.input_se_planteaza(true)
			updated.emit()
			return
		
		remove_at_index(index)
		print("made it false")
		# CropsCursorComponent.input_se_planteaza(false)
	else:
		# print(slot.item.name)
		ToolManager.select_tool(DataTypes.Tools.None)
		if slot.amount > 1:
			print("out")
			slot.amount -= 1
			updated.emit()
			return

		remove_at_index(index)

func return_slots():
	return slots


func loader():
	updated.emit()
