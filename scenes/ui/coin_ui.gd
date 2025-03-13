extends Control

@onready var coins: Label = $HBoxContainer/CoinAmount


func _ready() -> void:
	coins.text = str(Global.coins)


func _physics_process(delta: float) -> void:
	coins.text = str(Global.coins)
