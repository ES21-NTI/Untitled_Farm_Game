extends Node

# All of the different modes
enum FARMING_MODES {SEEDS, HOE, SCYTHE, NONE}

var farmingMode = FARMING_MODES.NONE

var plantSelected = 1

var numOfCarrots = 0
var numOfOnions = 0

# Variables related to the recently dropped item so that the itemDrop script knows what was dropped and how much
var itemDropName
var itemDropCategory
var itemDropQuantity
