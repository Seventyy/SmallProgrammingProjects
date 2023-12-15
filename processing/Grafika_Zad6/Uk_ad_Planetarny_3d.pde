PImage sunTexture;
PShape sun;

PImage sky_box_Texture;
PShape sky_box;

PShape ufo;
PShape gun;

PShape asteroid;
PShape beacon_o;
PShape beacon_i;

PImage ptex1;
PShape planet1;

PImage ptex2;
PShape planet2;

PImage ptex3;
PShape planet3;

PImage ptex4;
PShape planet4;

PImage sky;

float cX = 0;
float cY = 0;
float cZ = 0;

float fi = PI/2;
float tet = 0;


float flight_speed = 0.0;
float max_flight_speed = 32;
float min_flight_speed = -12;
float flight_acceleration = 6;
float flight_deceleration = 1;

float drift;
float max_drift = 0.3;

int laser_length = 1000;

boolean time_slow = false;
boolean accelerate = false;
boolean decelerate = false;
boolean rotateUp = false;
boolean rotateDown = false;
boolean rotateLeft = false;
boolean rotateRight = false;

float t;
float s; //another time variable

void setup() {
    //size(1600, 1000, P3D);
    size(1280, 680, P3D);
    noStroke();
    sphereDetail(120);
    
    sunTexture = loadImage("sun3.jpg");  
    sun = createShape(SPHERE, 80);
    sun.setTexture(sunTexture);
    
    sky_box_Texture = loadImage("sky_box.jpg");
    sky_box = createShape(SPHERE, 300);
    sky_box.setTexture(sky_box_Texture);
    
    ufo = loadShape("ufo2.obj");
    gun = loadShape("gun.obj");
    
    asteroid = loadShape("asteroid.obj");
    beacon_o = loadShape("beacon_outer.obj");
    beacon_i = loadShape("beacon_inner.obj");
    beacon_i.setFill(color(10, 10, 255));
    
    ptex1 = loadImage("planet4.jpg"); 
    planet1 = createShape(SPHERE, 55);
    planet1.setTexture(ptex1);
    
    ptex2 = loadImage("planet2.jpg"); 
    planet2 = createShape(SPHERE, 30);
    planet2.setTexture(ptex2);
    
    ptex3 = loadImage("planet3.jpg"); 
    planet3 = createShape(SPHERE, 40);
    planet3.setTexture(ptex3);
    
    ptex4 = loadImage("planet5.jpg"); 
    planet4 = createShape(SPHERE, 20);
    planet4.setTexture(ptex4);
    
    sky = loadImage("sky.png");
}

void light_laser(int l) {
  for(int i = 0; i < l; i++) {
    pointLight(255,  250,  220,  0,  0,  i - l/2);
  }
}

