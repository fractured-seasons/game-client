extends Node2D

@export var inventory_item: InventoryItem
@onready var sprite: AnimatedSprite2D = $OnionSprite
var growth_stage: int = 0  # 0 = sămânță, 1 = intermediar, 2 = maturitate, 3 = collectible
var water_level: float = 1.0  # Nivelul de apă (1.0 = suficient, 0 = uscat)
var sunlight: float = 1.0  # Expunerea la soare (0-1)
var fertilizer: float = 0.0  # Cantitatea de fertilizator folosită
var growing: bool = true  # Flag care indică dacă planta crește

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

		if growth_stage >= 3:
			print("Planta este matură!")
			growing = false
			return

func update_sprite():
	if sprite:
		sprite.frame = growth_stage
		#match growth_stage:
			#0: sprite.frame = 0 #start
			#1: sprite.frame = 1 #intermetiate
			#2: sprite.frame = 2 #maturity

func _exit_tree():
	# Oprire si curatare thread cand nodul este sters
	if growth_thread.is_started():
		growth_thread.wait_to_finish()

func _on_collect_area_body_entered(body: Node2D) -> void:
	if body is Player and inventory_item:
		if growth_stage == 3:
			if body.collect(inventory_item):
				print("Onion collected by player")
				queue_free()
			else:
				print("Inventory full or item not collected")
