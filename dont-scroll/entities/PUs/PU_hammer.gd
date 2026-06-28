extends PUBase

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("alter_state"):
		body.alter_state(body.PowerUpState.HAMMER)
		print("o jogador pegou o martelo")
		
