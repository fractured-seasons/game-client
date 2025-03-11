class_name CollectableComponent
extends Area2D

@export var collectable_name: String
@export var item: InventoryItem
var player = null


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Collected")
		player = body
		if player.collect(item):
			get_parent().queue_free()
		else:
			print("Inventory ful")
