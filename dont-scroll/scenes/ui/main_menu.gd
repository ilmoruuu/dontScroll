extends Control

func _ready() -> void:
	$VBoxContainer/ButtonIniciar.pressed.connect(_on_iniciar)
	$VBoxContainer/ButtonSair.pressed.connect(_on_sair)

func _on_iniciar() -> void:
	get_tree().change_scene_to_file("res://scenes/cutscenes/cutscene_intro.tscn")

func _on_sair() -> void:
	get_tree().quit()
