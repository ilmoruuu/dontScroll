extends Control

@onready var buttons = [$VBoxContainer/ButtonIniciar, $VBoxContainer/ButtonOpções, $VBoxContainer/ButtonSair]
var selected = 0

func _ready() -> void:
	$VBoxContainer/ButtonIniciar.pressed.connect(_on_iniciar)
	$VBoxContainer/ButtonOpções.pressed.connect(_on_opcoes)
	$VBoxContainer/ButtonSair.pressed.connect(_on_sair)
	update_selection()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		selected = (selected + 1) % buttons.size()
		update_selection()
	elif event.is_action_pressed("ui_up"):
		selected = (selected - 1 + buttons.size()) % buttons.size()
		update_selection()
	elif event.is_action_pressed("ui_accept"):
		buttons[selected].emit_signal("pressed")

func update_selection() -> void:
	for i in buttons.size():
		if i == selected:
			buttons[i].text = "▶ " + get_button_label(i)
		else:
			buttons[i].text = "  " + get_button_label(i)

func get_button_label(i: int) -> String:
	match i:
		0: return "INICIAR"
		1: return "OPÇÕES"
		2: return "SAIR"
	return ""

@onready var crt = $CRTOverlay

var glitch_timer: float = 0.0
var glitch_interval: float = 3.0
var is_glitching: bool = false
var glitch_duration: float = 0.0

func _process(delta: float) -> void:
	glitch_timer += delta
	
	if not is_glitching and glitch_timer >= glitch_interval:
		glitch_timer = 0.0
		glitch_interval = randf_range(2.0, 6.0)
		_trigger_glitch()
	
	if is_glitching:
		glitch_duration -= delta
		if glitch_duration <= 0:
			is_glitching = false
			crt.material.set_shader_parameter("glitch_spike", 0.0)

func _trigger_glitch() -> void:
	is_glitching = true
	glitch_duration = randf_range(0.1, 0.4)
	crt.material.set_shader_parameter("glitch_spike", randf_range(0.5, 1.0))

func _on_iniciar() -> void:
	get_tree().change_scene_to_file("res://scenes/cutscenes/cutscene_intro.tscn")

func _on_opcoes() -> void:
	pass

func _on_sair() -> void:
	get_tree().quit()
