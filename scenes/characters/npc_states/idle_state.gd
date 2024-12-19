extends NodeState

@export var character: NonPlayableCharacter
@export var animated_sprite_2d: AnimatedSprite2D
@export var idle_state_time_interval: float = 5.0

@onready var idle_state_timer: Timer = Timer.new()

var idle_state_timeout: bool = false

func _ready() -> void:
	idle_state_timer.wait_time = idle_state_time_interval
	idle_state_timer.timeout.connect(on_idle_state_timeout)
	add_child(idle_state_timer)
	
func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	if idle_state_timeout:
		transition.emit("Walk")


func _on_enter() -> void:
	var direction = character.last_direction
	if direction != Vector2.ZERO:
		if abs(direction.y) > abs(direction.x):
			if direction.y > 0:
				character.idle_animation = "idle_front"
			else:
				character.idle_animation = "idle_back"
		else:
			if direction.x > 0:
				character.idle_animation = "idle_right"
			else:
				character.idle_animation = "idle_left"
	else:
		character.idle_animation = "idle_front"
	if character.idle_animation:
		animated_sprite_2d.play(character.idle_animation)
	
	idle_state_timeout = false
	idle_state_timer.start()
	
func _on_exit() -> void:
	animated_sprite_2d.stop()
	idle_state_timer.stop()

func on_idle_state_timeout() -> void:
	idle_state_timeout = true
