
extends Node

var sounds =  {}

func _ready():
    pause_mode = PAUSE_MODE_PROCESS

func add_sound(name, files):
    var streams = []
    for file_name in files:
        var loaded_stream = load(file_name)	
        loaded_stream.set_loop(false)
        streams.append(loaded_stream)
    sounds[name] = streams
    
func play(name):
    if not name in sounds:
        return
    var asp = AudioStreamPlayer.new()
    asp.pause_mode = PAUSE_MODE_PROCESS
    get_parent().add_child(asp)
    asp.stream = sounds[name][randi() % sounds[name].size()]
    asp.play()
    yield(asp, "finished")
    asp.queue_free()
