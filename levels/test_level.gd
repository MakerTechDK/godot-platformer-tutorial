class_name Level extends Node2D

signal diamonds_updated(int)


@onready var collectables: TileMapLayer = $Tilemaps/Collectables


var diamonds: int = 0


func _ready() -> void:
	call_deferred("connect_signals")


func connect_signals() -> void:
	for child in collectables.get_children():
		if child is Diamond:
			child.is_collected.connect(diamond_collected)
	

func diamond_collected() -> void:
	diamonds += 1
	diamonds_updated.emit(diamonds)
