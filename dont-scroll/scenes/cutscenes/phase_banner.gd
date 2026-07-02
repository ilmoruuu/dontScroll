extends CanvasLayer

@onready var container: Control = $Container
@onready var title_label: Label = $Container/TitleLabel
@onready var subtitle_label: Label = $Container/SubtitleLabel
@onready var fade_rect: ColorRect = $FadeRect

var phase_data = {
	1: {"name": "DOPAMINE SCROLLING", "subtitle": "fase 1 e algo a dizer"},
	2: {"name": "DEEPSCROLLING", "subtitle": "fase 2 e bla bla bla"},
	3: {"name": "DOWNSCROLLING", "subtitle": "não existe chão, só mais um pouco"},
	4: {"name": "PRODUCTIVE SCROLLING", "subtitle": "ocupado o suficiente pra não perguntar por quê"},
}

const FADE_IN_TIME = 0.8
const HOLD_TIME = 2.0
const FADE_OUT_TIME = 0.8
const SCENE_FADE_TIME = 0.6

var current_tween: Tween

func _ready() -> void:
	layer = 100
	container.modulate.a = 0.0
	fade_rect.color.a = 0.0
	GameManager.phase_changed.connect(_on_phase_changed)

func _on_phase_changed(new_phase: int) -> void:
	if not phase_data.has(new_phase):
		return
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	var data = phase_data[new_phase]
	title_label.text = data["name"]
	subtitle_label.text = data["subtitle"]
	await _play_banner()
	GameManager.unlock_bem()

func _play_banner() -> void:
	container.modulate.a = 0.0
	current_tween = create_tween()
	current_tween.tween_property(container, "modulate:a", 1.0, FADE_IN_TIME)
	current_tween.tween_interval(HOLD_TIME)
	current_tween.tween_property(container, "modulate:a", 0.0, FADE_OUT_TIME)
	await current_tween.finished

func change_scene(path: String) -> void:
	var tween_in = create_tween()
	tween_in.tween_property(fade_rect, "color:a", 1.0, SCENE_FADE_TIME)
	await tween_in.finished
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	var tween_out = create_tween()
	tween_out.tween_property(fade_rect, "color:a", 0.0, SCENE_FADE_TIME)
	await tween_out.finished
	
func hide_banner_immediately() -> void:
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	container.modulate.a = 0.0

func transition_to_phase(new_phase: int, path: String) -> void:
	hide_banner_immediately()
	var tween_in = create_tween()
	tween_in.tween_property(fade_rect, "color:a", 1.0, SCENE_FADE_TIME)
	await tween_in.finished
	get_tree().change_scene_to_file(path)
	GameManager.set_phase(new_phase)
	await get_tree().process_frame
	var tween_out = create_tween()
	tween_out.tween_property(fade_rect, "color:a", 0.0, SCENE_FADE_TIME)
	await tween_out.finished
	GameManager.announce_phase(new_phase)
