extends Node2D

@onready var sprite: AnimatedSprite2D = $OnionSprite
var growth_stage: int = 0  # 0 = sămânță, 1 = intermediar, 2 = maturitate
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

		if growth_stage >= 2:
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
