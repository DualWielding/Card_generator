extends Node

const spells = {
	"Heal"	: {
		"Predilection"	: null, # The prefered color of the card
		"Orientation"	: null, # The prefeted color
		"Image"			: preload("res://icons/health-normal.png")
	},
	"Injury": {
		"Predilection"	: null,
		"Orientation"	: null,
		"Image"			: preload("res://icons/broken-bone.png")
	},
	"Draw"	: {
		"Predilection"	: null,
		"Orientation"	: null,
		"Image"			: preload("res://icons/card-draw.png")
	},
	"Sight"	: {
		"Predilection"	: null,
		"Orientation"	: null,
		"Image"			: preload("res://icons/lock-spy.png")
	}
#	"Exile"	: {
#		"Predilection"	: null,
#		"Orientation"	: null,
#		"Image"			: preload("res://icons/card-discard.png")
#	}
}

func get(spell_name):
	return spells[spell_name]

func count():
	return spells.values().size()