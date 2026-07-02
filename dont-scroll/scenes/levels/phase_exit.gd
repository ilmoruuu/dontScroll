extends Area2D

@export var next_phase: int = 2
@export var next_scene: String = "res://scenes/levels/fase2.tscn"

var triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if triggered:
		return
	if body.is_in_group("player"):
		triggered = true
		call_deferred("_start_transition")

func _start_transition() -> void:
	PhaseBanner.transition_to_phase(next_phase, next_scene)
