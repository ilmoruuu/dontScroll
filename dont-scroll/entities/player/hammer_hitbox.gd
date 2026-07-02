extends Area2D

func attack():

	monitoring = true

	for body in get_overlapping_bodies():

		if body.is_in_group("enemies"):
			body.take_damage()

	await get_tree().create_timer(0.2).timeout

	monitoring = false
