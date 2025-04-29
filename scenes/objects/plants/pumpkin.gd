extends Node2D

@export var inventory_item: InventoryItem
@onready var sprite: AnimatedSprite2D = $PumpkinSprite
var growth_stage: int = 0  
var sunlight: float = 1.0  
var fertilizer: float = 0.0 
var growing: bool = true  

var growth_thread: Thread = Thread.new()  # Thread-ul pentru creștere

func _ready():
	# Pornim un thread separat pentru crestere
	if sprite:
		sprite.frame = 0
	growth_thread.start(grow_loop)

func grow_loop():
	while growing:
		#var growth_factor = (water_level + sunlight + fertilizer) / 3.0
		var growth_factor = 1
		var growth_time = 5.0 / max(growth_factor, 0.1)
		await get_tree().create_timer(growth_time).timeout 
		
		growth_stage += 1
		update_sprite()
		print("Planta a crescut! Stadiu: ", growth_stage)

		if growth_stage >= 4:
			print("Planta este matură!")
			growing = false
			return

func update_sprite():
	if sprite:
		sprite.frame = growth_stage

func _exit_tree():
	# Oprire si curatare thread cand nodul este sters
	if growth_thread.is_started():
		growth_thread.wait_to_finish()

func _on_collect_area_body_entered(body: Node2D) -> void:
	if body is Player and inventory_item:
		if growth_stage == 4:
			if body.collect(inventory_item):
				print("Pumpkin collected by player")
				queue_free()
			else:
				print("Inventory full or item not collected")
