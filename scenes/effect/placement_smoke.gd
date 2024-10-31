extends Node2D

@onready var particle1 : GPUParticles2D = $GPUParticles2D
@onready var particle2 : GPUParticles2D = $GPUParticles2D2

func emit_smoke() -> void:
	particle1.emitting = true
	particle2.emitting = true
