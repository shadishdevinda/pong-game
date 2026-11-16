extends CharacterBody2D

@export var start_speed: float = 400.0
@export var speed_increase: float = 1.05   # paddle එකේ වදින හැම පාරම 5%ක් වේගවත් වෙනවා
@export var max_speed: float = 1000.0

@onready var hit_sound = $HitSound
@onready var wall_sound = $WallSound

var speed: float
var start_position: Vector2 

func _ready():
	start_position = position   # ← editor එකේ තිබ්බ තැන මතක තියාගන්නවා

func reset_ball():
	position = start_position   # ← get_viewport_rect().size / 2 වෙනුවට
	velocity = Vector2.ZERO
	speed = start_speed

	await get_tree().create_timer(1.0).timeout

	var dir_x = [-1, 1].pick_random()
	var dir_y = randf_range(-0.7, 0.7)
	velocity = Vector2(dir_x, dir_y).normalized() * speed

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)

	if collision:
		var collider = collision.get_collider()
		# බිත්තියක හරි paddle එකක හරි වැදුනම bounce වෙනවා
		velocity = velocity.bounce(collision.get_normal())

		if collider.is_in_group("paddle"):
			hit_sound.play()   # paddle sound එක
			speed = min(speed * speed_increase, max_speed)
			# Paddle එකේ කොතනද වැදුනේ කියන එක අනුව angle එක වෙනස් වෙනවා
			var offset = (position.y - collider.position.y) / 50.0
			velocity = Vector2(sign(velocity.x), offset).normalized() * speed
		else:
			wall_sound.play()  # බිත්ති sound එක
