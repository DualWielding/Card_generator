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
const SPELLS_TABLE 	= ["Heal", "Injury", "Draw", "Sight"]

onready var card_bg = get_node("Background")
onready var card_spell 	= get_node("Spell")
onready var card_connectors 	= {
	"Left"	: $Connectors/Left,
	"Right"	: $Connectors/Right,
	"Top"	: $Connectors/Top,
	"Down"	: $Connectors/Down
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
	
#	print("Début : ", _points)
	_generate_spell()
#	print("Après sort : ", _points)
	_generate_connections()
#	print("Après connections : ", _points)
	_generate_connections_orientation()
#	print("Après orientations : ", _points)
	
	var dice = randi() % 2
	if dice > 0:
		_generate_symbols()
#		print("Après symboles : ", _points)
		_generate_color()
#		print("Après couleur : ", _points)
	else:
		_generate_color()
#		print("Après couleur : ", _points)
		_generate_symbols()
#		print("Après symboles : ", _points)

func _generate_spell():
	if _points < 1: return
	
	randomize()
	var dice = (randi() % (SPELLS.count() * 2)) #1/2 chance to have a spell
	
	if dice > SPELLS.count() - 1:
		card_spell.set_texture(Texture.new())
		return false
	else:
		_points -= 1
		_spell = SPELLS.get(SPELLS_TABLE[dice])
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
	var i = 0
	
	for connector in _connectors:
		randomize()
		if i == 0 or (_points > 0 and randi () % 9 <= _tier): # First is automatic and the higher the tier, the more likely, with a max of 1/3 chance
			if i > 0: _points -= 1 # First is free
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
	card_bg.set_frame_color(COLORS[_color])
	get_node("Spell").set_modulate(COLORS[_color])
	
	_points -= 1

func _generate_symbols():
	var type = ["shield", "sword"][randi() % 2]
	var node
	if type == "shield":
		node = get_node("Symbols/Shields")
	else:
		node = get_node("Symbols/Swords")
	
	var roll = ((randi()%6) + 1) + ((randi()%6) + 1)
	var number
	if roll < 5:
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