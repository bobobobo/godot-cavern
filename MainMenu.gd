extends Node2D

signal start_game

func _ready():
    $PressSpace.play()

func show():
    visible = true

func _process(_delta):
    if visible && Input.is_action_just_pressed("ui_select"):
        visible = false
        emit_signal("start_game")
