extends PanelContainer
@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling
@onready var tool_watering: Button = $MarginContainer/HBoxContainer/ToolWatering
@onready var tool_log: Button = $MarginContainer/HBoxContainer/ToolLog
@onready var tool_log_2: Button = $MarginContainer/HBoxContainer/ToolLog2
@onready var tool_log_3: Button = $MarginContainer/HBoxContainer/ToolLog3
@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe


func _on_tool_axe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.AxeWood)


func _on_tool_tilling_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.TillGround)


func _on_tool_watering_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.WaterCrops)

func _input(event: InputEvent) -> void:
	_choose_tool(event)

func _choose_tool(event: InputEvent) -> void:
	if Input.is_action_just_pressed("first_tool"):
		ToolManager.select_tool(DataTypes.Tools.AxeWood)
	elif Input.is_action_just_pressed("second_tool"):
		ToolManager.select_tool(DataTypes.Tools.TillGround)
	elif Input.is_action_just_pressed("third_tool"):
		ToolManager.select_tool(DataTypes.Tools.WaterCrops)
