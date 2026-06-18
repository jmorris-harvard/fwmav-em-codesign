from OCC.Core.STEPControl import STEPControl_Reader
from OCC.Display.SimpleGui import init_display

def show (filename):
	display, startDisplay, addMenu, addFunctionToMenu = init_display ()

	stepReader = STEPControl_Reader ()
	stepReader.ReadFile (filename)
	stepReader.TransferRoots ()
	
	shape = stepReader.Shape ()

	display.DisplayShape (shape, update = True)
	startDisplay ()
