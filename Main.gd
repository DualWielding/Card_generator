extends PanelContainer

onready var card_container = get_node("HSeparator/CardContainer")

var card_class = preload("res://Card.tscn")
var _tier = 1 setget set_tier, get_tier

func generate_card():
	for child in card_container.get_children():
		child.queue_free()
	
	var card = card_class.instance()
	card_container.add_child(card)
	card.generate(_tier)


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
