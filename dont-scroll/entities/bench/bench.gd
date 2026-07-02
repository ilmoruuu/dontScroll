extends Node2D

@onready var prompt = $Prompt

var player_near = false
var player_ref = null
var dialog = false

## Create functions from minigames here fellas! 
func start_cat_minigame():
	var scene = preload("res://minigames/cat_minigame/CatMinigame.tscn")
	var game = scene.instantiate()

	get_tree().current_scene.add_child(game)

	game.start(self)
	
func start_garden_minigame():
	var scene = preload("res://minigames/garden_minigame/garden_minigame.tscn")
	var game = scene.instantiate()
	
	get_tree().current_scene.add_child(game)
	game.start(self)
	
func _on_area_2d_body_entered(body):
	player_near = true
	player_ref = body
	prompt.visible = true

func _on_area_2d_body_exited(_body):
	player_near = false
	player_ref = null
	prompt.visible = false
	
func _process(_delta):
	if player_near and not dialog and Input.is_action_just_pressed("interact"):
		start_bench_dialog()

func start_bench_dialog():
	dialog = true
	prompt.visible = false

	AudioManager.enter_bench()
	
	var randon = randf()
	
	if randon <= 0.25:
		start_cat_minigame()
	elif randon > 0.25 and randon <= 0.5:
		start_garden_minigame()
	else:
		BenchDialogueUI.start_random_event(self)

	if player_ref and player_ref.has_method("sit_on_bench"):
		player_ref.sit_on_bench(self)

func finish_bench_dialog():
	dialog = false
	if player_near:
		prompt.visible = true
	
	if player_ref and player_ref.has_method("end_dialog"):
		player_ref.end_dialog()
