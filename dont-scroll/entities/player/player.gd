extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hammer_hitbox = $hammer_hitbox/CollisionShape2D

enum PowerUpState { STANDARD, HAMMER, JUICE, PIJAMA }

const SPEED = 90.0
const JUMP_VELOCITY = -280.0
const GRAVITY = 600.0
const EXPOSURE_DECAY_ON_BENCH = 5.5

var sitting := false
var current_state = PowerUpState.STANDARD
var sufix = ""
var is_using_item = false
var isDialogActive = false

func _process(delta):
	if sitting:
		GameManager.bem_reduce(EXPOSURE_DECAY_ON_BENCH * delta)
		if not isDialogActive and (Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_accept")):
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
		update_animation(direction)
	move_and_slide()

func update_animation(direction: float):
	var bem_suffix = get_bem_suffix()
	if is_on_floor():
		if direction > 0:
			animation.flip_h = false
			animation.play("walk" + bem_suffix + sufix)
		elif direction < 0:
			animation.flip_h = true
			animation.play("walk" + bem_suffix + sufix)
		else:
			animation.play("idle" + bem_suffix + sufix)
	else:
		animation.play("jump" + bem_suffix + sufix)

func sit_on_bench(bench):
	sitting = true
	isDialogActive = true
	global_position = bench.get_node("SeatPosition").global_position
	velocity = Vector2.ZERO

func end_dialog():
	isDialogActive = false

func stand_up():
	if sitting and not isDialogActive:
		AudioManager.exit_bench()
		sitting = false
		global_position.y -= 8

func use_item():
	if is_using_item:
		return
	is_using_item = true
	match current_state:
		PowerUpState.STANDARD:
			is_using_item = false
		PowerUpState.HAMMER:
			animation.play("use_hammer")
			hammer_hitbox.set_deferred("disabled", false)
		PowerUpState.JUICE:
			animation.play("use_juice")
			GameManager.bem_reduce(100.0)
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


func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "use_hammer":
		is_using_item = false
		hammer_hitbox.set_deferred("disabled", true)

func get_bem_suffix() -> String:
	if current_state != PowerUpState.STANDARD:
		return ""

	match GameManager.get_bem_state():
		GameManager.BEMState.ANXIOUS, GameManager.BEMState.OVERLOAD:
			return "_vertigo"
		_:
			return ""
