extends Control

@onready var scroll = $ScrollContainer
@onready var btn_voltar = $ButtonVoltar

const SCROLL_SPEED = 30.0

func _ready() -> void:
	btn_voltar.pressed.connect(_on_voltar)
	scroll.scroll_vertical = 0

func _process(delta: float) -> void:
	scroll.scroll_vertical += int(SCROLL_SPEED * delta)
	
	# Quando chegar no fim, para
	var max_scroll = scroll.get_child(0).size.y - scroll.size.y
	if scroll.scroll_vertical >= max_scroll:
		scroll.scroll_vertical = max_scroll

func _on_voltar() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/options.tscn")
