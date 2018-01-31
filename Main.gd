extends ItemList

onready var card_container = $CardContainer

var card_class = preload("res://Card.tscn")
var _tier = 1 setget set_tier, get_tier

func generate_card():
	for child in card_container.get_children():
		child.queue_free()
	
	var card = card_class.instance()
	card_container.add_child(card)
	card.generate(_tier)
	
	var card_copy = card.duplicate()
	var container = TextureRect.new()
	container.add_child( card_copy )
	container.set_custom_minimum_size(Vector2(120, 120))
	card_copy.set_scale( Vector2( 0.4, 0.4 ) )
	get_node("VBoxContainer/CurrentCards/List").add_child(container)

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
	get_node("VBoxContainer/Labels/Current").set_text(str(get_node("VBoxContainer/CurrentCards/List").get_child_count()))

func _on_Reset_pressed():
	get_node("VBoxContainer/Labels/Current").set_text("0")
	for node in get_node("VBoxContainer/CurrentCards/List").get_children():
		node.queue_free()
