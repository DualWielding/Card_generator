extends Node

const spells = {
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

func get(spell_name):
	return spells[spell_name]