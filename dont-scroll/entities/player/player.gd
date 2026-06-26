extends CharacterBody2D

const SPEED = 80.0
const JUMP_VELOCITY = -280.0
const GRAVITY = 600.0
const BEM_RATE_ON_PLATFORM = 2.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	var speed = SPEED * GameManager.player_speed_mult

	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

	# BEM sobe continuamente enquanto estiver em cima de plataforma
	if is_on_floor():
		var collision = get_last_slide_collision()
		if collision:
			var collider = collision.get_collider()
			if collider.is_in_group("platform"):
				GameManager.bem_add(BEM_RATE_ON_PLATFORM * delta)
				print("BEM: ", GameManager.bem)
