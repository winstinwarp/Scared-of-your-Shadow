extends Node2D

signal pos(checkpointPosition: Vector2)

func _ready():
	#_on_area_2d_body_entered.connect("position")
	pass



func _on_area_2d_body_entered(body):
	if body.name == "Player":
		pos.emit($Area2D.global_position)
		print("checkpoint: ", $Area2D.global_position)
		
