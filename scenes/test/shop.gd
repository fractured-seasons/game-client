extends Area2D

var player_in_range: bool = false
@onready var tooltip: Sprite2D = $Tooltip


func _ready() -> void:
	$ShopMenu.visible = false
	tooltip.visible = false
	
func player_entered(body: Node2D) -> void:
	# print("entered")
	if body is Player:
		player_in_range = true
		tooltip.visible = true

func player_exit(body: Node2D) -> void:
	player_in_range = false
	$ShopMenu.visible = false
	tooltip.visible = false
func _input(event: InputEvent) -> void:
	if player_in_range:
		if !$ShopMenu.visible and event.is_action_pressed("interact"):
			$ShopMenu.visible = true
		elif $ShopMenu.visible and event.is_action_pressed("interact"):
			$ShopMenu.visible = false
