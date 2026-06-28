extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hammer_hitbox = $hammer_hitbox/CollisionShape2D

enum PowerUpState { STANDARD, HAMMER, JUICE, PIJAMA }

const SPEED = 80.0
const JUMP_VELOCITY = -280.0
const GRAVITY = 600.0
const BEM_RATE_ON_PLATFORM = 2.0
const EXPOSURE_DECAY_ON_BENCH = 3

signal exposition_changed(value)

var _exposition := 0.0
var sitting := false
var current_state = PowerUpState.STANDARD
var sufix = ""
var is_using_item = false

var expositon: float:
	get:
		return _exposition
	set(value):
		_exposition = value
		exposition_changed.emit()

func _process(delta):

	if sitting:
		expositon = max(0.0, expositon - EXPOSURE_DECAY_ON_BENCH * delta)
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
	
	if Input.is_action_just_pressed("use_item"):
		use_item()

	var direction = Input.get_axis("ui_left", "ui_right")
	var speed = SPEED * GameManager.get_player_speed_mult()
	
	if is_using_item and current_state != PowerUpState.HAMMER:
		velocity.x = move_toward(velocity.x, 0, speed)
	elif direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if not is_using_item:
		if is_on_floor():
			if direction > 0:
				animation.flip_h = false
				animation.play("walk" + sufix)
			elif direction < 0:
				animation.flip_h = true
				animation.play("walk" + sufix)
			else:
				animation.play("idle" + sufix)
		else:
			animation.play("jump" + sufix)

	move_and_slide()

	if is_on_floor():
		var collision = get_last_slide_collision()

		if collision:
			var collider = collision.get_collider()

			if collider.is_in_group("platform"):
				GameManager.bem_add(BEM_RATE_ON_PLATFORM * delta)
				expositon += BEM_RATE_ON_PLATFORM * delta
				print(expositon)

func sit_on_bench(bench):
	sitting = true

	global_position = bench.get_node("SeatPosition").global_position

	velocity = Vector2.ZERO

func use_item():
	if is_using_item:
		return
	
	is_using_item = true
	
	match current_state:
		PowerUpState.STANDARD:
			is_using_item = false
		PowerUpState.HAMMER:
			animation.play("attack_hammer")
			hammer_hitbox.set_deferred("disabled", false)
		PowerUpState.JUICE:
			animation.play("drink_juice")
			await get_tree().create_timer(0.5).timeout
			is_using_item = false
			alter_state(PowerUpState.STANDARD)
		PowerUpState.PIJAMA:
			animation.play("use_pijama")
			await get_tree().create_timer(0.5).timeout
			is_using_item = false
			alter_state(PowerUpState.STANDARD)

func alter_state(new_state: PowerUpState):
	current_state = new_state
	match current_state:
		PowerUpState.STANDARD:
			sufix = ""
		PowerUpState.HAMMER:
			sufix = "_hammer"
		PowerUpState.JUICE:
			sufix = "_juice"
		PowerUpState.PIJAMA:
			sufix = "_pijama"

func stand_up():
	AudioManager.exit_bench()
	sitting = false
	global_position.y -= 8

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "attack_hammer":
		is_using_item = false
		hammer_hitbox.set_deferred("disabled", true)
