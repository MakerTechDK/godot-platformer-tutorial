class_name Diamond extends Area2D

signal is_collected


@onready var animations: AnimatedSprite2D = $AnimatedSprite2D

var collected: bool = false

func _on_body_entered(body: Node2D) -> void:
	if collected: return
	collected = true
	
	animations.play("collected")
	await animations.animation_finished
	is_collected.emit()
	queue_free()
