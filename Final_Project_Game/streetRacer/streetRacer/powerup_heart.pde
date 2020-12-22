class HEART
{
  float radius;
  PVector position;
  PVector velocity;
  PImage pic;

  public HEART(PVector pos, float radius_, PImage pics_)
  {
    radius  = radius_;
    position = pos;
    velocity = new PVector(0, 1);
    // velocity multiplier for GEAR, default 1
    velocity.mult(2);
    pic = pics_;
  }

  //update the npcs's position 
  void update()
  {
    position.add(velocity);
  }

  //display the GEAR
  void render()
  {
    roundBack();  
    pushMatrix();
    translate(array_lane[lane_heart], position.y);
    image(pic, -radius, -radius, radius*2, radius*2);
    popMatrix();
  }

  void roundBack()
  {
    if (position.y > height) {
    newHEART();
    }
  }
}
