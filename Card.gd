extends Control

const POINTS 		= [3, 4, 5, 6]
const DIRECTIONS 	= ["Left", "Top", "Right", "Down"]
const COLORS 		= { 
	"red"	: Color(1.0, 0.0, 0.0), 
	"blue"	: Color(0.0, 0.0, 1.0), 
	"green"	: Color(0.0, 1.0, 0.0) 
}
const EVEN_TABLE	= ["red", "red", "green", "green", "blue", "blue"]
const RED_TABLE		= ["red", "red", "red", "red", "green", "blue"]
const GREEN_TABLE	= ["green", "green", "green", "green", "red", "blue"]
const BLUE_TABLE	= ["red", "green", "blue", "blue", "blue", "blue"]

onready var card_spell 	= get_node("Spell")
onready var card_connectors 	= {
	"Left"	: get_node("Connectors/Left"),
	"Right"	: get_node("Connectors/Right"),
	"Top"	: get_node("Connectors/Top"),
	"Down"	: get_node("Connectors/Down")
}

var _color
var _points
var _tier 		= 0
var _spell 		= null
var _connectors = []
var _symbols 	= {
	"type"	: null,
	"amount": 0
}

func generate(tier):
	_tier = tier
	_points = POINTS[_tier]
	
	_generate_spell()
	_generate_connections()
	_generate_connections_orientation()
	
	var dice = randi() % 2
	if dice > 0:
		_generate_symbols()
		_generate_color()
	else:
		_generate_color()
		_generate_symbols()

func _generate_spell():
	if _points < 1: return
	
	randomize()
	var result_table = ["Heal", "Injury", "Draw", "Sight", "Exile"]
	var dice = (randi() % 8) # Roll the dice
	
	if dice > 4:
		card_spell.set_texture(Texture.new())
		return false
	else:
		_points -= 1
		_spell = SPELLS.get(result_table[dice])
		card_spell.set_texture(_spell["Image"])
		return true

func _generate_connections():
	if _points < 1: return
	
	var result_table = [1, 2, 2, 2, 3]
	
	randomize()
	# Find the number of connections
	var dice = randi() % 5
	var number_of_connections = result_table[dice]
	
	# Ensure we don't have more connections than we have points
	if _points < number_of_connections:
		number_of_connections = _points
	
	# Find which connections are selected
	var dice
	if number_of_connections == 1:
		dice = randi() % 4
		_connectors.append(card_connectors[DIRECTIONS[dice]])
	elif number_of_connections == 3:
		dice = randi() % 4
		var i = 0
		for connector in card_connectors.values():
			if i != dice:
				_connectors.append(connector)
			i += 1
	elif number_of_connections == 2:
		var dice_1 = randi() % 4
		_connectors.append(card_connectors[DIRECTIONS[dice_1]])
		
		var dice_2 = randi() % 4
		
		while dice_2 == dice_1:
			dice_2 = randi() % 4
		_connectors.append(card_connectors[DIRECTIONS[dice_2]])
	
	# Show the chosen connectors
	for connector in _connectors:
		connector.show()
	
	_points -= number_of_connections

func _generate_connections_orientation():
	if _spell == null: return;
	if _connectors.size() > 1: _points += 1 # Refund the spell's points
	
	var orientations_number = 0
	var i = 0
	for connector in _connectors:
		randomize()
		if i == 0 or randi () % 2 > 0: # 1st is automatic, then 50% chance
			orientations_number += 1
			var dice = randi() % 6
			var table
			if _spell["Orientation"] == null:
				table = EVEN_TABLE
			elif _spell["Orientation"] == "red":
				table = RED_TABLE
			elif _spell["Orientation"] == "green":
				table = GREEN_TABLE
			elif _spell["Orientation"] == "blue":
				table = BLUE_TABLE
			
			var orientation = connector.get_node("Orientation")
			orientation.set_frame_color(COLORS[table[dice]])
			orientation.show()
		i += 1

func _generate_color():
	if _points < 1: return
	
	var table
	var dice = randi() % 5
	
	if _spell != null and _spell["Predilection"]:
		var predilection = _spell["Predilection"]
		
		if predilection == "red":
			table = RED_TABLE
		elif predilection == "green":
			table = GREEN_TABLE
		elif predilection == "blue":
			table = BLUE_TABLE
	else:
		table = EVEN_TABLE
	
	_color = table[dice]
	set_frame_color(COLORS[_color])
	get_node("Spell").set_modulate(COLORS[_color])
	
	_points -= 1

func _generate_symbols():
	var type = ["shield", "sword"][randi() % 2]
	var node
	if type == "shield":
		node = get_node("Symbols/Shields")
	else:
		node = get_node("Symbols/Swords")
	
	var roll = (randi()%6) + (randi()%6)
	var number
	if roll < 4:
		number = _tier
	elif roll > 8:
		number = _tier + 2
	else:
		number = _tier + 1
	
	if number > 3: number = 3
	
	if _points < number:
		number = _points
	
	for i in range(number):
		node.get_node(str(i + 1)).show()
	
	_points -= number