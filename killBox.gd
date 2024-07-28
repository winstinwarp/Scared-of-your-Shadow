extends Node2D

signal kill()

func _ready():
	pass


func _on_kill_area_body_entered(body):
	get_tree().dead_player()
