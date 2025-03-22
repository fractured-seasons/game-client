class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var selector: Sprite2D = $Selector
@onready var inventory: Inventory = player.inventory
var flowers_plant_scenes = {
	"PlantSunflower" : preload("res://scenes/objects/plants/sunflower.tscn"),
	"PlantWatermelon" : preload("res://scenes/objects/plants/watermelon.tscn"),
	"PlantTomato": preload("res://scenes/objects/plants/Tomato.tscn")
}
# var sunflower_plant_scene = preload("res://scenes/objects/plants/sunflower.tscn")
# var watermelon_plant_scene = preload("res://scenes/objects/plants/watermelon.tscn")
# var tomato_plant_scene = preload("res://scenes/objects/plants/Tomato.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

var occupied_cells: Array = []
static var se_planteaza: bool = true
signal plantat
func _process(delta: float) -> void:
	if ToolManager.selected_tool == DataTypes.Tools.Plant:
		update_selector()
	else:
		selector.visible = false

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_crop()
			
	elif event.is_action_pressed("plant"):
		if ToolManager.selected_tool == DataTypes.Tools.Plant:
			# get_cell_under_mouse()
			add_crop_from_selector()
	
	
func get_cell_under_mouse() -> void:
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	
	# print("Mouse position: ", mouse_position)
	# print("Cell position: ", cell_position)
	# print("Cell source id: ", cell_source_id)
	# print("Local cell position: ", local_cell_position)
	# print("Distance to: ", distance)

func add_crop_from_selector() -> void:
	local_cell_position = selector.position
	cell_position = tilled_soil_tilemap_layer.local_to_map(local_cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	
	if distance < 20.0 and can_be_planted(cell_position) == true:
		if return_se_planteaza():
			if ToolManager.selected_tool == DataTypes.Tools.Plant:
				var seed_name = ToolManager.selected_seed
				for seed in flowers_plant_scenes.keys():
					if seed_name == DataTypes.PlantTypes[seed]:
						var seed_scene = flowers_plant_scenes[seed]
						var seed_instance = seed_scene.instantiate() as Node2D
						seed_instance.global_position = local_cell_position
						get_parent().find_child("CropFields").add_child(seed_instance)
						occupied_cells.append(cell_position)
						print("plantat")
						se_planteaza = true
						plantat.emit()
						# print("dada",can_be_planted())
						# update_can_plant_status()
		else:
			print("nu am seminte rege")
			se_planteaza = true
			plantat.emit()
	else:
		print("occupied")
		se_planteaza = false
		plantat.emit()
		# print("nunu",can_be_planted())
		# update_can_plant_status()
func remove_crop() -> void:
	if distance < 20.0:
		var crop_nodes = get_parent().find_child("CropFields").get_children()
		for node: Node2D in crop_nodes:
			if node.global_position == local_cell_position:
				node.queue_free()

func update_selector():
	
	# print("ello")
	var cells: Array[Vector2i] = tilled_soil_tilemap_layer.get_used_cells()
	var threshold: int = 10
	selector.visible = false
	
	for cell in cells:
		var cell_pos: Vector2 = tilled_soil_tilemap_layer.map_to_local(cell)
		if player.global_position.distance_to(cell_pos) < threshold:
			selector.position = cell_pos
			selector.visible = true
			

func can_be_planted(cell_poz: Vector2i) -> bool:
	if cell_poz in occupied_cells:
		return false
	return true

static func return_se_planteaza():
	return se_planteaza

static func input_se_planteaza(x: bool):
	se_planteaza = x
