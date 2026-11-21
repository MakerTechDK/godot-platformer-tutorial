class_name DiamondUI extends Panel

@onready var label: Label = $Label


func update(diamonds: int) -> void:
	label.text = str(diamonds)
