extends Node2D

@export_file("*.tscn") var next_scene: String

@onready var prompt = $Prompt

var player_near := false
var changing_scene := false

func _ready():
	prompt.visible = false

func _process(_delta):
	if player_near \
	and not changing_scene \
	and Input.is_action_just_pressed("interact"):
		change_scene()

func change_scene():
	changing_scene = true
	prompt.visible = false

	AudioManager.enter_door()

	if next_scene != "":
		get_tree().change_scene_to_file(next_scene)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_near = true
		prompt.visible = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_near = false
		prompt.visible = false
