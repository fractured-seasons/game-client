class_name GrowthCycleComponent
extends Node

@export_range(5, 365) var days_until_harvest: int = 7
@export var growth_states_list: Array[DataTypes.GrowthStates] = []
@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Sprout

signal crop_maturity
signal crop_harvesting

var is_watered: bool
var starting_day: int
var current_day: int
var current_state_index: int = 2

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

func on_time_tick_day(day: int) -> void:
	if is_watered:
		if starting_day == 0:
			starting_day = day
		
		growth_states(starting_day, day)
		harvest_state(starting_day, day)

func growth_states(starting_day: int, current_day: int):
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return
	# Afisam lista sa vedem fiecare planta ce stadii are (valorile)
	print("Growth state list", growth_states_list)
	# Num states = numarul de stari al plantei
	var num_states = growth_states_list.size()
	
	# Calculam current_state_index, practic pozitia din lista care indica starea la care se afla planta
	var growth_days_passed = (current_day - starting_day) % num_states
	current_state_index = growth_days_passed % num_states + 2
	
	# { "Seed": 0, "Harvesting": 1, "Sprout": 2, "Germination": 3, "Vegetative": 4, "Reproduction": 5, "Maturity": 6 }
	# Salvam starea curenta la care se afla planta
	current_growth_state = growth_states_list[current_state_index]
	
	var name = DataTypes.GrowthStates.keys()[growth_states_list[current_state_index]]
	print("Stadiul actual al plantei: ", name, " Pozitie lista: ", current_state_index)
	print("Pozitie din DataTypes: ", current_growth_state)
	
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit()

func harvest_state(starting_day: int, current_day: int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Harvesting:
		return
	
	var days_passed = (current_day - starting_day) % days_until_harvest
	
	if days_passed == days_until_harvest - 1:
		current_growth_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()

func get_current_growth_state() -> DataTypes.GrowthStates:
	# Returnam index-ul din lista
	return current_state_index
