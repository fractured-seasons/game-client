extends Node

var can_plant: bool = true

func set_can_plant(can_plant: bool) -> void:
	self.can_plant = can_plant
	print(self.can_plant)

func get_can_plant() -> bool:
	return can_plant
