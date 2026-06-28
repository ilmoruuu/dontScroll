extends PUBase

func _apply_effect(body):
	if body.has_method("alter_state"):
		body.alter_state(body.PowerUpState.PIJAMA)
		print("o jogador pegou o pijama")
