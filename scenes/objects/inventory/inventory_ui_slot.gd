extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer

var itemStackGUI: ItemStackGUI

func insert(isg: ItemStackGUI):
	itemStackGUI = isg
	print("insert")
	# backgroundSprite.visible = true
	container.add_child(itemStackGUI)

func takeItem():
	var item = itemStackGUI
	
	container.remove_child(itemStackGUI)
	itemStackGUI = null
	print("removing")
	
	return item
