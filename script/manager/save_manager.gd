extends Node

const SAVE_PATH = "user://save.cfg"
var config := ConfigFile.new()

func _ready() -> void:
	load_data()

func save_data() -> void:
	config.save(SAVE_PATH)

func load_data() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		config.load(SAVE_PATH)

func save_volume(music: float, sfx: float) -> void:
	config.set_value("audio", "music", music)
	config.set_value("audio", "sfx", sfx)
	save_data()

func load_volume() -> Dictionary:
	return {
		"music": config.get_value("audio", "music", 1.0),
		"sfx": config.get_value("audio", "sfx", 1.0)
	}

func save_score(score: int) -> void:
	var scores = load_scores()
	scores.append(score)
	scores.sort()
	scores.reverse()
	# Garde seulement le top 5
	if scores.size() > 5:
		scores.resize(5)
	config.set_value("scores", "top5", scores)
	save_data()

func load_scores() -> Array:
	return config.get_value("scores", "top5", [])
