PVector camera_position = new PVector();
PVector camera_normal = new PVector();
float camera_speed = 250.0;

float delta;

void setup() {
  size(800, 600, P3D);
  // camera_position = new PVector(0,0,10);
  // perspective(PI/3.0, width/height, 0, 1000);
  camera_normal = new PVector(0, 0, -1000000);
}

void draw() {
  delta = 1/frameRate;
  background(200);

  
  // camera(camera_position.x, camera_position.y, camera_position.z);
  // camera(
  //   camera_position.x, camera_position.y, camera_position.z,
  //   0, 0, 0,
  //   0, 1, 0
  // );
  
  if (updateCamera()){
    camera(
      camera_position.x, camera_position.y, camera_position.z,
      camera_normal.x, camera_normal.y, camera_normal.z,
      0, 1, 0
    );
  }

  fill(#CCFFAA);
  box(100);

  translate(100, 50, 0);
  fill(#AACCFF);
  box(10);
  
}

boolean updateCamera() {
  if (keyPressed) {
    if (key == 'w')      {camera_position.z -= camera_speed * delta; return true;}
    else if (key == 's') {camera_position.z += camera_speed * delta; return true;}
    else if (key == 'a') {camera_position.x -= camera_speed * delta; return true;}
    else if (key == 'd') {camera_position.x += camera_speed * delta; return true;}
    else if (key == 'z') {camera_position.y -= camera_speed * delta; return true;}
    else if (key == 'x') {camera_position.y += camera_speed * delta; return true;}
    else if (key == 'q') {
      PVector vec = new PVector(camera_normal.x, camera_normal.z);
      vec.rotate(-PI/2 * delta);
      println(camera_normal);
      camera_normal = new PVector(vec.x, camera_normal.y, vec.y);
      println(camera_normal);
      return true;
    }
    else if (key == 'e') {
      PVector vec = new PVector(camera_normal.x, camera_normal.z);
      vec.rotate(PI/2 * delta);
      camera_normal = new PVector(vec.x, camera_normal.y, vec.y);
      return true;
    }
  }
  return false;
}