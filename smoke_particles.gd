extends Node2D


func _ready():
	$SmokeCloud.emitting=false
	$SmokeTrail.emitting=false
	$SmokeCloud.speed_scale=1

func _on_player_particles(playerposition, dashposition):
	$".".global_position=playerposition
	if dashposition.x-playerposition.x>0:
		$".".scale.x=1
	if dashposition.x-playerposition.x<0:
		$".".scale.x=-1
	if dashposition.x-playerposition.x==0:
		$SmokeCloud.speed_scale=.25
	$SmokeTrail.emitting=true
	$SmokeCloud.emitting=true
