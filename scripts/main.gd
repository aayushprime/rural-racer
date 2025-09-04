extends Control

func _ready():
    $PlayButton.pressed.connect(func():
        get_tree().change_scene_to_file("res://game.tscn")
    )
