extends Node2D

@export var inventory_item: InventoryItem
@onready var sprite: AnimatedSprite2D = $OnionSprite
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
var growth_stage: int = 0  # 0 = sămânță, 1 = intermediar, 2 = maturitate, 3 = collectible
var water_level: float = 0  # Nivelul de apă (1.0 = suficient, 0 = uscat)
var sunlight: float = 1.0  # Expunerea la soare (0-1)
var fertilizer: float = 0  # Cantitatea de fertilizator folosită
var growing: bool = true  # Flag care indică dacă planta crește

var growth_thread: Thread = Thread.new()  # Thread-ul pentru creștere

func _ready():
	watering_particles.emitting = false
	flowering_particles.emitting = false
	hurt_component.hurt.connect(_on_hurt_component_hurt)
	sprite.material.set_shader_parameter("speed", 0)
	# Pornim un thread separat pentru crestere
	if sprite:
		sprite.frame = 0
	#if water_level > 0:
		#growth_thread.start(grow_loop)

func grow_loop():
	while growing:
		#var growth_factor = (water_level + sunlight + fertilizer) / 3.0
		var growth_factor = 1
		var growth_time = 5.0 / max(growth_factor, 0.1)
		await get_tree().create_timer(growth_time).timeout 
		
		growth_stage += 1
		update_sprite()
		print("Onion a crescut! Stadiu: ", growth_stage)
		
		if growth_stage == 2:
			flowering_particles.emitting = true
			await get_tree().create_timer(5.0).timeout
			flowering_particles.emitting = false

		if growth_stage >= 3:
			print("Onion este matură!")
			sprite.material.set_shader_parameter("speed", 0.4)
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
		if growth_stage == 3:
			if body.collect(inventory_item):
				print("Onion collected by player")
				queue_free()
			else:
				print("Inventory full or item not collected")


func _on_hurt_component_hurt(hit) -> void:
	print("onion watered")
	water_level = 1.0
	watering_particles.emitting = true
	await get_tree().create_timer(5.0).timeout
	watering_particles.emitting = false
	growth_thread.start(grow_loop)
