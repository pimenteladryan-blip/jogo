extends Control
## Menu principal, baseado no mockup de planejamento/menu_mockup.png.

const GAME_SCENE := "res://scenes/main.tscn"

const COLOR_BG := Color(0.0509804, 0.105882, 0.164706, 1.0)
const COLOR_STONE := Color(0.105882, 0.14902, 0.231373, 1.0)
const COLOR_DETAIL := Color(0.254902, 0.352941, 0.466667, 1.0)
const COLOR_LIGHT := Color(0.615686, 0.705882, 0.752941, 1.0)
const COLOR_GOLD := Color(0.878431, 0.643137, 0.345098, 1.0)

@onready var info_panel: Control = $InfoPanel
@onready var info_title: Label = $InfoPanel/Box/Title
@onready var info_text: Label = $InfoPanel/Box/Text


func _ready() -> void:
	GameManager.run_started = false

	$Buttons/Start.pressed.connect(_on_start_pressed)
	$Buttons/Controls.pressed.connect(_show_controls)
	$Buttons/Credits.pressed.connect(_show_credits)
	$Buttons/Quit.pressed.connect(func() -> void: get_tree().quit())
	$InfoPanel/Box/Back.pressed.connect(func() -> void: info_panel.hide())

	info_panel.hide()
	_style_buttons()


func _style_buttons() -> void:
	var buttons: Array[Button] = []
	for child in $Buttons.get_children():
		if child is Button:
			buttons.append(child)
	buttons.append($InfoPanel/Box/Back)
	for button in buttons:
		_style_button(button)


func _style_button(button: Button) -> void:
	button.add_theme_font_size_override("font_size", 10)
	button.add_theme_color_override("font_color", COLOR_LIGHT)
	button.add_theme_color_override("font_hover_color", Color(0.941176, 0.866667, 0.701961, 1))
	button.add_theme_color_override("font_pressed_color", COLOR_BG)
	button.add_theme_color_override("font_focus_color", COLOR_LIGHT)

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(COLOR_STONE.r, COLOR_STONE.g, COLOR_STONE.b, 0.85)
	normal.border_color = COLOR_DETAIL
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(2)
	normal.content_margin_top = 6.0
	normal.content_margin_bottom = 6.0

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color(COLOR_DETAIL.r, COLOR_DETAIL.g, COLOR_DETAIL.b, 0.9)
	hover.border_color = COLOR_GOLD

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = COLOR_GOLD
	pressed.border_color = COLOR_GOLD

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("focus", hover)


func _on_start_pressed() -> void:
	GameManager.reset_run()
	get_tree().change_scene_to_file(GAME_SCENE)


func _show_controls() -> void:
	info_title.text = "CONTROLES"
	info_text.text = (
		"Mover        ← →  ou  A D\n"
		+ "Pular            Espaço  ou  Z\n"
		+ "Pulo duplo   Espaço no ar\n"
		+ "Atacar          J  ou  clique esquerdo\n"
		+ "Dash             Shift  ou  K\n"
		+ "Interagir      E  ou  Enter\n"
		+ "Pausar         Esc  ou  P\n"
		+ "Mapa             M\n"
		+ "Reiniciar      R"
	)
	info_panel.show()


func _show_credits() -> void:
	info_title.text = "CRÉDITOS"
	info_text.text = (
		"Templo de Memórias\n\n"
		+ "Projeto escolar de Adryan Pimentel.\n\n"
		+ "Feito com Godot 4, GDScript, Git e GitHub.\n"
		+ "Inspirado no clima de Hollow Knight, Ori e Celeste."
	)
	info_panel.show()