void draw() {
  print("X: ", sin(fi) * sin(tet), "\n");
  print("Y: ", cos(fi), "\n");
  print("Z: ", sin(fi) * cos(tet), "\n"); 
  background(0);
  perspective(PI/3.0,(float)width/height,1,1000000);
  
  if (accelerate) {
    flight_speed += flight_acceleration;
  }
  if (decelerate) {
    flight_speed -= flight_acceleration;
  }


  if (rotateUp) {
    if(cos(fi) > -0.95) {
      fi += 0.025;
    }
  }
  if (rotateDown) {
    if(cos(fi) < 0.95) {
      fi -= 0.025;
    }
  }
  if (rotateLeft) {
    drift -= 0.08;
    tet += 0.02;
  }
  if (rotateRight) {
    drift += 0.08;
    tet -= 0.02;
  }
  
  
  pushMatrix();
    translate(cX, cY, cZ);
    hint(DISABLE_DEPTH_MASK);
    shape (sky_box);
    hint(ENABLE_DEPTH_MASK);
  popMatrix();
    
  camera(cX, cY, cZ,   cX + (sin(fi) * sin(tet)), cY + cos(fi), cZ + (sin(fi) * cos(tet)),   0, 1, 0);

  
  
  cX += flight_speed * (sin(fi) * sin(tet)); 
  cZ += flight_speed * (sin(fi) * cos(tet));
  cY += flight_speed * cos(fi);
  
  

  if(flight_speed < 0) {
    flight_speed += flight_deceleration;
    if (flight_speed < min_flight_speed) {
      flight_speed = min_flight_speed;
    }
  }
  if (flight_speed > 0){
    flight_speed -= flight_deceleration;
    if(flight_speed > max_flight_speed) {
      flight_speed = max_flight_speed;
    }
  }
  if (drift > 0) {
    drift -= 0.03;
    if (drift > max_drift) {
      drift = max_drift;
    }
  }
  if (drift < 0) {
    drift += 0.03;
    if (drift < -max_drift) {
      drift = -max_drift;
    }
  }
  
 
  pushMatrix();
    // Sun ------------------------------------------------------------------------------
    scale(20);
    pushMatrix();
      rotateY(0.1*t);
      shape(sun);
    popMatrix(); 
   popMatrix();
   
   ambientLight(20, 20, 20);
   lightSpecular(100, 100, 100);
   pointLight(255,  250,  220,  0,  0,  0);
  
  
    // UFO Laser------------------------------------------------------------------------------
    pushMatrix();
      translate(cX, cY, cZ);
      rotate(PI);
      rotateY(-tet);
      rotateX(-fi + PI/2);
      translate(0, -45, 0);
      translate(0,0,60);
      rotateZ(-drift);
      scale(2);
       rotateY(PI * (mouseX - width / 2) / width);
       noLights();
       if(mousePressed) {
         translate(0, 15.8, laser_length/2 + 15);
         rotateZ(s);
         ambientLight(255, 255, 255);
         fill(66, 245, 84);
         box(1, 1, laser_length);
         noLights();
         spotLight(66, 245, 84,    0, 0, -laser_length/2,    0, 0, 1, 0.01*PI, 600);
         spotLight(66, 245, 84,    0, 0, -laser_length/2,    0, 0, 1, 0.01*PI, 600);
       }
    popMatrix();
    
    ambientLight(20, 20, 20);
    lightSpecular(100, 100, 100);
    pointLight(255,  250,  220,  0,  0,  0);
    
    
    // Beacon Planet ------------------------------------------------------------------------------
    pushMatrix();
      scale(20);
      rotateY(0.8*t);
      translate(420, 0, 0);
      pushMatrix();
        rotateY(3*t);
        translate(36, 0, 0);
        spotLight(10, 10, 255,    0, 0, 0,    1, 0, 0, 0.2*PI, 10);
        spotLight(10, 10, 255,    0, 0, 0,    1, 0, 0, 0.2*PI, 10);
        rotateZ(-0.5*PI);
        shape(beacon_o);
        shape(beacon_i);
      popMatrix();
      pushMatrix();
        sphereDetail(20);
        rotateY(4.6*t);
        translate(60, 0, 0);
        fill(122, 67, 42);
        specular(0,0,0);
        sphere(8);
      popMatrix();
      pushMatrix();
        sphereDetail(30);
        rotateY(1.8*t);
        translate(100, 0, 0);
        specular(255,255,255);
        fill(228, 221, 237);
        shininess(128.0);
        sphere(16);
      popMatrix();
      rotateY(3*t);
      shape(planet3);
    popMatrix();
  
    // UFO ------------------------------------------------------------------------------
    pushMatrix();
        translate(cX, cY, cZ);
        rotate(PI);
        rotateY(-tet);
        rotateX(-fi + PI/2);
        translate(0, -45, 0);
        translate(0,0,60);
        rotateZ(-drift);
        scale(2);
        shape(ufo);
        rotateY(PI * (mouseX - width / 2) / width);
        shape(gun);
    popMatrix();
    
    
    // Other Planets (don't give of light) ------------------------------------------------------------------------------
    pushMatrix();
       scale(20);
        
       // red close planet
       pushMatrix();
        rotateY(4*t);
        translate(150, 0, 0);
        rotateY(-4*t);
        rotateZ(-0.03*PI); // tilt
        pushMatrix();
          rotateY(12*t);
          shape(planet4);
        popMatrix();
      popMatrix();
    
      // planet + ring (angled)
      pushMatrix();
        rotateY(0.3*t);
        translate(680, 0, 0);
        rotateY(-0.3*t);
        rotateZ(-0.08*PI); // tilt
        pushMatrix();
        rotate(1*t, 1, 1, 2);
          int[] rotate_factors = {1, 3, -5, 7, 3, 4, 2, -1, 2, 5,   4, -2, 1, 2, 3, 5, -4, -6, 3, 3,   -4, 6, 2, 1, 4, -1, 1, -6, 4, -1};
          for(int i = 0; i < 10; i++){
            float rotate_factor = i;
            pushMatrix();
              rotateY(0.2*i * PI);
              rotateY(4*t);
              translate(80, 0, 0);
              rotate(0.1*t, rotate_factors[i], rotate_factors[i+10], rotate_factors[i+20]);
              scale(0.4);
              shape(asteroid);
            popMatrix();
          }
        popMatrix();
        rotateY(t);
        shape(planet1);
      popMatrix();
    
       // planet + moon (angled)
       pushMatrix();
        rotateY(1.5*t);
        translate(240, 0, 0);
        pushMatrix();
          sphereDetail(30);
          rotateY(6*t);
          translate(60, 0, 0);
          specular(100,100,100);
          shininess(50.0);
          fill(143, 173, 199);
          sphere(12);
        popMatrix();
        rotateY(-t);
        rotateZ(-0.1*PI); // 18 degrees tilt
        rotateY(5*t);
        shape(planet2);
      popMatrix();
     
    popMatrix();
 

  s = 0.01 * millis();
  
  t = 0.001 * millis();
  if (time_slow) {
    t *= 0.05;
  }
}

void keyPressed() {
  if (key == ' ') {
    accelerate = true;
  }
  if (key == CODED) {
    if(keyCode == SHIFT) { 
      decelerate = true;
    }
  }
  if (key == 'w' || key == 'W') {
    rotateUp = true;
  }
  if (key == 's' || key == 'S') {
    rotateDown = true;
  }
  if (key == 'a' || key == 'A') {
    rotateLeft = true;
  }
  if (key == 'd' || key == 'D') {
    rotateRight = true;
  }
  if (key == ENTER) {
    time_slow = !time_slow;
  }
}

void keyReleased() {
  if (key == ' ') {
    accelerate = false;
  }
  if (key == CODED) {
    if(keyCode == SHIFT) { 
      decelerate = false;
    }
  }
  if (key == 'w' || key == 'W') {
    rotateUp = false;
  }
  if (key == 's' || key == 'S') {
    rotateDown = false;
  }
  if (key == 'a' || key == 'A') {
    rotateLeft = false;
  }
  if (key == 'd' || key == 'D') {
    rotateRight = false;
  }
}
