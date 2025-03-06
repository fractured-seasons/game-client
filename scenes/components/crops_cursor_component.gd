class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")

var sunflower_plant_scene = preload("res://scenes/objects/plants/sunflower.tscn")
var watermelon_plant_scene = preload("res://scenes/objects/plants/watermelon.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_crop()
			
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.PlantSunflower or ToolManager.selected_tool == DataTypes.Tools.PlantWatermelon:
			get_cell_under_mouse()
			add_crop()

func get_cell_under_mouse() -> void:
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	
	print("Mouse position: ", mouse_position)
	print("Cell position: ", cell_position)
	print("Cell source id: ", cell_source_id)
	print("Local cell position: ", local_cell_position)
	print("Distance to: ", distance)

func add_crop() -> void:
	if distance < 20.0:
		if ToolManager.selected_tool == DataTypes.Tools.PlantSunflower:
			var sunflower_instance = sunflower_plant_scene.instantiate() as Node2D
			sunflower_instance.global_position = local_cell_position
			get_parent().find_child("CropFields").add_child(sunflower_instance)
			
		if ToolManager.selected_tool == DataTypes.Tools.PlantWatermelon:
			var watermelon_instance = watermelon_plant_scene.instantiate() as Node2D
			watermelon_instance.global_position = local_cell_position
			get_parent().find_child("CropFields").add_child(watermelon_instance)
			
func remove_crop() -> void:
	if distance < 20.0:
		var crop_nodes = get_parent().find_child("CropFields").get_children()
		for node: Node2D in crop_nodes:
			if node.global_position == local_cell_position:
				node.queue_free()
