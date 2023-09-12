
![Curses Prompt Graphic](curses-graphic.png)

## Initial thoughts:

* Curses – It literally leads directly to the idea of fantasy based game…. Curse(s)is plural, and a curse is a malediction of a non-real nature. Curses can be witchcraft, devils, ghosts, demons, dragons, mages, or anything else magic.
* Bop it / Simon says
* “crumbling location” is lives lost. You have 3 “lives” before the world completely falls apart you restart
* A stack of papers (20)
* some useless, meaningless task
* Rhythm??? Cadence
* hourglass = pressing spacebar flips it
* your start hearing your heartbeat, as you get nervous from failure
* 2D
* “Procedural generation”
* procedurally generated maze (very simple) that you must complete at least once per minute
* Bell ding every minute to mark your progress
* curses have different “reset” timers
* every minute adds 1 new curse
* you have to satisfy all your curses and keep the timer flipping for as long as possible
* There aren’t “levels.” it’s a rogue-lite. You get score based on how far you make it. How many days do you survive.

## Curses
  * Speed typing (deal with the devil)
  * wind a music box
  * complete a procedural maze
  * Trace an image
  * Press the button
  * Flick the switch (an entity that watches. If it is there, light must be on, otherwise it must be off)


2D pixel art (very basic assets)


## Menu heirarchy:

* Initial Loading screen
* Main Menu (Just the desk with the menu overlay on top)
  * Start
    * Instructions (quick infographic picture book on “solving” each curse)
    * Start Game
      * menu fades away… timer fades in, its all on the bottom. Pressing “spacebar” starts the timer and flips the hourglass if they don’t start the timer, they die 
    * pressing “escape” pauses the game and opens another menu
      * Resume game
      * Instructions
      * Options
        * graphic
        * audio
        * accessibility
        * controls
          * Mouse sensitivity
      * Quit to Menu
      * Quit to Desktop
  * Options
  * Graphic
  * Audio
  * Accessibility
  * Controls
    * Mouse sensitivity
  * Quit
  * Leaderboard?

  1. “You failed to address “THE TIMER””

**“THE DESK”**
- (game opens in menu mode)

1 Main 2D scene “the desk”
“Main Menu” control scene (Control Node) (packaged scene)
  * Start button (hides the UI and switches the mode to “Gameplay” mode, which tracks inputs and stuff. Puts text on screen “You have been cursed with menial tasks. Press ‘interact’ Key to begin)
  * Options button TODO: Switch Active GUI
  * Quit Button
“Options” Control scene (Control Node) (packaged scene)
    * Instructions
    * Graphics
      * Resolution
    * audio
      * Master
      * Music
      * Sound Effects
    * controls
    * “Save changes and exit”
“Options” **MID GAMEPLAY** Control scene (Control Node) (packaged scene)
  * Instructions
  * Resume Game
  * Graphics
    * Resolution
  * audio
    * Master
    * Music
    * Sound Effects
  * controls
  * Save changes and exit
  * Exit to Desktop
Gameplay mode (there are no “Control” (read: UI) scenes visible or interactable, and the active curses are visible)
  * pressing ‘open menu’ opens up the options menu and pauses gameplay mode
    * It would need to have “resume game”, “exit to menu”, “exit to desktop”, “instructions”
    * It also NEEDS to show the 3 additional cards for the Godot challenge
“Curse” scene

