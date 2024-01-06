Elf In The Woods
https://www.youtube.com/watch?v=-O7yI_q6BEA

Project Overview: Elf In the Woods
    The "Elf In the Woods" project is a 2D game created using the Lua-based LÖVE framework. It encompasses various gameplay elements including player movement, collision detection, game states, UI elements, sound effects, and a visual map. The game revolves around an elf character navigating through a forest, seeking hidden spots while encountering obstacles and challenges.

Game Structure and Components:
Game Elements:

    Player Character: Represented by an elf sprite, the player can move in four directions (up, down, left, right) using the keyboard keys (W, A, S, D).
    Game Map: Utilizes a map created with Tiled (.lua file) to define the forest environment. The map includes layers for ground and roads, with specified collision walls for navigation.
    Camera: Controls the view, following the player within the game world and ensuring visibility within the boundaries.
    UI Elements: Various buttons are incorporated for menu interactions, displaying game stats (e.g., FPS, death count), and providing keybinding information in the settings screen.

Game States:

    Menu: Allows players to start or resume the game, access settings, or exit the game.
    Settings: Provides keybinding information and controls for volume adjustment (music control).
    Running: Represents the active gameplay state where the elf explores the forest.
    Ended: Indicates the end of a game session, displaying win or game over screens and allowing replay or returning to the menu.

Game Mechanics:

    Audio: Includes background music and sound effects (e.g., victory sound, game over sound), with the ability to adjust volume using specific key inputs (M, N, <, >).
    Win/Lose Conditions: The elf aims to find hidden spots in the forest (win condition) while avoiding specific death spots (lose condition). Upon winning or losing, the game state changes accordingly, and appropriate actions are triggered, such as sound effects and resetting the player's position.

Technical Details:

    Libraries Used: Utilizes external libraries like Windfield for physics (collision detection), Anim8 for sprite animation, and STI for map loading.
    Code Structure: Organized into functions handling game states, player movement, collision detection, audio control, UI rendering, and updating the game logic.

Button.lua file :

    The Button function is designed to create interactive buttons that can be utilized within the game's user interface (UI). These buttons are meant to respond to mouse clicks, trigger specific actions or functions, and display text or visual cues for the player.

Usage in the Game:
    Integration with Game Logic:
    Within the game's UI or menu states, instances of these Button objects are created to facilitate player interaction.

    Mouse Interaction:
    When the player clicks within the button's boundaries, the associated action or function is executed. For instance, in the game, clicking the "Play" button may trigger the function to start the game or change the game state.

Extensibility and Reusability:

    Customizable Buttons:
    Buttons can be created with varying dimensions, text content, and assigned functions, making them versatile for different parts of the game.

    Reusable Components:
    As a modular object, this button constructor can be reused across different sections of the game UI, ensuring consistency and ease of maintenance.



Events.lua file :

Purpose:

checkGameover Function:
    This function checks whether the player has encountered any of the death spots in the game, indicating a game-over scenario if the player comes within a certain distance of these spots.
checkWin Function:
    On the other hand, the checkWin function evaluates whether the player has reached any of the win spots within the game, signaling a victory condition if the player gets close enough to these locations.

Functionality:

checkGameover Function:
    Iterates through each death spot in the deathspots array using a loop (ipairs).
    Calculates the Euclidean distance between the player's position and each death spot.
    If the distance is less than or equal to the distanceThreshold, it signifies the player's proximity to a death spot, triggering a true return value.
    If no death spot is within the defined threshold, it returns false, indicating that the player is safe from a game-over scenario.
    checkWin Function:
    Similar to checkGameover, this function iterates through each win spot in the winspots array.
    Computes the distance between the player's position and each win spot.
    If the distance falls within the distanceThreshold, it signifies the player's proximity to a win spot, returning true to indicate a victory condition.
    If no win spot is within the defined threshold, it returns false, implying that the player hasn't reached a win spot yet.

Modular Design:

    The code snippet returns an object that contains both functions (checkGameover and checkWin), making them accessible and reusable across different parts of the game logic.

    This modular design allows easy integration of these functions into the game mechanics, enabling the game to continuously check for win or game-over conditions based on the player's position relative to specific spots on the map.

    In summary, these functions serve as essential components of the game's logic, determining whether the player has encountered game-ending situations or achieved victory by being within a certain range of designated spots on the game map.