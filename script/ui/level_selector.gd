extends Control

@onready var description_label : Label = $"PanelContainer/Control/Level Info/DesciptionLabel"
@onready var choose_label : Label = $"PanelContainer/Control/Label"
@onready var weapon_choice : Control = $"PanelContainer/Control/WeaponChoice"
@onready var btn_gloves : TextureButton = $"PanelContainer/Control/WeaponChoice/BtnGloves"
@onready var btn_canon : TextureButton = $"PanelContainer/Control/WeaponChoice/BtnCanon"
@onready var btn_go : TextureButton = $"PanelContainer/Control/GO"
@onready var btn_tuto : Button = $"PanelContainer/Control/Level Selector/GridContainer/Button3"
@onready var btn_level1 : Button = $"PanelContainer/Control/Level Selector/GridContainer/Button"
@onready var btn_level2 : Button = $"PanelContainer/Control/Level Selector/GridContainer/Button2"
@onready var btn_level3 : Button = $"PanelContainer/Control/Level Selector/GridContainer/Button4"
@onready var btn_level4 : Button = $"PanelContainer/Control/Level Selector/GridContainer/Button5"

var selected_level_data : LevelData = null
var selected_weapon : String = ""

func _ready() -> void:
	weapon_choice.visible = false
	choose_label.visible = false
	btn_go.visible = false
	btn_go.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn_gloves.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn_canon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn_level1.mouse_entered.connect(_on_level1_hover)
	btn_level2.mouse_entered.connect(_on_level2_hover)
	btn_level3.mouse_entered.connect(_on_level3_hover)
	btn_level4.mouse_entered.connect(_on_level4_hover)
	btn_tuto.mouse_entered.connect(_on_tuto_hover)

func _on_level1_hover() -> void:
	var d = load("res://script/Ressources/level1.tres")
	description_label.text = d.level_name + "\n" + d.level_description

func _on_level2_hover() -> void:
	var d = load("res://script/Ressources/level2.tres")
	description_label.text = d.level_name + "\n" + d.level_description

func _on_level3_hover() -> void:
	var d = load("res://script/Ressources/level3.tres")
	description_label.text = d.level_name + "\n" + d.level_description

func _on_level4_hover() -> void:
	var d = load("res://script/Ressources/level_4.tres")
	description_label.text = d.level_name + "\n" + d.level_description

func _on_tuto_hover() -> void:
	description_label.text = "Tutoriel\nApprends les bases du jeu !"

func _select_level(path: String) -> void:
	selected_level_data = load(path)
	weapon_choice.visible = true
	weapon_choice.mouse_filter = Control.MOUSE_FILTER_STOP
	choose_label.visible = true
	btn_go.visible = false
	btn_go.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn_gloves.mouse_filter = Control.MOUSE_FILTER_STOP
	btn_canon.mouse_filter = Control.MOUSE_FILTER_STOP
	selected_weapon = ""

func _on_button_pressed() -> void:
	_select_level("res://script/Ressources/level1.tres")

func _on_button_2_pressed() -> void:
	_select_level("res://script/Ressources/level2.tres")

func _on_button_4_pressed() -> void:
	_select_level("res://script/Ressources/level3.tres")

func _on_button_5_pressed() -> void:
	_select_level("res://script/Ressources/level_4.tres")

func _on_button_3_pressed() -> void:
	GameManager.reset()
	Transition.change_scene("res://scenes/arena/leveltuto.tscn")

func _on_btn_gloves_pressed() -> void:
	selected_weapon = "gloves"
	btn_go.visible = true
	btn_go.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_btn_canon_pressed() -> void:
	selected_weapon = "canon"
	btn_go.visible = true
	btn_go.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_go_pressed() -> void:
	if selected_level_data and selected_weapon != "":
		GameManager.reset()
		GameManager.selected_weapon = selected_weapon
		LevelManager.load_level(selected_level_data)

func _on_back_pressed() -> void:
	Transition.change_scene("res://scenes/ui/main_menu.tscn")
