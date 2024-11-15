extends Label

var score = 0
var score_template = "Score: %s"

func on_mob_squashed():
	score += 1
	text = score_template % score