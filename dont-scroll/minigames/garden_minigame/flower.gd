extends TextureRect

signal fully_bar

@export var progress_bar: ProgressBar
@export var shake_sensi: float = 10.0
@export var bar_filling: float = 0.2

var mouse_in: bool = false
var full: bool = false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _gui_input(event: InputEvent) -> void:
	if full:
		return

	if mouse_in and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if event is InputEventMouseMotion:
			var mouse_movement = event.relative.length()
			if mouse_movement > shake_sensi:
				progress_bar.value += mouse_movement * bar_filling
				GameManager.bem_reduce(mouse_movement * 0.02)
				if progress_bar.value >= progress_bar.max_value:
					full = true
					fully_bar.emit()
					modulate = Color(0.5, 1, 0.5)

func _on_mouse_entered() -> void:
	mouse_in = true

func _on_mouse_exited() -> void:
	mouse_in = false
