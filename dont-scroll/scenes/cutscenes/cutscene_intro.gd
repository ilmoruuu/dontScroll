extends CanvasLayer

const SLIDES = [
	["res://assets/slide1.jpg", "", 2.0],
	["res://assets/slide2.jpg", "", 2.0],
	["res://assets/slide3.jpg", "", 2.0],
	["res://assets/slide4.jpg", "", 2.0],
]

var current_slide: int = 0
var slide_timer: float = 0.0
var transitioning: bool = false

@onready var slide_image = $SlideImage
@onready var slide_text = $SlideText
@onready var overlay = $Overlay

func _ready() -> void:
	overlay.modulate.a = 1.0
	show_slide(0)

func _process(delta: float) -> void:
	if transitioning:
		return
	slide_timer -= delta
	if slide_timer <= 0:
		next_slide()

func show_slide(index: int) -> void:
	# Carrega imagem se tiver caminho
	var image_path = SLIDES[index][0]
	if image_path != "":
		slide_image.texture = load(image_path)
	else:
		slide_image.texture = null
		
	slide_text.text = SLIDES[index][1]
	slide_timer = SLIDES[index][2]
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 0.0, 0.4)
	tween.tween_callback(func(): transitioning = false)

func next_slide() -> void:
	transitioning = true
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, 0.4)
	tween.tween_callback(func():
		current_slide += 1
		if current_slide >= SLIDES.size():
			finish_cutscene()
		else:
			show_slide(current_slide)
	)

func finish_cutscene() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/levels/fase1.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if not transitioning:
			slide_timer = 0.0
