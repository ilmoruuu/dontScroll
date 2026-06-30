extends CanvasLayer

@onready var cat = $Control/Panel/TextureRect
@onready var progress = $Control/Panel/ProgressBar

var petting := 0.0
var last_mouse := Vector2.ZERO
var current_bench = null

func _ready():
	visible = true
	var current_bench = null

func start(bench):
	current_bench = bench

	visible = true

	petting = 0
	progress.value = 0

	last_mouse = get_viewport().get_mouse_position()

func _process(_delta):

	if !visible:
		return

	var mouse = get_viewport().get_mouse_position()

	# Retângulo ocupado pelo TextureRect
	var rect = Rect2(cat.global_position, cat.size)

	if rect.has_point(mouse):

		var distance = mouse.distance_to(last_mouse)

		if distance > 1:
			petting += distance * 0.03
			petting = clamp(petting, 0.0, 100.0)

			progress.value = petting

			GameManager.bem_reduce(distance * 0.02)

	last_mouse = mouse

	if petting >= 100:
		finish_game()

func finish_game():

	visible = false

	if current_bench:
		current_bench.finish_bench_dialog()

	queue_free()
