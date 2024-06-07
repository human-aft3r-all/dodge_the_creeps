extends Node

var score

func player_hit():
	if multiplayer.multiplayer_peer == null or is_multiplayer_authority():
		game_over.rpc()


func start_button_pressed():
	new_game.rpc()
	

@rpc("any_peer", "call_local")
func game_over():
	var players = $Players.get_children()
	for player in players:
		player.die()
			
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


@rpc("any_peer", "call_local")
func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	
	var players = $Players.get_children()
	for player in players:
		player.start()
	
	$StartTimer.start()
	$HUD/StartButton.hide()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()


func _on_mob_timer_timeout():
	if multiplayer.multiplayer_peer == null or is_multiplayer_authority():
		$MobSpawner.spawn()


func _on_score_timer_timeout():
	if multiplayer.multiplayer_peer == null or is_multiplayer_authority():
		score += 1
		$HUD.update_score.rpc(score)


func _on_start_timer_timeout():
	if is_multiplayer_authority():
		$MobTimer.start()
		$ScoreTimer.start()
