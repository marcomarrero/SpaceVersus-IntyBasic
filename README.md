# SpaceVersus-IntyBasic
Space Versus game, 2nd place of Intellivision Programming competition at AtariAge

Game is programmed in IntyBasic, and after the competition, I added a small assembly routine to slant enemy sprites instead of pre-drawing them in ROM.

The code is not modular, I was not sure how much horsepower an underclocked CP1610 CPU has. (It's slow). For example, 2nd player code is a copy of 1st player code (instead of using same code and inverting Y).

It heavily uses sprites, but does not take advantage of background cards. 
