PImage sky;

void setup() {
  size(1600, 1120); //declare window size
  sky = loadImage("sky.png");
}

  float t = 0.0f;
  float ellipse_proportion = 0.7;
  float planet_scalling = 0.3;
  float moon_scalling = 0.1;
  
  

void draw_moon(float orbit, float size, float speed, float parent_x, float parent_y, int R, int G, int B) {
  pushMatrix();
    translate(parent_x, parent_y);
    scale(1 + cos(t* PI * speed) * moon_scalling);
    fill(R, G, B);
    ellipse(orbit * sin(t* PI * speed), (orbit * ellipse_proportion) * cos(t* PI * speed), size, size);
    scale(1 - cos(t* PI * speed) * moon_scalling);
  popMatrix();
}

void draw_planet_1(int orbit, int size, float speed, int R, int G, int B) {
  pushMatrix();
    scale(1 + cos(t* PI * speed) * planet_scalling);
    fill(R, G, B);
    ellipse(orbit * sin(t* PI * speed), (orbit * ellipse_proportion) * cos(t* PI * speed), size, size);
    draw_moon(size *1.2 , 11, 3.6, orbit * sin(t * PI * speed), orbit * ellipse_proportion * cos(t * PI * speed), 150, 150, 150);
  popMatrix();
}

void draw_planet_2(int orbit, int size, float speed, int R, int G, int B) {
  pushMatrix();
    scale(1 + cos(t* PI * speed) * planet_scalling);
    fill(R, G, B);
    ellipse(orbit * sin(t* PI * speed), (orbit * ellipse_proportion) * cos(t* PI * speed), size, size);
    draw_moon(size *1.2 , 10 , 2.2, orbit * sin(t * PI * speed), orbit * ellipse_proportion * cos(t * PI * speed), 150, 150, 150);
    draw_moon(size *1.5 , 7 , 0.8, orbit * sin(t * PI * speed), orbit * ellipse_proportion * cos(t * PI * speed), 150, 150, 150);
  popMatrix();
}

void draw_planet_3(int orbit, int size, float speed, int R, int G, int B) {
  pushMatrix();
    scale(1 + cos(t* PI * speed) * planet_scalling);
    fill(R, G, B);
    ellipse(orbit * sin(t* PI * speed), (orbit * ellipse_proportion) * cos(t* PI * speed), size, size);
  popMatrix();
}

void draw_planet_4(int orbit, int size, float speed, int R, int G, int B) {
  pushMatrix();
    scale(1 + cos(t* PI * speed) * planet_scalling);
    fill(R, G, B);
    ellipse(orbit * sin(t* PI * speed), (orbit * ellipse_proportion) * cos(t* PI * speed), size, size);
    draw_moon(size *1.2 , 14 , 3.1, orbit * sin(t * PI * speed), orbit * ellipse_proportion * cos(t * PI * speed), 150, 150, 150);
    draw_moon(size *1.5 , 9 , 2.4, orbit * sin(t * PI * speed), orbit * ellipse_proportion * cos(t * PI * speed), 150, 150, 150);
    draw_moon(size *1.7 , 20 , 1, orbit * sin(t * PI * speed), orbit * ellipse_proportion * cos(t * PI * speed), 150, 150, 150);
    draw_moon(size *1.9 , 8 , 0.7, orbit * sin(t * PI * speed), orbit * ellipse_proportion * cos(t * PI * speed), 150, 150, 150);

  popMatrix();
}

void draw_random_planet(int orbit, int size, float speed, int R, int G, int B, 
    int number_of_moons, float moon_min_orbit_mod, float moon_max_orbit_mod, int moon_min_size, int moon_max_size, 
    float moon_min_speed, float moon_max_speed, int moon_gray_tint) {
  pushMatrix();
    scale(1 + cos(t* PI * speed) * planet_scalling);
    fill(R, G, B);
    ellipse(orbit * sin(t* PI * speed), (orbit * ellipse_proportion) * cos(t* PI * speed), size, size);
    for (int i = 0; i < number_of_moons; i++) {
      draw_moon(size * random(moon_min_orbit_mod, moon_max_orbit_mod), random(moon_min_size, moon_max_size), random(moon_min_speed, moon_max_speed),
                orbit * sin(t * PI * speed), orbit * ellipse_proportion * cos(t * PI * speed), moon_gray_tint, moon_gray_tint, moon_gray_tint);
    }
  popMatrix();
}

void draw() { //60 times per sec
  
  image(sky, 0, 0);
  
  translate(width / 2, height / 2.4);
  fill(249, 214, 15);
  ellipse(0, 0, 120, 120);
  
  draw_planet_1(180, 25, 0.63, 235, 137, 52);
  draw_planet_2(270, 30, 0.28, 52, 207, 235);
  draw_planet_3(370, 40, 0.17, 75, 173, 64);
  draw_planet_4(580, 70, 0.07, 166, 55, 111);
  
  //draw_random_planet(270, 30, 0.28, 52, 207, 235, 3, 1.2, 1.8, 10, 20, 1.8, 3.0, 150);

  
  t = 0.001 * millis();

}
