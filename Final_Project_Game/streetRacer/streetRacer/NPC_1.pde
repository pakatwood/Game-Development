class NPC
{
  float radius;
  PVector position;
  PVector velocity;
  PImage pic;

  public NPC(PVector pos, float radius_, PImage pics_)
  {
    radius  = radius_;
    position = pos;
    velocity = new PVector(0, 1);
    // velocity multiplier for NPC, default 1
    velocity.mult(level);
    pic = pics_;
  }

  //update the npcs's position 
  void update()
  {
    position.add(velocity);
  }

  //display the npc
  void render()
  {
    roundBack();  
    pushMatrix();
    translate(array_lane[lane_number], position.y);
    image(pic, -radius, -radius, radius*2, radius*4);
    popMatrix();
  }

  void roundBack()
  {
    if (position.y > height) {
    //newNPC();
    }
  }
}
