extends Node2D

var time_options = [1, 3, 5, 10, 15, 20]   # තෝරන්න පුළුවන් විනාඩි ගණන්
var selected_index = 3                     # Default එක: time_options[3] = විනාඩි 10

var score_left = 0
var score_right = 0
var state = "menu"   # "menu", "playing", "over" කියන තත්ත්ව තුනෙන් එකක්

@onready var ball = $Ball
@onready var score_left_label = $ScoreLeft
@onready var score_right_label = $ScoreRight
@onready var score_sound = $ScoreSound
@onready var game_timer = $GameTimer
@onready var timer_label = $TimerLabel
@onready var menu_overlay = $MenuOverlay
@onready var win_label = $WinLabel

func _ready():
	game_timer.timeout.connect(_on_game_timer_timeout)
	show_menu()

# ---------- Menu ----------

func show_menu():
	state = "menu"
	game_timer.stop()

	# Ball එක මැදට ගෙනල්ලා නවත්වනවා
	ball.set_physics_process(false)
	ball.velocity = Vector2.ZERO
	ball.position = ball.start_position

	score_left = 0
	score_right = 0
	update_score()

	update_menu_text()
	win_label.show()
	menu_overlay.show() 

func update_menu_text():
	var minutes = time_options[selected_index]
	win_label.text = "Game Time: < %d min >\nUse Left / Right to change\nPress Enter to Start" % minutes
	timer_label.text = "%02d:00" % minutes

# ---------- Game ----------

func start_game():
	state = "playing"
	win_label.hide()
	menu_overlay.hide()
	game_timer.start(time_options[selected_index] * 60)   # විනාඩි → තත්පර
	ball.set_physics_process(true)
	ball.reset_ball()

func _process(delta):
	if state == "playing":
		var t = int(ceil(game_timer.time_left))
		timer_label.text = "%02d:%02d" % [t / 60, t % 60]

func _unhandled_input(event):
	if state == "menu":
		if event.is_action_pressed("ui_right"):
			# ඊළඟ කාලයට (අන්තිම එකෙන් එහාට යන්නේ නැහැ)
			selected_index = min(selected_index + 1, time_options.size() - 1)
			update_menu_text()
		elif event.is_action_pressed("ui_left"):
			# කලින් කාලයට (පළවෙනි එකෙන් මෙහාට යන්නේ නැහැ)
			selected_index = max(selected_index - 1, 0)
			update_menu_text()
		elif event.is_action_pressed("ui_accept"):
			start_game()

	elif state == "over":
		if event.is_action_pressed("ui_accept"):
			show_menu()

func update_score():
	score_left_label.text = str(score_left)
	score_right_label.text = str(score_right)

func _on_game_timer_timeout():
	state = "over"
	timer_label.text = "00:00"

	ball.velocity = Vector2.ZERO
	ball.set_physics_process(false)

	if score_left > score_right:
		win_label.text = "Left Player Wins!"
	elif score_right > score_left:
		win_label.text = "Right Player Wins!"
	else:
		win_label.text = "Draw!"

	win_label.text += "\nPress Enter for menu"
	win_label.show()
	menu_overlay.show()

func _on_left_goal_body_entered(body):
	if body == ball and state == "playing":
		score_right += 1
		update_score()
		score_sound.play()
		ball.reset_ball()

func _on_right_goal_body_entered(body):
	if body == ball and state == "playing":
		score_left += 1
		update_score()
		score_sound.play()
		ball.reset_ball()
