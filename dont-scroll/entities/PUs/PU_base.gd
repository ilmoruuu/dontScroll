extends Area2D

class_name PUBase

func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_body_entered(body):
	if body.name == "Player":
		_apply_effect(body)
		queue_free()

func _apply_effect(body):
	pass
