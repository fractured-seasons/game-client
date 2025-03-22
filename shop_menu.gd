extends StaticBody2D

var current_index = 0
var shop_items: Array = Global.shop_items
var inventory_slots: Array[InventorySlot]
@onready var inventory: Inventory = preload("res://scenes/objects/inventory/player_inventory.tres")
@onready var price: Label = $BuyControl/Price
@onready var sell_price: Label = $SellControl/SellPrice
func _ready() -> void:
	$ShopItems.play(shop_items[current_index]["id"])
	$BuyControl.visible = false
	$SellControl.visible = false
	$NotBuy.visible = false
	$NotSell.visible = false
func _physics_process(delta: float) -> void:
	if self.visible == true:
		$ShopItems.play(shop_items[current_index]["id"])
		$SeedName.text = str(shop_items[current_index]["name"])
		
		if shop_items[current_index]["sellable"]:
			$SellControl.visible = true
			$NotSell.visible = false
			sell_price.text = str(shop_items[current_index]["price"])
		else:
			$SellControl.visible = false
			$NotSell.visible = true
		if shop_items[current_index]["buyable"]:
			price.text = str(shop_items[current_index]["sell_price"])
			$BuyControl.visible = true
			$NotBuy.visible = false
		else:
			$BuyControl.visible = false
			$NotBuy.visible = true
func _on_left_button_pressed() -> void:
	swap_items_back()

func _on_right_button_pressed() -> void:
	swap_items_forward()

func _on_buy_button_pressed() -> void:
	if Global.coins >= shop_items[current_index]["price"]:
		Global.coins = Global.coins - shop_items[current_index]["price"]
		buy()
		

func swap_items_back():
	if current_index != 0:
		current_index -= 1
	else:
		current_index = shop_items.size() - 1

func swap_items_forward():
	if current_index != shop_items.size() - 1:
		current_index += 1
	else:
		current_index = 0

func buy():
	var scene_path = "res://scenes/objects/plants/" + shop_items[current_index]["name"] + ".tscn"
	
	var item_scene = load(scene_path)
	var item_instance = item_scene.instantiate()
	item_instance.global_position = self.global_position + Vector2(0,50)
	get_tree().current_scene.add_child(item_instance)
	
func sell():
	inventory_slots = inventory.return_slots()
	for index in range(inventory_slots.size()):
		if inventory_slots[index].item != null:
			var item_name = inventory_slots[index].item.name
			var item_amount = inventory_slots[index].amount
			# Modify the if function 
			# if item_name == shop_items[current_index]["name"]
			if item_name == shop_items[current_index]["id"]:
				if inventory_slots[index].amount > 0:
					inventory_slots[index].amount -= 1
					Global.coins += shop_items[current_index]["sell_price"]
					if inventory_slots[index].amount == 0:
						inventory.remove_at_index(index)
	inventory.loader()
