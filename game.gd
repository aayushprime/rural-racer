extends Node2D


func _ready():
    $CanvasLayer.visible = false
    $UI.visible = false
    play_start_animation()
    $UI/ExitButton.pressed.connect(func():
        get_tree().change_scene_to_file("res://main.tscn")
    )
    $CanvasLayer/GoBackButton.pressed.connect(func():
        get_tree().change_scene_to_file("res://main.tscn")
    )
    setup_race_progress_detection()

func play_start_animation():
    $CanvasLayer.visible = true
    $CanvasLayer/Label.text = "Ready!"
    $CanvasLayer/GoBackButton.visible = false
    await get_tree().create_timer(1.0).timeout
    $CanvasLayer/Label.text = "Set"
    await get_tree().create_timer(1.0).timeout
    $CanvasLayer/Label.text = "Go!"

    await get_tree().create_timer(1.0).timeout

    $Car1.active = true
    $Car2.active = true

    $CanvasLayer.visible = false
    $UI.visible = true
    await get_tree().create_timer(1.0).timeout

var totalLaps = 3
var playerOneLaps = 0
var playerTwoLaps = 0

func setup_race_progress_detection():
    var start = $StartLine
    var middle = $MiddleLine

    start.body_entered.connect(func(body):
        if body == $Car1:
            if $Car1.has_passed_middle:
                playerOneLaps += 1
                $UI/Player1/Laps.text = "%d/%d" % [playerOneLaps, totalLaps]
                $Car1.has_passed_middle = false
                check_for_winner()
        elif body == $Car2:
            if $Car2.has_passed_middle:
                playerTwoLaps += 1
                $UI/Player2/Laps.text = "%d/%d" % [playerTwoLaps, totalLaps]
                $Car2.has_passed_middle = false
                check_for_winner()
    )

    middle.body_entered.connect(func(body):
        if body == $Car1:
            $Car1.has_passed_middle = true
        elif body == $Car2:
            $Car2.has_passed_middle = true
    )


func check_for_winner():
    if playerOneLaps >= totalLaps:
        declare_winner("Player 1")
    elif playerTwoLaps >= totalLaps:
        declare_winner("Player 2")

func declare_winner(winner: String):
    $Car1.active = false
    $Car2.active = false
    $CanvasLayer.visible = true
    $CanvasLayer/Label.text = "%s Wins!" % winner
    $CanvasLayer/GoBackButton.visible = true
    $UI.visible = false
