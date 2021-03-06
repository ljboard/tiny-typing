import java.util.Arrays; //<>//
import java.util.Collections;

//Given by Professor Harrison
String[] phrases; //contains all of the phrases
int totalTrialNum = 5; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
final int DPIofYourDeviceScreen = 227; //you will need to look up the DPI or PPI of your device to make sure you get the right scale!!
                                      //http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density
final float sizeOfInputArea = DPIofYourDeviceScreen*1; //aka, 1.0 inches square!


//Display 
float input_area_x;
float input_area_y;
int padding = 0;
int section = 0;
float center_x = 500/2;
float center_y = 800/2;

int section_width = int(sizeOfInputArea/2);
int section_height = 57;
int letter_button_width = 65;

int row0 = 415;
int row1 = row0 + section_height + padding;
int row2 = row1 + section_height + padding;
int row3 = row2 + section_height + padding;
int row4 = row3 + section_height + padding;

int col1; 
int col2;

float x1_1 = center_x - 80, 
      x1_2 = center_x - 12, 
      x1_3 = center_x + 53, 
      x1_4 = center_x + 75,
      x1_5 = center_x + 80;
float y1_1 = center_y - 80, 
      y1_2 = center_y - 75, 
      y1_3 = center_y - 50, 
      y1_4 = center_y + 14, 
      y1_5 = center_y + 80;
float[] locations_x1 = {x1_1, x1_2, x1_3, x1_4, x1_5};
float[] locations_y1 = {y1_1, y1_2, y1_3, y1_4, y1_5};

float x2_1 = center_x + 80, 
      x2_2 = center_x + 10, 
      x2_3 = center_x - 50, 
      x2_4 = center_x - 60, 
      x2_5 = center_x - 30;
float y2_1 = center_y - 80, 
      y2_2 = center_y - 80, 
      y2_3 = center_y - 50, 
      y2_4 = center_y + 20, 
      y2_5 = center_y + 80;
float[] locations_x2 = {x2_1, x2_2, x2_3, x2_4, x2_5};
float[] locations_y2 = {y2_1, y2_2, y2_3, y2_4, y2_5};

float x3_1 = center_x - 80, 
      x3_2 = center_x - 12,
      x3_3 = center_x + 53, 
      x3_4 = center_x + 75;
float y3_1 = center_y - 50, 
      y3_2 = center_y - 45, 
      y3_3 = center_y - 20, 
      y3_4 = center_y + 44;
float[] locations_x3 = {x3_1, x3_2, x3_3, x3_4};
float[] locations_y3 = {y3_1, y3_2, y3_3, y3_4};

float x4_1 = center_x + 80, 
      x4_2 = center_x + 10, 
      x4_3 = center_x - 50, 
      x4_4 = center_x - 60, 
      x4_5 = center_x - 30;
float y4_1 = center_y - 80, 
      y4_2 = center_y - 80, 
      y4_3 = center_y - 50, 
      y4_4 = center_y + 20, 
      y4_5 = center_y + 80;
float[] locations_x4 = {x4_1, x4_2, x4_3, x4_4, x4_5};
float[] locations_y4 = {y4_1, y4_2, y4_3, y4_4, y4_5};

float x5_1 = center_x - 80, 
      x5_2 = center_x - 12, 
      x5_3 = center_x + 53;
float y5_1 = center_y, 
      y5_2 = center_y + 5, 
      y5_3 = center_y + 30;
float[] locations_x5 = {x5_1, x5_2, x5_3};
float[] locations_y5 = {y5_1, y5_2, y5_3};

float x6_1 = center_x - 60, 
      x6_2 = center_x - 50, 
      x6_3 = center_x, 
      x6_4 = center_x + 70;
float y6_1 = center_y + 80, 
      y6_2 = center_y + 10, 
      y6_3 = center_y - 50, 
      y6_4 = center_y - 70;
