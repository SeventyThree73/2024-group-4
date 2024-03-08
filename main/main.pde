Pacman myPacman;
GameMap gameMap;
Ghost ghost1;
//Ghost ghost2;
int cellSize = 40;

void setup() {
  size(400, 240);
  gameMap = new GameMap(cellSize); // Assuming each cell is 40 pixels
  myPacman = new Pacman(1, 1, gameMap); // Pacman starts at grid position (1, 1) and knows about the game map
  ghost1 = new Ghost(8, 4, myPacman, gameMap);
  //ghost2 = new Ghost(8, 1, myPacman, gameMap);
}

void draw() {
  background(0);
  gameMap.drawMap();
  myPacman.drawPacman();
  ghost1.drawGhost();
  //ghost2.drawGhost();
}

void keyPressed() {
  // Update Pacman's direction and attempt to move
    if (keyCode == UP) {
      myPacman.move(0, -1);
    } else if (keyCode == DOWN) {
      myPacman.move(0, 1);
    } else if (keyCode == LEFT) {
      myPacman.move(-1, 0);
    } else if (keyCode == RIGHT) {
      myPacman.move(1, 0);
    }
}  

void mouseClicked() {
  int gridX = mouseX / cellSize;
  int gridY = mouseY / cellSize;
  
  if (gridX >= 0 && gridX < 400/cellSize && gridY >= 0 && gridY < 240/cellSize) {
    println(gridX, gridY);
      gameMap.setWall(gridX, gridY); 
  }
}
