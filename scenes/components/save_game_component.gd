extends Node2D

@export var player: Player
@onready var inventory: Inventory = preload("res://scenes/objects/inventory/player_inventory.tres")

var item: InventoryItem
var slots: Array

func save():
	slots = inventory.return_slots()
	
	var slots_data = []
	for slot in slots:
		var slot_data = null
		if slot.item:
			var texture_data = {}
			
			if slot.item.texture is AtlasTexture:
				var atlas_texture: AtlasTexture = slot.item.texture
				texture_data["is_atlas"] = true
				texture_data["atlas_path"] = atlas_texture.atlas.resource_path
				texture_data["region"] = {
					"position" : {
						"x": atlas_texture.region.position.x,
						"y": atlas_texture.region.position.y
					},
					"size": {
						"x": atlas_texture.region.size.x,
						"y": atlas_texture.region.size.y
					}
				}
			
			slots_data.append({
				"item_name": slot.item.name,
				"max_amount": slot.item.maxAmountPrStack,
				"amount": slot.amount,
				"texture_data": texture_data
			})
		else:
			slots_data.append(null)
	
	
	
	
	var player_data = {
		"x": player.global_position.x,
		"y": player.global_position.y,
		"inventory": slots_data,
	}
	print(player_data)
	
	var jsonString = JSON.stringify(player_data)
	
	var jsonFile = FileAccess.open("res://savegame.json", FileAccess.WRITE)
	jsonFile.store_line(jsonString)
	jsonFile.close()
func load():
	var jsonFile = FileAccess.open("res://savegame.json", FileAccess.READ)
	var jsonString = jsonFile.get_as_text()
	jsonFile.close()
	
	var player_data = JSON.parse_string(jsonString)
	
	player.global_position.x = player_data.x
	player.global_position.y = player_data.y
	
	var saved_inventory = player_data["inventory"]
	var new_slots: Array[InventorySlot] = []
	
	for saved_slot in saved_inventory:
		var inv_slot = InventorySlot.new()
		
		if saved_slot:
			var item = InventoryItem.new()
			item.name = saved_slot["item_name"]
			item.maxAmountPrStack = saved_slot["max_amount"]
			
			var texture_data = saved_slot["texture_data"]
			if texture_data["is_atlas"]:
				var atlas_texture = AtlasTexture.new()
				atlas_texture.atlas = load(texture_data["atlas_path"])
				var region_dict = texture_data["region"]
				var position_dict = region_dict["position"]
				var size_dict = region_dict["size"]
				atlas_texture.region = Rect2(
					Vector2(position_dict["x"], position_dict["y"]),
					Vector2(size_dict["x"], size_dict["y"])
				)
				item.texture = atlas_texture
				
			inv_slot.item = item
			inv_slot.amount = saved_slot["amount"]
		else:
			inv_slot.item = null
			inv_slot.amount = 0
		
		new_slots.append(inv_slot)
	
	inventory.slots = new_slots
	inventory.loader()
	
	