float[] locations_x6 = {x6_1, x6_2, x6_3, x6_4};
float[] locations_y6 = {y6_1, y6_2, y6_3, y6_4};

float[][] all_locations_x = {locations_x1, locations_x2, locations_x3, locations_x4, locations_x5, locations_x6};
float[][] all_locations_y = {locations_y1, locations_y2, locations_y3, locations_y4, locations_y5, locations_y6};

Section[] sections = new Section[6];

boolean is_dragging = false;

String[] letters = {"QWERT", "YUIOP", 
                    "ASDF", "GHJKL", 
                    "ZXC", "VBNM"};

private class Section
{
  int index = -1; 
  
  String keys = "";
  int num_keys = -1;
  
  float x = -1;
  float y = -1;
}

Section section_1 = new Section();
Section section_2 = new Section();
Section section_3 = new Section();
Section section_4 = new Section();
Section section_5 = new Section();
Section section_6 = new Section();


//You can modify anything in here. This is just a basic implementation.
void setup()
{
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases)); //randomize the order of the phrases
    
  // TODO: figure out phone sizing 
  orientation(PORTRAIT); //can also be LANDSCAPE -- sets orientation on android device
  size(500, 800, OPENGL); //Sets the size of the app. You may want to modify this to your device. Many phones today are 1080 wide by 1920 tall.
  input_area_x = width/2;// - sizeOfInputArea/2;
  input_area_y = height/2 + 100;// - sizeOfInputArea/2; 
 
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
   
  col1 = int(input_area_x) - section_width/2 - padding/2;
  col2 = int(input_area_x) + section_width/2 + padding/2;
  
  section_1.keys = letters[0];
  section_1.num_keys = section_1.keys.length();
  section_1.x = col1;
  section_1.y = row1;
  section_1.index = 1;
  sections[0] = section_1;
  
  section_2.keys = letters[1];
  section_2.num_keys = section_2.keys.length();
  section_2.x = col2;
  section_2.y = row1;  
  section_2.index = 2;
  sections[1] = section_2;
  
  section_3.keys = letters[2];
  section_3.num_keys = section_3.keys.length();
  section_3.x = col1;
  section_3.y = row2;
  section_3.index = 3;
  sections[2] = section_3;
  
  section_4.keys = letters[3];
  section_4.num_keys = section_4.keys.length();
  section_4.x = col2;
  section_4.y = row2;  
  section_4.index = 4;
  sections[3] = section_4;  
  
  section_5.keys = letters[4];
  section_5.num_keys = section_5.keys.length();
  section_5.x = col1;
  section_5.y = row3;
  section_5.index = 5;
  sections[4] = section_5;
  
  section_6.keys = letters[5];
  section_6.num_keys = section_6.keys.length();
  section_6.x = col2;
  section_6.y = row3;  
  section_6.index = 6;
  sections[5] = section_6;   
  
  noStroke(); //my code doesn't use any strokes.
}


void draw_keys(Section S) {
  textSize(60);
  textAlign(CENTER, CENTER);
  char letter;
  float x; 
  float y;
 
  for (int i = 0; i < S.num_keys; i++) {
    //println("S index:", S.index - 1);
    letter = S.keys.charAt(i);
    //print("letter:", letter);
    x = all_locations_x[S.index - 1][i];
    y = 100 + all_locations_y[S.index - 1][i];
    
    if ((abs(mouseX - x) < letter_button_width/2) && 
        (abs(mouseY - y) < letter_button_width/2)){
      fill(0, 255, 0, 200);
    } else {
      fill(0, 0, 255, 200);
    }
    
    ellipse(x, y, letter_button_width, letter_button_width);
    fill(255);
    text(letter, x, y + 2*padding - 10);
  }
}

