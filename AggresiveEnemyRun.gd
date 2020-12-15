extends "res://EnemyRun.gd"

var bubble_fire_timer

func fire():
    if (bubble_fire_timer == null || bubble_fire_timer.time_left <= 0) && target.bubbles_in_sight.size() > 0:
        var closest_bubble
        for bubble in target.bubbles_in_sight:
            if bubble != null && (closest_bubble == null || (abs(closest_bubble.position.x - target.position.x) >  abs(bubble.position.x - target.position.x))):
                closest_bubble = bubble

        if closest_bubble != null:
            target.direction = sign(closest_bubble.position.x - target.position.x)
            target.velocity.x = target.direction * target.speed
            set_animation()
            bubble_fire_timer = target.get_tree().create_timer(0.7)
            state_machine.transition("fire")

    else:
        .fire()
