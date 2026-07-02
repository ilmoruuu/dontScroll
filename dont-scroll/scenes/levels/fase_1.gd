extends Node2D

func _ready() -> void:
	GameManager.resume_bem()

func _exit_tree() -> void:
	GameManager.pause_bem()
