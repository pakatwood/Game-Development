class Car
{
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector rotation;
  float drag = .9;
  float r = 35;
  PImage img = loadImage("car.png");

  public Car()
  {
    position = new PVector(width/2, height-50);
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    rotation = new PVector(0, 1);
  } 

  void update()
  {
    PVector below = new PVector(0, -2*r);
    rotate2D(below, heading2D(rotation)+PI/2);
    below.add(position);

    velocity.add(acceleration);
    velocity.mult(drag);//adjust the speed to avoid it moving too fast
    velocity.limit(5);//the maximum speed is 5
    position.add(velocity);
  }

  void roundBack()
  {
    if (position.x < r + 150)
      position.x = r + 150;

    if (position.y < r) 
      position.y = r;

    if (position.x > width-r - 150) 
      position.x = width-r - 150;

    if (position.y > height-r)
      position.y = height-r;
  }

  boolean checkCollision(ArrayList<NPC> npcs)
  {
    for (NPC a : npcs)
    {
      PVector lane = new PVector(array_lane[lane_number], a.position.y);
      PVector dist = PVector.sub(lane, position);
      if (dist.mag() < a.radius + r)
      {
        return true;
      }
    }
    return false;
  }
  boolean checkCollision_2(ArrayList<NPC_2> npcs_2)
  {
    for (NPC_2 a : npcs_2)
    {
      PVector lane = new PVector(array_lane[lane_number2], a.position.y);
      PVector dist = PVector.sub(lane, position);
      if (dist.mag() < a.radius + r)
      {
        return true;
      }
    }
    return false; 
  }
    boolean checkCollision_3(ArrayList<NPC_3> npcs_3)
  {
    for (NPC_3 a : npcs_3)
    {
      PVector lane = new PVector(array_lane[lane_number3], a.position.y);
      PVector dist = PVector.sub(lane, position);
      if (dist.mag() < a.radius + r)
      {
        return true;
      }
    }
    return false; 
  }
    boolean checkCollision_heart(ArrayList<HEART> heart)
  {
    for (HEART a : heart)
    {
      PVector lane = new PVector(array_lane[lane_heart], a.position.y);
      PVector dist = PVector.sub(lane, position);
      if (dist.mag() < a.radius + r)
      {
        return true;
      }
    }
    return false; 
  }
  void render()
  { 
    roundBack();
    pushMatrix();
    translate(position.x, position.y);
    rotate(0);
    fill(0);

    image(img, -r, -r*1.5, 2*r, 3*r); 
    popMatrix();
  }
}
