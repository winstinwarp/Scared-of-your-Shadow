extends Node2D


func _ready():
	#$Enemies/humanEnemy2.connect("death", _on_human_enemy_death)
	
	$BloodSpurt.emitting=false



func _on_human_enemy_death(enemyposition, playerposition):
	$".".global_position=Vector2(enemyposition.x,enemyposition.y-50)
	if playerposition.x-enemyposition.x<0:
		$".".scale.x=1
	if playerposition.x-enemyposition.x>0:
		$".".scale.x=-1
	$BloodSpurt.emitting=true
