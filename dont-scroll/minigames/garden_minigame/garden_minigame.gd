extends CanvasLayer

var current_bench = null
var quantity_fully_flowers: int = 0

@export var normal_cursor: Texture2D
@export var clicking_cursor: Texture2D
@onready var cursor_img = $Control/Panel/especial_mouse
@onready var click_effect = $Control/Panel/Water/AnimatedSprite2D

func _ready():
	$Control/Panel/Flor1.fully_bar.connect(_on_fill_flower)
	$Control/Panel/Flor2.fully_bar.connect(_on_fill_flower)
	$Control/Panel/Flor3.fully_bar.connect(_on_fill_flower)

func start(bench) -> void:
	current_bench = bench
	visible = true
	quantity_fully_flowers = 0
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _process(_delta: float) -> void:
	if not visible:
		return
	
	var posicao_mouse = get_viewport().get_mouse_position()
		
	cursor_img.global_position = posicao_mouse - (cursor_img.size / 2)
	
	var water_position = Vector2(12, 20)
	click_effect.global_position = posicao_mouse + water_position
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		cursor_img.texture = clicking_cursor
	else:
		cursor_img.texture = normal_cursor

func _input(event: InputEvent) -> void:
	if not visible:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		if event.pressed:
			click_effect.show()
			click_effect.play("falling_water")
		
		else:
			click_effect.hide()
			click_effect.stop()

func _on_fill_flower() -> void:
	quantity_fully_flowers += 1
	
	if quantity_fully_flowers >= 3:
		finish_game()

func finish_game() -> void:
	visible = false
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if current_bench:
		current_bench.finish_bench_dialog()
	
	queue_free()

func resetar_flores() -> void:
	var flor1 = $Control/Panel/Flor1
	flor1.progress_bar.value = 0
	flor1.full = false
	flor1.modulate = Color(1, 1, 1) 
	
	var flor2 = $Control/Panel/Flor2
	flor2.progress_bar.value = 0
	flor2.full = false
	flor2.modulate = Color(1, 1, 1)
	
	var flor3 = $Control/Panel/Flor3
	flor3.progress_bar.value = 0
	flor3.full = false
	flor3.modulate = Color(1, 1, 1)
	
	
