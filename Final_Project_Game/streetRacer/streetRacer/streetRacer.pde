import processing.sound.*;

Car car;

boolean upPressed = false;
boolean downPressed = false;
boolean rightPressed = false;
boolean leftPressed = false;

int level = 1;
int car_health = 100;
int array_lane[] = {200, 327, 450, 577, 700}; // x-position for lanes
int new_lane = 0;
int lane_number = ceil(random(4));
int lane_number2 = ceil(random(4))-1;
int lane_number3 = ceil(random(4))-1;
int lane_heart = ceil(random(4));
float carSpeed = 5;
int NPCcounter = 0;

int startingRadius = 30; //the size of an npc

PImage npcPic;
PImage npcPic_2;
PImage npcPic_3;
PImage player;
PImage background;
PImage ferrari;
PImage main_background;
PImage road_sign;
PImage blocks;
PImage powerup_heart;

ArrayList<NPC> npcs;
ArrayList<NPC_2> npcs_2;
ArrayList<NPC_3> npcs_3;
ArrayList<HEART> heart;
PFont font;

// game state variables
int gameState;
public final int INTRO = 1;
public final int PLAY = 2;
public final int PAUSE = 3;
public final int GAMEOVER = 4;
public final int WIN = 5;

SoundFile file;
SoundFile file_2;
SoundFile file_3;
//replace the sample.mp3 with your audio file name here
String audioName = "sample.mp3";
String path;
String crashsound = "crash.mp3";
String crash;
String car_engine = "car_engine.mp3";
String engine;


// moving lanes
int []dvy={0, 150, 300, 450, 600, 750, 900, 1050};

void setup()
{
  // adds sounds
  path = sketchPath(audioName);
  file = new SoundFile(this, path);
  file.loop();
  crash = sketchPath(crashsound);
  file_2 = new SoundFile(this,crash);
  engine = sketchPath(car_engine);
  file_3 = new SoundFile(this, engine);
  
  background(255, 255, 255);
  size(900, 700);


  font = createFont("Cambria", 32); 
  frameRate(60);

  npcPic = loadImage("npc_1.png");
  npcPic_2 = loadImage("npc_2.png");
  npcPic_3 = loadImage("npc_3.png");
  player = loadImage("car.png");
  background = loadImage("background_test.png");
  main_background = loadImage("main_background.jpg");
  road_sign = loadImage("road_sign.png");
  blocks = loadImage("blocks.png");
  powerup_heart = loadImage("powerup_gear.png");

  npcs = new ArrayList<NPC>(0);
  npcs_2 = new ArrayList<NPC_2>(0);
  npcs_3 = new ArrayList<NPC_3>(0);
  heart = new ArrayList<HEART>(0);

  gameState = INTRO;
}


void draw()
{  

  switch(gameState) 
  {
  case INTRO:
    drawScreen("StreetRacer Elite", "There are 10 levels. Press SPACE to start");
    break;
  case PAUSE:
    drawScreen("PAUSED", "Press P to resume");
    break;
  case GAMEOVER:
    drawScreen("GAME OVER", "Press SPACE to try again");
    break;
  case WIN:
    drawScreen("YOU WIN THE GAME", "Press SPACE to try again");
  case PLAY:
    if (lane_number == lane_number2 || lane_number == lane_number3) {
      lane_number = ceil(random(4))-1;
    }
    if (lane_number2 == lane_number3) {
      lane_number2 = ceil(random(4))-1;
    }
    println(NPCcounter);
    for (int i = 2; i <= 10; i++) {
      if (NPCcounter >= (i*5)*(i-1))
      {
        level=i;
      }
    }
    background(background);

    // draw 5 lanes highway moving
    if (gameState==PLAY)
    {
      
      for (int i=0; i<=7; i++) {
        rectMode(CENTER);
        fill(255);
        noStroke();
        rect(260, dvy[i], 10, 100);
        rect(390, dvy[i], 10, 100);
        rect(510, dvy[i], 10, 100);
        rect(640, dvy[i], 10, 100);
        image(blocks, 121, dvy[i]);
        image(blocks, 121, dvy[i]+75);
        image(blocks, 121, dvy[i]+37.5);
        image(blocks, 121, dvy[i]+112.5);
        image(blocks, 758, dvy[i]);
        image(blocks, 758, dvy[i]+75);
        image(blocks, 758, dvy[i]+37.5);
        image(blocks, 758, dvy[i]+112.5);
        if (i == 0 || i == 3)
        image(road_sign, 50, dvy[i]);
        if (i == 1 || i == 5 || i == 7)
        image(road_sign, 800, dvy[i]);
        
      }
      for (int i=0; i<=7; i++) {
        dvy[i]+=carSpeed;
        if (dvy[i]>=1050) {
          dvy[i]=-150;
        }
      }
    }
    car.update();
    car.render(); 

    // check car collision        
    for (int i=0; i<1; i++)//(NPC a : NPCs)
    {
      //npcs.get(i).update();
      //npcs.get(i).render();
      npcs_2.get(i).update();
      npcs_2.get(i).render();
      npcs_3.get(i).update();
      npcs_3.get(i).render();
      heart.get(i).update();
      heart.get(i).render();
    }
    if (car.checkCollision(npcs) || car.checkCollision_2(npcs_2) || car.checkCollision_3(npcs_3))
    {
      car_health -= 20;
      file_2.play();
      //if (car.checkCollision(npcs)) {
      //  newNPC();
      //}
      if (car.checkCollision_2(npcs_2)) {
        newNPC_2();
      }
      if (car.checkCollision_3(npcs_3)) {
        newNPC_3();
      }
      if (car_health <= 0) {
        gameState = GAMEOVER;
      }
    }  
      if (car.checkCollision_heart(heart))
      {
        car_health += 2;
        lane_heart = ceil(random(4));
        newHEART();
      }
    // need to update and renden NPC_2


    float theta = heading2D(car.rotation)+PI/2;    


    if (leftPressed)
    {
      car.acceleration = new PVector(carSpeed, 0);
      rotate2D(car.acceleration, theta);
      
    }

    if (rightPressed)
    {
      car.acceleration = new PVector(-carSpeed, 0);
      rotate2D(car.acceleration, theta);
    }
    if (upPressed)
    {
      car.acceleration = new PVector(0, carSpeed); 
      rotate2D(car.acceleration, theta);
    }    
    if (downPressed)
    {
      car.acceleration = new PVector(0, -carSpeed); 
      rotate2D(car.acceleration, theta);
    }
    break;
  }

  if (gameState==PLAY)
  {
    
    fill(255, 0, 0);
    textSize(25);
    text("LEVEL", (width/11), 100);
    text(level, (width/11), 130);

    fill(255, 0, 0);
    textSize(30);
    //text("HP", (width/11), 500);
    image(powerup_heart, 44, 500, 75, 75);
    fill(255);
    textSize(25);
    text(car_health, 80, 515);
    
    fill(0, 0, 255);
    textSize(25);
    text("PAUSE", 825, 100);
    text("(P)", 830, 130);
  }
}
//void newNPC()
//{
//  npcs = new ArrayList<NPC>();
//  lane_number = ceil(random(4))-1;
//  PVector position = new PVector(array_lane[lane_number], 0);
//  npcs.add(new NPC(position, startingRadius, npcPic));
//  NPCcounter++;
//}