void draw_section(Section S) {
  if (section != 0) {
    return;
  }
  if (section == S.index) {
    fill(255, 0, 0);
  } else {
    fill(255, 0, 0, 100);
  } 
  //stroke(1);
  rect(S.x, S.y, 
       section_width, section_height);

  fill(0);
  textSize(37);
  float x = S.x;
  if (S.index % 2 == 1) {
    textAlign(RIGHT, CENTER);
    x += section_width/2;
    x -= 2;
  } else {
    textAlign(LEFT, CENTER);
    x -= section_width/2;
    x += 2;
  }
  text(letters[S.index - 1], x, S.y + 2*padding);
}


//You can modify anything in here. This is just a basic implementation.
void draw()
{
  ellipseMode(CENTER);
  PFont mono = createFont("Monospaced", 30);
  textFont(mono);  

  background(0); //clear background
  //textSize(35);

 // image(watch,-200,200);
  fill(100);
  rect(input_area_x, input_area_y, 
       sizeOfInputArea, sizeOfInputArea); //input area should be 2" by 2"

  if (finishTime!=0)
  {
    fill(255);
    textAlign(CENTER);
    text("Finished", 280, 150);
    return;
  }

  if (startTime==0 & !mousePressed)
  {
    fill(255);
    textAlign(CENTER);
    text("Click to start time!", 280, 150); //display this messsage until the user clicks!
  }

  if (startTime==0 & mousePressed)
  {
    nextTrial(); //start the trials!
  }

  if (startTime!=0)
  {
    textSize(28);
    //you will need something like the next 10 lines in your code. Output does not have to be within the 2 inch area!
    textAlign(LEFT); //align the text left
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 5, 50); //draw the trial count
    fill(255);
    text("Target: " + displayText(currentPhrase), 5, 100); //draw the target string
    String currentTypedToDisplay = currentTyped;
   
    if (currentTyped.length() > 0 && currentTyped.charAt(currentTyped.length()-1) == ' ') {
      currentTypedToDisplay = currentTyped.substring(0, currentTyped.length() - 1) + "_";
    }
    text("Entered: " + displayText(currentTypedToDisplay) + "|", 5, 250); //draw what the user has entered thus far 
    //fill(255, 0, 0);
    //rect(800, 00, 200, 200); //drag next button
    //fill(255);
    //text("NEXT > ", 850, 100); //draw next label

    //my draw code

    if (section == 0) {
      // draw keyboard
      draw_section(section_1);
      draw_section(section_2);
      draw_section(section_3);
      draw_section(section_4); 
      draw_section(section_5);
      draw_section(section_6);
      
      // delete button
      textAlign(CENTER, CENTER);
      fill(200, 30, 30);
      rect(col1, row0, section_width, section_height);
      fill(255);
      text("del", col1, row0);
      
      // space button
      textAlign(CENTER, CENTER);
      fill(20, 60, 255);
      rect(col2, row0, section_width, section_height);
      fill(255);
      text("space", col2, row0);
    } else {
      Section S = sections[section-1];
      draw_section(S);
      draw_keys(S);
    }
    noStroke();
  }

  textSize(30);
  fill(0, 255, 0);
  rect(width/2, height - 100, width, 100);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Next Sentence", width/2, height - 100);
  
  fill(0);

}

String displayText(String s) {
  int n = s.length();
  if (n > 15) {
    s = s.substring(0, 15) + "\n" + s.substring(15, n);
  } 
  n = s.length();
  if (s.length() > 40) { 
    s = s.substring(0, 40) + "\n" + s.substring(40, n);
  }
  return s;
}

void mouseDragged() 
{
  is_dragging = true;
}

boolean overButton(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}


