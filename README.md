# Sorty
Simple, fast and powerful pixel sorter written in processing

### Features
* Live preview of what will be sorted
* GIF support
* Multiple availible comparision modes (Average, luma, hue, saturation, red, blue, green)
* 10 steps undo/redo history for images, 1 step undo/redo history for GIF's
* Working selection tool (not perfect)
* JPG, PNG, TIF, TGA support for images
* Horizontal and vertical sorting modes
* Intuitive user interface

### Images of the sorter:  
[Imgur ling](http://imgur.com/a/TMP3z]

### Installation
Easy way:  
Download ready to use version of Sorty here (You may need to download JAVA to use it): 
	[link](https://mega.nz/#!qUhDUSQA!9POsYbLgDZOqH14x5-hp_zABFRrr8KUQ3g1OsB-VmK0)

Hard way:  
	1.  add ControlP5 (http://www.sojamo.de/libraries/controlP5/) and modified GifAnimation (library folder) libraries to your Processing libraries.  
	2.  Build the launcher( Launcher.pde, startMenu.pde) as .exe.  
	3.  Build the Main program ( All the files in data folder) as .exe.  
	4.  Put compiled Main program along with it's lib and data folders into compiled launcher data folder  
	5.  To start program just start Launcher.exe

### Usage

1. Start launcher.exe and select image, the main program should start right after that.

2. Keybinds:
	*  'O' - undo action
	*  'P' - redo action
	*  'H' - sort horizontally
	*  'V' - sort vertically
	*  'M' - show/hide menu
	*  'R' - reset
3. UI:
	*  lowerLimit - Dictates lower limit of what will be sorted.
	*  upperLimit - Dictates upper limit of what will be sorted.
	*  preview - Shows which areas will be sorted ( white will be sorted, black not ).
	*  checkmode - Decides which areas of the image will be sorted (for example, if lower limit is 0.2, upper limit is 0.8 and checkmode is AVERAGE, only pixels whose average brightness is between 0.2 and 0.8, where 0 is black, and 1 is white, will be sorted).
	*  sortmode - Dictates comparision method used in sort function (for example choosing hue will make sorting function compare hue(pixel1) to hue(pixel2)).
	*  sort horizontally/vertically - Self explanatory.
	*  add/change selection - Add points to the selection.
	*  delete selection - Deletes current selection.
	*  ALL / ALL-SELECTION / SELECTION - Dictates the workspace, so:
		- ALL - Actions (sort, reset) will take place on entire image.
		- ALL-SELECTION - Actions will take place on entire image, excluding selected area
		-  SELECTION - Actions will take place only in selected area
	* reset - Resets the area to the state from right after import. (IT WILL ONLY RESET THE AREA THAT SHOWS AS WHITE ON THE PREVIEW, SET LOWERLIMIT TO 0 AND UPPERLIMIT TO 1 TO RESET EVERYTHING).
	* undo - Undo last action (sort/reset)
	* filename and format - Dictates what will be the filename and format of saved images (IT WILL OVERWRITE A FILE IF IT EXISTS IN THE RESULTS DIRECTORY)
	* save - Saves the image. (The image will be saved in data\Results directory)
	* (Gif only) step back/forward - Steps one frame back/forward.
	* (GIf only) pause - pauses/resumes the Gif.

### Used libraries
- [ControlP5](http://www.sojamo.de/libraries/controlP5/)
- [GifAnimation](https://github.com/01010101/GifAnimation)

### Donate
If you found this tool useful/interesting please consider donating!  
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=XB6XK8FEF9FPA)
