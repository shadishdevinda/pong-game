extends CharacterBody2D

@export var speed: float = 500.0
@export var up_action: String = "p1_up"
@export var down_action: String = "p1_down"

var start_x: float

func _ready():
	motion_mode = MOTION_MODE_FLOATING  # gravity නැති, උඩ-යට විතරක් යන movement
	start_x = position.x

func _physics_process(delta):
	# Up ඔබනකොට -1, Down ඔබනකොට +1, මුකුත් නැත්නම් 0
	var direction = Input.get_axis(up_action, down_action)
	velocity = Vector2(0, direction * speed)
	move_and_slide()

	# Paddle එක screen එකෙන් එළියට යන එක නවත්වන්න
	var screen_height = get_viewport_rect().size.y
	position.y = clamp(position.y, 50, screen_height - 50)
	position.x = start_x  # පැත්තට යන්න දෙන්නේ නැහැ
