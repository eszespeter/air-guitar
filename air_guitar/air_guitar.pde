//Import the libraries
import ketai.camera.*;
import android.content.Context;
import android.os.Vibrator;

//Declare the variables
Vibrator buzzer;

KetaiCamera cam;

PAAudioPlayer player_1;
PAAudioPlayer player_2;
PAAudioPlayer player_3;
PAAudioPlayer player_4;
PAAudioPlayer start_sound;
PAAudioPlayer beat;
PAAudioPlayer track;

int imgWidth = 176;//240;//320/2;
int imgHeight = 144;//160;//240/2;

int totalPixels = imgWidth * imgHeight;

int totalDiff; 

int guitarplayback;

int mode = 0;

PImage imgPrev;
PImage imgCurr;

int colorGreen = color(147, 233, 29);
int colorBlue = color(62, 149, 215);
int colorPurple = color(77, 65, 80);
int colorYellow = color(251, 219, 19);


//-------------------------------------------------------------------------------


void setup() {
  
  size(480, 320);
  
  orientation(LANDSCAPE);
    
  imageMode(CORNER);
  
  cam = new KetaiCamera(this, imgWidth, imgHeight, 24);
  imgPrev = createImage(imgWidth, imgHeight, RGB);
  imgCurr = createImage(imgWidth, imgHeight, RGB);

  player_1 = new PAAudioPlayer();
  player_1.loadFileDataFolder("guitar_01.wav");

  player_2 = new PAAudioPlayer();
  player_2.loadFileDataFolder("guitar_02.wav");

  player_3 = new PAAudioPlayer();
  player_3.loadFileDataFolder("guitar_03.wav");

  player_4 = new PAAudioPlayer();
  player_4.loadFileDataFolder("guitar_04.wav");
  
  start_sound = new PAAudioPlayer();
  start_sound.loadFileDataFolder("scream.wav");
  
  beat = new PAAudioPlayer();
  beat.loadFileDataFolder("beat.wav");
  
  track = new PAAudioPlayer();
  track.loadFileDataFolder("base_01.wav");

  stroke(0);
  strokeWeight(2);
  fill(255);
  
  buzzer = (Vibrator)getSystemService(Context.VIBRATOR_SERVICE);
  
  cam.start();
}

//-------------------------------------------------------------------------------

void draw() {

  //Start
  if (mode == 0) {
    
    background(200, 0, 0);
    
    //textFont(createFont("AIR GUITAR", 30));
    text("AIR GUITAR", width/2, height/2);
    textAlign(CENTER, CENTER);
    
    start_sound.start();
    
    if (frameCount >= 100) {
     mode = 1;
     frameCount = 0;
    }
  }
  
  //Beat start
  if (mode == 1) {
    
    background(0, 200, 0);
    
    //textFont(createFont("smoke on the water", 30));
    text("Smoke on the Water", width/2, height/2);
    textAlign(CENTER, CENTER);
    
    beat.start();
    
    if(frameCount >= 100) {
      mode = 2;
      frameCount = 0;
    }
  }
  
  //Vibration for initialize the session
  if (mode == 2) {
    
    background(0, 0, 200);
    
    //textFont(createFont("LET'S GO!", 30));
    text("LET'S GO", width/2, height/2);
    textAlign(CENTER, CENTER);
    
    buzzer.vibrate(500);
    
    if(frameCount >= 50) {
      mode = 3;
    }
  }
  
  //Application
  if (mode == 3) {
    
    background(255);
  
    fill(colorGreen);
    
    quad(0, 0, 
      width-((width-45)/3)*3 /*45*/, 0, 
      (width-45)/3 /*145*/, height, 
      0, height);

    fill(colorBlue);
    quad(width-((width-45)/3)*3 /*45*/, 0, 
       width-(((width-45)/3)*3)+(width-45)/3 /*190*/, 0, 
       ((width-45)/3)*2 /*290*/, height, 
       (width-45)/3 /*145*/, height);

    fill(colorPurple);
    quad(width-(((width-45)/3)*3)+((width-45)/3) /*190*/, 0, 
         ((width-45)/3)*2+(width-((width-45)/3)*3) /*335*/, 0, 
         width-(width-((width-45)/3)*3) /*435*/, height, 
         ((width-45)/3)*2 /*290*/, height);
  
    fill(colorYellow);
    quad(((width-45)/3)*2+(width-((width-45)/3)*3) /*335*/, 0, 
         width, 0, 
         width, height, 
         width-(width-((width-45)/3)*3) /*435*/, height);
         
      //Camera started   
      if (cam.isStarted()) {
      cam.loadPixels();
      imgPrev.copy(imgCurr, 0, 0, imgWidth, imgHeight, 0, 0, imgWidth, imgHeight);
      imgCurr.copy(cam, 0, 0, imgWidth, imgHeight, 0, 0, imgWidth, imgHeight);
  //    image(imgCurr, width/2, height/2);  
  //    image(imgPrev, 0, 0);
  
      // calculate difference
      imgCurr.loadPixels();
      imgPrev.loadPixels();
  
      float totalDiff = 0.0;
      int[] pixCurr = imgCurr.pixels;
      int[] pixPrev = imgPrev.pixels;
      for (int i = 0; i < totalPixels; i++) {
        totalDiff += abs(red(pixCurr[i]) - red(pixPrev[i]));
      }   
      fill(255);
      text("Total diff:\n" + floor(totalDiff), width/2 + 5, 30);
   
      if(guitarplayback == 1 && totalDiff > 1000000 && totalDiff < 15000000)
      {
        player_1.start();     
      }
      
      if(guitarplayback == 2 && totalDiff > 1000000 && totalDiff < 15000000)
      {
        player_2.start();
      }
      
      if(guitarplayback == 3 && totalDiff > 1000000 && totalDiff < 15000000)
      {
        player_3.start();
      }
      
      if(guitarplayback == 4 && totalDiff > 1000000 && totalDiff < 1500000)
      {
        player_4.start();
      }
    }
  }
}

//-------------------------------------------------------------------------------

void mousePressed() {
  
  color guitar = get(mouseX, mouseY);
  
  if(guitar == colorGreen) {
//  player_1.start();
   println(colorGreen);
   guitarplayback = 1;
  }
  
  if(guitar == colorBlue) {
//  player_2.start();
   println(colorBlue);
   guitarplayback = 2;
  }
  
  if(guitar == colorPurple) {
//  player_3.start();
   println(colorPurple);
   guitarplayback = 3;
  }
  
  if(guitar == colorYellow) {
//  player_4.start();
   println(colorYellow);
   guitarplayback = 4;
  }
}


void mouseReleased() {
  guitarplayback = 0;  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == MENU) {
      if (cam.isStarted())
      {
        cam.stop();
      }
      else
        cam.start();
    }
    if (keyCode == 84) {  
      if (track.isPlaying())
      {
        track.pause();
      }
      else
        track.start();
    }
  }
}

void onPause() {
  super.onPause();
  //Make sure to releae the camera when we go
  //  to sleep otherwise it stays locked
  if (cam != null && cam.isStarted())
    cam.stop();
}

void onCameraPreviewEvent() {
  cam.read();
}

void exit() {
  cam.stop();
  track.stop();
}

