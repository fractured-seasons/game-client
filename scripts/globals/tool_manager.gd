extends Node

var selected_tool: DataTypes.Tools = DataTypes.Tools.None
var selected_seed: DataTypes.PlantTypes = DataTypes.PlantTypes.None
signal tool_selected(tool: DataTypes.Tools)
signal seed_selected(seed: DataTypes.PlantTypes)
func select_tool(tool: DataTypes.Tools) -> void:
	tool_selected.emit(tool)
	selected_tool = tool

func select_seed(seed: DataTypes.PlantTypes) -> void:
	seed_selected.emit(seed)
	selected_seed = seed
