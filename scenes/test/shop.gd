extends Area2D

func _ready() -> void:
	$ShopMenu.visible = false

func player_entered(body: Node2D) -> void:
	print("entered")
	if body is Player:
		$ShopMenu.visible = true


func player_exit(body: Node2D) -> void:
	$ShopMenu.visible = false
