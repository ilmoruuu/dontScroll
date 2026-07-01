extends Control

@onready var music_slider = $MusicSlider
@onready var sfx_slider = $EffectSlider
@onready var music_label = $LabelMusica
@onready var sfx_label = $LabelEfeitos
@onready var btn_tutorial = $ButtonTutorial
@onready var btn_creditos = $ButtonCredits
@onready var btn_voltar = $ButtonVoltar

var items = []
var selected = 0
var music_bus_idx: int
var sfx_bus_idx: int

const SLIDER_STEP = 0.05
const MUSIC_LABEL_TEXT = "VOLUME DA MÚSICA:"
const SFX_LABEL_TEXT = "VOLUME DOS EFEITOS:"
const COLOR_SELECTED = Color(1, 1, 1)
const COLOR_UNSELECTED = Color(0.6, 0.6, 0.6)

const REPEAT_DELAY = 0.4   # tempo segurando antes de começar a repetir
const REPEAT_RATE = 0.06   # intervalo entre repetições
var repeat_timer = 0.0
var repeat_direction = 0

func _ready() -> void:
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("SFX")

	for item in [music_slider, sfx_slider, btn_tutorial, btn_creditos, btn_voltar]:
		item.focus_mode = Control.FOCUS_NONE

	music_slider.min_value = 0.0
	music_slider.max_value = 1.0
	music_slider.step = 0.01
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_idx))

	sfx_slider.min_value = 0.0
	sfx_slider.max_value = 1.0
	sfx_slider.step = 0.01
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_idx))

	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	btn_tutorial.pressed.connect(_on_tutorial)
	btn_creditos.pressed.connect(_on_creditos)
	btn_voltar.pressed.connect(_on_voltar)

	items = [music_slider, sfx_slider, btn_tutorial, btn_creditos, btn_voltar]
	update_selection()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		selected = (selected + 1) % items.size()
		update_selection()
	elif event.is_action_pressed("ui_up"):
		selected = (selected - 1 + items.size()) % items.size()
		update_selection()
	elif event.is_action_pressed("ui_left"):
		_adjust_slider(-SLIDER_STEP)
		repeat_direction = -1
		repeat_timer = 0.0
	elif event.is_action_pressed("ui_right"):
		_adjust_slider(SLIDER_STEP)
		repeat_direction = 1
		repeat_timer = 0.0
	elif event.is_action_released("ui_left") or event.is_action_released("ui_right"):
		repeat_direction = 0
	elif event.is_action_pressed("ui_accept"):
		var current = items[selected]
		if current is Button:
			current.emit_signal("pressed")

func _process(delta: float) -> void:
	if repeat_direction == 0:
		return
	repeat_timer += delta
	if repeat_timer >= REPEAT_DELAY:
		# depois do delay inicial, repete no ritmo definido
		var overflow = repeat_timer - REPEAT_DELAY
		if overflow >= REPEAT_RATE:
			repeat_timer -= REPEAT_RATE
			_adjust_slider(SLIDER_STEP * repeat_direction)

func _adjust_slider(delta: float) -> void:
	var current = items[selected]
	if current is HSlider:
		current.value = clamp(current.value + delta, current.min_value, current.max_value)

func update_selection() -> void:
	music_label.text = ("▶ " if selected == 0 else "  ") + MUSIC_LABEL_TEXT
	sfx_label.text = ("▶ " if selected == 1 else "  ") + SFX_LABEL_TEXT
	btn_tutorial.text = ("▶ " if selected == 2 else "  ") + "TUTORIAL"
	btn_creditos.text = ("▶ " if selected == 3 else "  ") + "CRÉDITOS"
	btn_voltar.text = ("▶ " if selected == 4 else "  ") + "VOLTAR"

	music_slider.modulate = COLOR_SELECTED if selected == 0 else COLOR_UNSELECTED
	sfx_slider.modulate = COLOR_SELECTED if selected == 1 else COLOR_UNSELECTED

func _on_music_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db(value))

func _on_sfx_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_idx, linear_to_db(value))

func _on_tutorial() -> void:
	#get_tree().change_scene_to_file("res://scenes/ui/tutorial.tscn")  # ajusta pro caminho certo
	pass

func _on_creditos() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/credits.tscn")

func _on_voltar() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
