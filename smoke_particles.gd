extends Node2D




func _on_player_particles(playerposition):
	$".".global_position=playerposition
	$CPUParticles2D.emitting=true
	print(playerposition)
