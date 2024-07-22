extends Camera2D

var decay = 0.560  # How quickly the shaking stops [0, 1].
var max_offset = Vector2(70, 45)  # Maximum hor/ver shake in pixels.
var max_roll = 0.05  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

func _ready():
	randomize()
	
func _process(delta):
	if trauma:
		trauma=max(trauma-decay*delta, 0)
		shake()

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)

func _on_player_add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
