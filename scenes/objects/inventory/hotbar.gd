extends Panel

@onready var inventory: Inventory = preload("res://scenes/objects/inventory/player_inventory.tres")
@onready var slots: Array = $Container.get_children()
@onready var selector: Sprite2D = $Selector

var currently_select: int = 0

func _ready() -> void:
	update()
	inventory.updated.connect(update)

func update() -> void:
	for i in range(slots.size()):
		var inventory_slot: InventorySlot = inventory.slots[i]
		slots[i].update_to_slot(inventory_slot, i)

func move_selector(index: int) -> void:
	# Posibil refactor, e cam hardcodat 
	currently_select = index - 1
	var button_center = slots[currently_select].global_position + (slots[currently_select].size * 0.5)
	var selector_size = selector.texture.get_size() * selector.scale
	selector.global_position = button_center + (selector_size * 0.15) + Vector2(0, -2)
	# print(button_center, selector.global_position)
	
func _unhandled_input(event: InputEvent) -> void:
	for i in range(1,6):
		var action_name = "slot" + str(i)
		if event.is_action_pressed(action_name):
			move_selector(i)
			print("Slot", i, "pressed")
			break
	if event.is_action_pressed("use_item"):
		inventory.use_item_at_index(currently_select)
