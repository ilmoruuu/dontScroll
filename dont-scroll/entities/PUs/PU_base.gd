extends Node2D

class_name PUBase

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.name == "Player":
		_apply_effect(body)
		queue_free()

func _apply_effect(body):
	pass
