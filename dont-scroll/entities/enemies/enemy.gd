extends CharacterBody2D

@export var speed := 40.0
@export var gravity := 900.0

var direction := 1
var dead := false

@onready var sprite = $AnimatedSprite2D

func _ready():
	add_to_group("enemies")

func _physics_process(delta):
	if dead:
		return

	velocity.x = 0

	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func change_direction():
	direction *= -1
	sprite.flip_h = direction < 0

func take_damage():

	if dead:
		return

	dead = true
	
	GameManager.bem_reduce(20.0)

	velocity = Vector2.ZERO

	await blink_animation()

	queue_free()
	
func blink_animation():
	for i in range(6):
		sprite.visible = false
		await get_tree().create_timer(0.1).timeout
		sprite.visible = true
		await get_tree().create_timer(0.1).timeout
