extends Node

# ── BEM (Barra de Exposição Mental) ──────────────────
var bem: float = 0.0
var bem_max: float = 100.0
var bem_rate: float = 0.5
var player_on_bench: bool = false

# ── Estado do jogador ─────────────────────────────────
var player_speed_mult: float = 1.0
var is_crashed: bool = false
var crash_timer: float = 0.0
var crash_limit: float = 5.0

# ── Progresso do jogo ─────────────────────────────────
var current_phase: int = 1
var checkpoint_scene: String = "res://scenes/levels/fase1.tscn"
var inventory: Array = []

func _process(delta: float) -> void:
	if not player_on_bench:
		bem = clamp(bem + bem_rate * delta, 0.0, bem_max)
	
	_update_speed_mult()
	_check_crash(delta)

func _update_speed_mult() -> void:
	if bem < 50.0:
		player_speed_mult = 1.0
	elif bem < 75.0:
		player_speed_mult = 0.9
	else:
		player_speed_mult = 0.8

func _check_crash(delta: float) -> void:
	if bem >= bem_max and not is_crashed:
		is_crashed = true
		crash_timer = 0.0
	
	if is_crashed:
		crash_timer += delta
		if crash_timer >= crash_limit:
			game_over()
		if bem < bem_max - 10.0:
			is_crashed = false
			crash_timer = 0.0

func bem_add(amount: float) -> void:
	bem = clamp(bem + amount, 0.0, bem_max)

func bem_reduce(amount: float) -> void:
	bem = clamp(bem - amount, 0.0, bem_max)
	if is_crashed and bem < bem_max - 10.0:
		is_crashed = false
		crash_timer = 0.0

func get_bem_level() -> int:
	if bem < 25.0: return 0  # tranquilo
	if bem < 50.0: return 1  # agitado
	if bem < 75.0: return 2  # ansioso
	return 3                  # sobrecarregado

func game_over() -> void:
	bem = 60.0
	is_crashed = false
	inventory.clear()
	get_tree().change_scene_to_file(checkpoint_scene)
