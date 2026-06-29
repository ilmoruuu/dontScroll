extends CharacterBody2D


@export var speed := 40.0
@export var gravity := 900.0


var direction := 1


@onready var floor_check = $FloorCheck
@onready var wall_check = $WallCheck


func _physics_process(delta):

	velocity.x = 0
	velocity.y = 0

	move_and_slide()


func change_direction():

	direction *= -1


	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.flip_h = direction < 0