void mousePressed()
{
  if (startTime==0) return;
  if (section != 0) {
    section = 0;
    //return;
  }
 if (overButton(0, height - 150, width, 150)) {
  //if (overButton(width/2, 3*height/4, 300, 100)) {
    nextTrial();
  }
  if (overButton(col1 - section_width/2, row1-section_height/2, 
                 section_width + padding, section_height)) {
    section = 1;
  } else if (overButton(col2 - section_width/2, row1-section_height/2, 
                 section_width + padding, section_height)) {
    section = 2;
  } else if (overButton(col1 - section_width/2, row2-section_height/2, 
                 section_width + padding, section_height)) {
    section = 3;
  } else if (overButton(col2 - section_width/2, row2-section_height/2, 
                 section_width + padding, section_height)) {
    section = 4;
  } else if (overButton(col1 - section_width/2, row3-section_height/2, 
                 section_width + padding, section_height)) {
    section = 5;
  } else if (overButton(col2 - section_width/2, row3-section_height/2, 
                 section_width + padding, section_height)) {
    section = 6;
  } else if (overButton(col1 - section_width/2, row0-section_height/2, section_width, section_height)) {
    section = 0;
    if (currentTyped.length() > 0) {
      currentTyped = currentTyped.substring(0, currentTyped.length()-1);
    }
  } else if (overButton(col2 - section_width/2, row0-section_height/2, section_width, section_height)) {
    section = 0;
    currentTyped += " ";
  } else {
    section = 0;
  }
  //println(section);
}

void mouseReleased() {
  if (section != 0) {
    Section S = sections[section-1];
    
    float x;
    float y;

    for (int i = 0; i < S.num_keys; i++) {
      x = all_locations_x[S.index - 1][i];
      y = all_locations_y[S.index - 1][i] + 3*letter_button_width/2;
      if (dist(mouseX, mouseY, x, y) < letter_button_width/2) {
        String selected_letter = String.valueOf(S.keys.charAt(i));
        currentTyped += selected_letter.toLowerCase();
        break;
      }
    }
    section = 0;
  }  
}

void nextTrial()
{
  if (currTrialNum >= totalTrialNum) //check to see if experiment is done
    return; //if so, just return

    if (startTime!=0 && finishTime==0) //in the middle of trials
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
    System.out.println("Target phrase: " + currentPhrase); //output
    System.out.println("Phrase length: " + currentPhrase.length()); //output
    System.out.println("User typed: " + currentTyped); //output
    System.out.println("User typed length: " + currentTyped.length()); //output
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim())); //trim whitespace and compute errors
    System.out.println("Time taken on this trial: " + (millis()-lastTime)); //output
    System.out.println("Time taken since beginning: " + (millis()-startTime)); //output
    System.out.println("==================");
    lettersExpectedTotal+=currentPhrase.length();
    lettersEnteredTotal+=currentTyped.length();
    errorsTotal+=computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
  }

  //probably shouldn't need to modify any of this output / penalty code.
  if (currTrialNum == totalTrialNum-1) //check to see if experiment just finished
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime)); //output
    System.out.println("Total letters entered: " + lettersEnteredTotal); //output
    System.out.println("Total letters expected: " + lettersExpectedTotal); //output
    System.out.println("Total errors entered: " + errorsTotal); //output
    
    float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
    System.out.println("Raw WPM: " + wpm); //output
    
    float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
    
    System.out.println("Freebie errors: " + freebieErrors); //output
    float penalty = max(errorsTotal-freebieErrors,0) * .5f;
    
    System.out.println("Penalty: " + penalty);
    System.out.println("WPM w/ penalty: " + (wpm-penalty)); //yes, minus, becuase higher WPM is better
    System.out.println("==================");
    
    currTrialNum++; //increment by one so this mesage only appears once when all trials are done
    return;
  }

  if (startTime==0) //first trial starting now
  {
    System.out.println("Trials beginning! Starting timer..."); //output we're done
    startTime = millis(); //start the timer!
  }
  else
  {
    currTrialNum++; //increment trial number
  }

  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
  //currentPhrase = "abc"; // uncomment this to override the test phrase (useful for debugging)
}



//=========SHOULD NOT NEED TO TOUCH THIS METHOD AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2) //this computers error between two strings
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}