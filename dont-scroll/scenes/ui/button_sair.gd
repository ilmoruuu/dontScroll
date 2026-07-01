extends Control

@onready var music_slider = $VBoxContainer/MusicSlider
@onready var btn_creditos = $VBoxContainer/ButtonCreditos
@onready var btn_voltar = $VBoxContainer/ButtonVoltar

func _ready() -> void:
	music_slider.min_value = 0.0
	music_slider.max_value = 1.0
	music_slider.step = 0.01
	music_slider.value = AudioManager.main_music.volume_db / 20.0 + 1.0
	
	music_slider.value_changed.connect(_on_music_slider_changed)
	btn_creditos.pressed.connect(_on_creditos)
	btn_voltar.pressed.connect(_on_voltar)

func _on_music_slider_changed(value: float) -> void:
	AudioManager.main_music.volume_db = lerp(-20.0, 0.0, value)

func _on_creditos() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/credits.tscn")

func _on_voltar() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
