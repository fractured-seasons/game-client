class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var inventory: Inventory
@onready var state_machine: NodeStateMachine = $StateMachine
var player_direction: Vector2
@onready var collected_item: Sprite2D = $ItemCollected
# var item: InventoryItem
signal item_collected


func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)
	collected_item.visible = false
	collected_item.position = Vector2(0,-25)
	
func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool

func collect(item: InventoryItem):
	if inventory.add_item_to_inventory(item):
		collected_item.texture = item.texture
		collected_item.visible = true
		item_collected.emit()
		return true
	return false
