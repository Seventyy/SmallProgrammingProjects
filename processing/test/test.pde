 PVector camera_position = new PVector();
 PVector camera_normal = new PVector();
 float camera_speed = 250.0;

 float delta;


 float rotationAngle;
 float elevationAngle;

 float centerX;
 float centerY;
 float centerZ;


 void setup() {
   size(800, 600, P3D);
   camera_position = new PVector(0,0,400);
   // perspective(PI/3.0, width/height, 0, 1000);
   camera_normal = new PVector(0, 0, -1);
 }

 void draw() {
   delta = 1/frameRate;
   background(200);
   draw_cubes();

  
   // camera(camera_position.x, camera_position.y, camera_position.z);
   // camera(
   //   camera_position.x, camera_position.y, camera_position.z,
   //   0, 0, 0,
   //   0, 1, 0
   // );
  
   updateCamera();
   camera(
     camera_position.x, camera_position.y, camera_position.z,
     camera_normal.x * 1000000, camera_normal.y * 1000000, camera_normal.z * 1000000,
     0, 1, 0
   );

   // camera(mouseX, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
 

   // fill(#CCFFAA);
   // box(100);

   // translate(100, 50, 0);
   // fill(#AACCFF);
   // box(10);
  
 }

 //void updateCamera() {
 // rotationAngle = map(mouseX, 0, width, 0, TWO_PI);
 // elevationAngle = map(mouseY, 0, height, 0, PI);

 // centerX = cos(rotationAngle) * sin(elevationAngle);
 // centerY = sin(rotationAngle) * sin(elevationAngle);
 // centerZ = -cos(elevationAngle);

 // camera(0, 0, 0, centerX, centerY, centerZ, 0, 0, 1);
 //}


  void updateCamera() {
    if (keyPressed) {
      if (key == 'w') {
        camera_position = PVector.add(camera_position, PVector.mult(camera_normal.normalize(), camera_speed * delta));
      } 
      else if (key == 's') {
        camera_position = PVector.add(camera_position, PVector.mult(camera_normal.normalize(), -camera_speed * delta));
      } 
      else if (key == 'a') {
        PVector vec = new PVector(camera_normal.x, camera_normal.z);
        vec.rotate(-PI/2 * delta);
        camera_normal = new PVector(vec.x, camera_normal.y, vec.y);
      } 
      else if (key == 'd') {
        PVector vec = new PVector(camera_normal.x, camera_normal.z);
        vec.rotate(PI/2 * delta);
        camera_normal = new PVector(vec.x, camera_normal.y, vec.y);
      }
      else if (key == ' ') {
        PVector vec = new PVector(camera_normal.y, camera_normal.z);
        vec.rotate(-PI/2 * delta);
        camera_normal = new PVector(camera_normal.x, vec.x, vec.y);
      } 
      else if (keyPressed && key == CODED && keyCode == SHIFT) {
        PVector vec = new PVector(camera_normal.y, camera_normal.z);
        vec.rotate(PI/2 * delta);
        camera_normal = new PVector(camera_normal.x, vec.x, vec.y);
      }
    }
  }


 void draw_cubes(){
     float[][] cubeProperties = {
     {50, 50, 50, color(255, 0, 0)},
     {70, -30, -60, color(0, 255, 0)},
     {-80, 20, 40, color(0, 0, 255)},
     {90, -70, -30, color(255, 255, 0)},
     {-60, 80, -20, color(255, 0, 255)},
     {30, -90, 60, color(0, 255, 255)},
     {-40, 110, -50, color(128, 0, 0)},
     {10, -120, 70, color(0, 128, 0)},
     {-120, 90, -80, color(0, 0, 128)},
     {100, 60, 20, color(128, 128, 0)},
     {-30, -50, 100, color(128, 0, 128)},
     {80, 40, -110, color(0, 128, 128)},
     {-70, -10, 30, color(192, 192, 192)},
     {20, 0, -40, color(128, 128, 128)},
     {-50, 50, 80, color(255, 165, 0)}
   };
  
   // Draw the cubes
   for (int i = 0; i < cubeProperties.length; i++) {
     float x = cubeProperties[i][0];
     float y = cubeProperties[i][1];
     float z = cubeProperties[i][2];
     int col = (int) cubeProperties[i][3];
    
     pushMatrix();
     translate(x, y, z);
     fill(col);
     box(40); // Adjust the size of the cubes as needed
     popMatrix();
   }
 }

//PImage texture;
//PShape model;

//void setup() {
// size(500, 500, P3D);
// model = loadShape("icosahedron.obj");
// texture = loadImage("planet_1_texture.png");
// model.setTexture(texture);
//}

//void draw() {
// background(0);
// lights();
// translate(width * 0.5, height * 0.5, 0);
// rotateY(map(mouseX, 0, width, -PI, PI));
// rotateX(map(mouseY, 0, height, PI, -PI));
// scale(10);
// shape(model);
//}
