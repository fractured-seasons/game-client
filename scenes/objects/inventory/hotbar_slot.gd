extends Button

@onready var background_sprite: Sprite2D = $background
@onready var item_stack_gui: ItemStackGUI = $CenterContainer/Panel
@onready var indexinv: Label = $IndexInv

func update_to_slot(slot: InventorySlot, index: int):
	index += 1
	indexinv.text = str(index)
	
	if !slot.item:
		item_stack_gui.visible = false
		return
	
	item_stack_gui.inventorySlot = slot
	item_stack_gui.update()
	item_stack_gui.visible = true
	
