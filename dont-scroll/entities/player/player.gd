extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 80.0
const JUMP_VELOCITY = -280.0
const GRAVITY = 600.0
const EXPOSURE_DECAY_ON_BENCH = 3.0

var sitting := false

func _process(delta):
	if sitting:
		GameManager.bem_reduce(EXPOSURE_DECAY_ON_BENCH * delta)
		if Input.is_action_just_pressed("ui_left") \
		or Input.is_action_just_pressed("ui_right") \
		or Input.is_action_just_pressed("ui_accept"):
			stand_up()

func _physics_process(delta: float) -> void:
	if sitting:
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	var speed = SPEED * GameManager.get_player_speed_mult()

	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if is_on_floor():
		if direction > 0:
			animation.flip_h = false
			animation.play("walk")
		elif direction < 0:
			animation.flip_h = true
			animation.play("walk")
		else:
			animation.play("idle")
	else:
		animation.play("jump")

	move_and_slide()

func sit_on_bench(bench):
	sitting = true
	global_position = bench.get_node("SeatPosition").global_position
	velocity = Vector2.ZERO

func stand_up():
	AudioManager.exit_bench()
	sitting = false
	global_position.y -= 8
