extends Control

@onready var description_label : Label = $"PanelContainer/Control/Level Info/DesciptionLabel"
@onready var weapon_choice : Control = $PanelContainer/Control/WeaponChoice
@onready var choose_label : Label = $PanelContainer/Control/Label  # le label CHOOSE YOUR WEAPON
@onready var btn_go : Button = $PanelContainer/Control/GO
@onready var btn_gloves : Button = $PanelContainer/Control/WeaponChoice/BtnGloves
@onready var btn_canon : Button = $PanelContainer/Control/WeaponChoice/BtnCanon

var selected_level_data : LevelData = null
var selected_weapon : String = ""

func _ready() -> void:
	weapon_choice.visible = false
	choose_label.visible = false
	btn_go.visible = false

func _on_button_pressed() -> void:
	selected_level_data = load("res://script/Ressources/level1.tres")
	weapon_choice.visible = true
	choose_label.visible = true
	btn_go.visible = false
	selected_weapon = ""

func _on_button_2_pressed() -> void:
	selected_level_data = load("res://script/Ressources/level2.tres")
	weapon_choice.visible = true
	choose_label.visible = true
	btn_go.visible = false
	selected_weapon = ""

func _on_btn_gloves_pressed() -> void:
	selected_weapon = "gloves"
	btn_go.visible = true

func _on_btn_canon_pressed() -> void:
	selected_weapon = "canon"
	btn_go.visible = true

func _on_go_pressed() -> void:
	if selected_level_data and selected_weapon != "":
		GameManager.reset()
		# Mémorise l'arme choisie pour le joueur
		GameManager.selected_weapon = selected_weapon
		LevelManager.load_level(selected_level_data)

func _on_back_pressed() -> void:
	Transition.change_scene("res://scenes/ui/main_menu.tscn")
