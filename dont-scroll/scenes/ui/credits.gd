extends Control

@export var scroll_speed := 40.0

@onready var credits = $RichTextLabel

func _ready():
	credits.position.y = get_viewport_rect().size.y

func _process(delta):
	credits.position.y -= scroll_speed * delta

	if credits.position.y + credits.get_content_height() < 0:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") \
	or event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
