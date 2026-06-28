extends Node2D

@onready var prompt = $Prompt

var player_near = false
var player_ref = null

func _on_area_2d_body_entered(body):
	player_near = true
	player_ref = body
	prompt.visible = true

func _on_area_2d_body_exited(body):
	player_near = false
	player_ref = null
	prompt.visible = false
	
func _process(_delta):
	if player_near and Input.is_action_just_pressed("interact"):
		AudioManager.enter_bench()
		
		player_ref.sit_on_bench(self)
