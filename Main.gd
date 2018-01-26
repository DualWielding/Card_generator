extends PanelContainer

const POINTS 		= [3, 4, 5, 6]
const DIRECTIONS 	= ["Left", "Top", "Right", "Down"]
const COLORS 		= { 
	"red"	: Color(1.0, 0.0, 0.0), 
	"blue"	: Color(0.0, 0.0, 1.0), 
	"green"	: Color(0.0, 1.0, 0.0) 
}

onready var card 		= get_node("HSeparator/Card")
onready var card_bg 	= card.get_node("Background")
onready var card_spell 	= card_bg.get_node("Spell")

onready var connectors = {
	"Left"	: card_bg.get_node("Connectors/Left"),
	"Right"	: card_bg.get_node("Connectors/Right"),
	"Top"	: card_bg.get_node("Connectors/Top"),
	"Down"	: card_bg.get_node("Connectors/Down")
}

var _tier = 1 setget set_tier, get_tier

var spells = {
	"Heal"	: {
		"Predilection"	: null,
		"Orientation"	: null,
		"Image"			: preload("res://icons/health-normal.png")
	},
	"Injury": {
		"Predilection"	: "red",
		"Orientation"	: "green",
		"Image"			: preload("res://icons/broken-bone.png")
	},
	"Draw"	: {
		"Predilection"	: "green",
		"Orientation"	: "blue",
		"Image"			: preload("res://icons/card-draw.png")
	},
	"Sight"	: {
		"Predilection"	: "blue",
		"Orientation"	: "red",
		"Image"			: preload("res://icons/lock-spy.png")
	},
	"Exile"	: {
		"Predilection"	: null,
		"Orientation"	: null,
		"Image"			: preload("res://icons/card-discard.png")
	}
}

func generate_card():
	var points = POINTS[_tier]
	var spell = _generate_spell(points)
	var has_spell = spell != null
	
	if has_spell: points -= 1
	
	var current_connectors = _generate_connections(points)
	
	points -= current_connectors.size()
	
	# Reset connector color
	for connector in connectors.values():
		connector.get_node("Orientation").set_frame_color(Color(1.0, 1.0, 1.0))
	if has_spell:
		_generate_connections_orientation(spell, current_connectors)

func _generate_spell(points):
	randomize()
	var result_table = ["Heal", "Injury", "Draw", "Sight", "Exile"]
	var dice = (randi() % 8) # Roll the dice
	var spell
	
	if dice > 4:
		card_spell.set_texture(Texture.new())
		return null
	else:
		spell = spells[result_table[dice]]
		card_spell.set_texture(spell["Image"])
		return spell

func _generate_connections(points):
	#First, hide all the connectors
	for connector in connectors.values():
		connector.hide()
	
	var result_table = [1, 2, 2, 2, 3]
	var chosen_connectors = []
	
	randomize()
	# Find the number of connections
	var dice = randi() % 5
	var number_of_connections = result_table[dice]
	
	# Ensure we don't have more connections than we ahve points
	if points < number_of_connections:
		number_of_connections = points
	
	var connections = []
	
	# Find which connections are selected
	var dice
	if number_of_connections == 1:
		dice = randi() % 4
		chosen_connectors.append(connectors[DIRECTIONS[dice]])
	elif number_of_connections == 3:
		dice = randi() % 4
		var i = 0
		for connector in connectors.values():
			if i != dice:
				chosen_connectors.append(connector)
			i += 1
	elif number_of_connections == 2:
		var dice_1 = randi() % 4
		chosen_connectors.append(connectors[DIRECTIONS[dice_1]])
		
		var dice_2 = randi() % 4
		
		while dice_2 == dice_1:
			dice_2 = randi() % 4
		chosen_connectors.append(connectors[DIRECTIONS[dice_2]])
	
	# Show the choen connectors
	for connector in chosen_connectors:
		connector.show()
	return chosen_connectors

func _generate_connections_orientation(spell, current_connectors):
	var i = 0
	for connector in current_connectors:
		randomize()
		if i == 0 or randi () % 2 > 0:
			var dice = randi() % 6
			var table
			if spell["Orientation"] == null:
				table = ["red", "red", "green", "green", "blue", "blue"]
			elif spell["Orientation"] == "red":
				table = ["red", "red", "red", "red", "green", "blue"]
			elif spell["Orientation"] == "green":
				table = ["green", "green", "green", "green", "red", "blue"]
			elif spell["Orientation"] == "blue":
				table = ["red", "green", "blue", "blue", "blue", "blue"]
			
			var orientation = connector.get_node("Orientation")
			orientation.set_frame_color(COLORS[table[dice]])
		i += 1

func set_tier(number):
	if number >= 0 and number <= 3:
		_tier = number
		return true
	return false

func get_tier():
	return _tier



func _on_CheckBox_pressed():
	set_tier(0)

func _on_CheckBox1_pressed():
	set_tier(1)

func _on_CheckBox2_pressed():
	set_tier(2)

func _on_CheckBox3_pressed():
	set_tier(3)

func _on_Generate_pressed():
	generate_card()