void newNPC_2()
{
  npcs_2 = new ArrayList<NPC_2>();
  new_lane = ceil(random(4));
  PVector position = new PVector(array_lane[new_lane], 0);
  npcs_2.add(new NPC_2(position, startingRadius, npcPic_2));
  NPCcounter++;
}

void newNPC_3()
{
  npcs_3 = new ArrayList<NPC_3>();
  new_lane = ceil(random(4));
  PVector position = new PVector(array_lane[new_lane], 0);
  npcs_3.add(new NPC_3(position, startingRadius, npcPic_3));
  NPCcounter++;
}

void newHEART()
{
  heart = new ArrayList<HEART>();
  new_lane = ceil(random(4));
  PVector position = new PVector(array_lane[new_lane], 0);
  heart.add(new HEART(position, startingRadius, powerup_heart));
}

void initializeGame() 
{
  file_3.loop();
  car_health = 100;
  NPCcounter = 0;
  car  = new Car();
  npcs = new ArrayList<NPC>();
  npcs_2 = new ArrayList<NPC_2>();
  npcs_3 = new ArrayList<NPC_3>();
  heart = new ArrayList<HEART>();

  //PVector position = new PVector(array_lane[ceil(random(4))-1], 0);      
  //npcs.add(new NPC(position, startingRadius, npcPic));  
  PVector position_2 = new PVector(array_lane[ceil(random(4))-1], 0);
  npcs_2.add(new NPC_2(position_2, startingRadius, npcPic_2));
  PVector position_3 = new PVector(array_lane[ceil(random(4))-1], 0);
  npcs_3.add(new NPC_3(position_3, startingRadius, npcPic_3));
  PVector heart_position = new PVector(array_lane[ceil(random(4))-1], 0);
  heart.add(new HEART(heart_position, startingRadius, powerup_heart));
}

void keyPressed()
{ 
  if (key== ' ' && ( gameState==INTRO || gameState==GAMEOVER )) 
  {
    level = 1;
    initializeGame();  
    gameState=PLAY;

  }


  if (key=='p' && gameState==PLAY)
    gameState=PAUSE;
  else if (key=='p' && gameState==PAUSE)
    gameState=PLAY;




  if (key==CODED && gameState == PLAY)
  {         
    if (keyCode==UP) 
      upPressed=true;
    else if (keyCode==DOWN)
      downPressed=true;
    else if (keyCode == LEFT)
      leftPressed = true;  
    else if (keyCode==RIGHT)
      rightPressed = true;
  }


  if (level == 11)
  {
    gameState = WIN;
  }

  if (key== ' ' && ( gameState==INTRO || gameState==GAMEOVER )) 
  {
    level = 1;
    initializeGame();  
    gameState=PLAY;
  }
}


void keyReleased()
{
  if (key==CODED)
  {
    if (keyCode==UP)
    {
      upPressed=false;
      car.acceleration = new PVector(0, 0);
    } else if (keyCode==DOWN)
    {
      downPressed=false;
      car.acceleration = new PVector(0, 0);
    } else if (keyCode==LEFT)
    {
      leftPressed = false; 
      car.acceleration = new PVector(0, 0);
    } else if (keyCode==RIGHT)
    {
      rightPressed = false;   
      car.acceleration = new PVector(0, 0);
    }
  }
}


void drawScreen(String title, String instructions) 
{
  background(main_background);
  // draw title
  fill(0,0,255);
  textSize(60);
  textAlign(CENTER, BOTTOM);
  text(title, width/2, 100);

  // draw instructions
  fill(255);
  textSize(30);
  textAlign(CENTER, TOP);
  text(instructions, width/2, 125);
}

float heading2D(PVector pvect)
{
  return (float)(Math.atan2(pvect.y, pvect.x));
}

void rotate2D(PVector v, float theta) 
{
  float xTemp = v.x;
  v.x = v.x*cos(theta) - v.y*sin(theta);
  v.y = xTemp*sin(theta) + v.y*cos(theta);
}
