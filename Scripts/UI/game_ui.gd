extends CanvasLayer

# So, as it stands the current UI has too many jobs. It should merely pass things around

@onready var tablist: PanelContainer = $MarginContainer/TabList
@onready var startup_menu: PanelContainer = $MarginContainer/StartupMenu
@onready var pause_menu: PanelContainer = $MarginContainer/PauseMenu

func _ready():
	add_to_group("game_ui")
	startup_menu.show()
	pause_menu.hide()
	tablist.hide()
	
