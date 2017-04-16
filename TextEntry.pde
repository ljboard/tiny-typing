import java.util.Arrays; //<>//
import java.util.Collections;

//Given by Professor Harrison
String[] phrases; //contains all of the phrases
int totalTrialNum = 4; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
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

int section_width = 100;
int section_height = 40;
int letter_button_width = 40;

int row1_height = 360;
int row2_height = row1_height + section_height + padding;
int row3_height = row2_height + section_height + padding;
int row0_height = row1_height - section_height - padding;

int col1; 
int col2;

Section[] sections = new Section[6];

boolean is_dragging = false;

String[] letters = {"qwert", "yuiop", 
                    "asdf", "ghjkl", 
                    "zxc", "vbnm"};

Section section_1 = new Section();
Section section_2 = new Section();
Section section_3 = new Section();
Section section_4 = new Section();
Section section_5 = new Section();
Section section_6 = new Section();

private class Section
{
  int index = -1; 
  
  String keys = "";
  int num_keys = -1;
  
  float x = -1;
  float y = -1;
}

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases)); //randomize the order of the phrases
    
  // TODO: figure out phone sizing 
  orientation(PORTRAIT); //can also be LANDSCAPE -- sets orientation on android device
  size(800, 800); //Sets the size of the app. You may want to modify this to your device. Many phones today are 1080 wide by 1920 tall.
  input_area_x = width/2;// - sizeOfInputArea/2;
  input_area_y = height/2;// - sizeOfInputArea/2; 
 
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
   
  col1 = width/2 - section_width/2 - padding/2;
  col2 = width/2 + section_width/2 + padding/2;
  
  section_1.keys = letters[0];
  section_1.num_keys = section_1.keys.length();
  section_1.x = col1;
  section_1.y = row1_height;
  section_1.index = 1;
  sections[0] = section_1;
  
  section_2.keys = letters[1];
  section_2.num_keys = section_2.keys.length();
  section_2.x = col2;
  section_2.y = row1_height;  
  section_2.index = 2;
  sections[1] = section_2;
  
  section_3.keys = letters[2];
  section_3.num_keys = section_3.keys.length();
  section_3.x = col1;
  section_3.y = row2_height;
  section_3.index = 3;
  sections[2] = section_3;
  
  section_4.keys = letters[3];
  section_4.num_keys = section_4.keys.length();
  section_4.x = col2;
  section_4.y = row2_height;  
  section_4.index = 4;
  sections[3] = section_4;  
  
  section_5.keys = letters[4];
  section_5.num_keys = section_5.keys.length();
  section_5.x = width/2 - section_width/2 - padding/2;
  section_5.y = row3_height;
  section_5.index = 5;
  sections[4] = section_5;
  
  section_6.keys = letters[5];
  section_6.num_keys = section_6.keys.length();
  section_6.x = width/2 + section_width/2 + padding/2;
  section_6.y = row3_height;  
  section_6.index = 6;
  sections[5] = section_6;   
  
  textFont(createFont("Arial", 24)); //set the font to arial 24
  noStroke(); //my code doesn't use any strokes.
}


void draw_keys(Section S) {
  textAlign(CENTER, CENTER);
  boolean right_side;
  char letter;
  int x; 
  int x_offset;
  int y;
  int y_offset = ((S.index-1) / 2) * (section_height + padding) + section_height;
  println(S.index);
  
  int[] key_x;
  int[] key_y;
  
  switch(S.index) {
    case 1: 
      // TODO: set key (x, y)s here
  }
  
  for (int i = 0; i < S.num_keys; i++) {
    right_side = (S.index % 2 == 1);
    letter = S.keys.charAt(i);
    //x = width/2 + (letter_button_width+padding)*(i-S.num_keys/2);
    if (right_side) {
      x = width/2 - section_width + letter_button_width/2;
      x_offset = (letter_button_width+padding)*(i);
    } else {
      x = width/2 + section_width + letter_button_width/2;
      x_offset = -(letter_button_width+padding)*(S.num_keys - i);
    }
    x = x + x_offset;
    y = y_offset + row1_height - padding - letter_button_width;
    
    if ((abs(mouseX - x) < letter_button_width/2) && 
        (abs(mouseY - y) < letter_button_width)){
      fill(0, 255, 0, 200);
    } else {
      fill(0, 0, 255, 200);
    }
    
    ellipse(x, y, letter_button_width, letter_button_width);
    fill(255);
    textSize(32);
    text(letter, x, y + 2*padding);
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
  textSize(30);
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
  PFont mono = createFont("Monospaced", 30);
  textFont(mono);  

  background(0); //clear background
  textSize(30);

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
    //you will need something like the next 10 lines in your code. Output does not have to be within the 2 inch area!
    textAlign(LEFT); //align the text left
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
    fill(255);
    text("Target:   " + currentPhrase, 70, 100); //draw the target string
    String currentTypedToDisplay = currentTyped;
    if (currentTyped.length() > 0 && currentTyped.charAt(currentTyped.length()-1) == ' ') {
      currentTypedToDisplay = currentTyped.substring(0, currentTyped.length() - 1) + "_";
    }
    text("Entered:  " + currentTypedToDisplay + "|", 70, 140); //draw what the user has entered thus far 
    fill(255, 0, 0);
    rect(800, 00, 200, 200); //drag next button
    fill(255);
    text("NEXT > ", 850, 100); //draw next label

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
      fill(0, 0, 255);
      rect(col1, row0_height, section_width, section_height);
      fill(0);
      text("del", col1, row1_height - section_height + padding);
      
      // space button
      textAlign(CENTER, CENTER);
      fill(0, 0, 255);
      rect(col2, row0_height, section_width, section_height);
      fill(0);
      text("space", col2, row1_height - section_height + padding);
    } else {
      Section S = sections[section-1];
      draw_section(S);
      draw_keys(S);
    }
    noStroke();
  }
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
    return;
  }
  if (overButton(col1 - section_width/2, row1_height-section_height/2, 
                 section_width + padding, section_height)) {
    section = 1;
  } else if (overButton(col2 - section_width/2, row1_height-section_height/2, 
                 section_width + padding, section_height)) {
    section = 2;
  } else if (overButton(col1 - section_width/2, row2_height-section_height/2, 
                 section_width + padding, section_height)) {
    section = 3;
  } else if (overButton(col2 - section_width/2, row2_height-section_height/2, 
                 section_width + padding, section_height)) {
    section = 4;
  } else if (overButton(col1 - section_width/2, row3_height-section_height/2, 
                 section_width + padding, section_height)) {
    section = 5;
  } else if (overButton(col2 - section_width/2, row3_height-section_height/2, 
                 section_width + padding, section_height)) {
    section = 6;
  } else if (overButton(col1 - section_width/2, row0_height-section_height/2, section_width, section_height)) {
    section = 0;
    if (currentTyped.length() > 0) {
      currentTyped = currentTyped.substring(0, currentTyped.length()-1);
    }
  } else if (overButton(col2 - section_width/2, row0_height-section_height/2, section_width, section_height)) {
    section = 0;
    currentTyped += " ";
  } else {
    section = 0;
  }
  println(section);
}

void mouseReleased() {
  if (section != 0) {
    Section S = sections[section-1];
    
    int x;
    int y;
    int y_offset = ((S.index-1) / 2) * (section_height + padding);

    for (int i = 0; i < S.num_keys; i++) {
      x = width/2 + (letter_button_width+padding)*(i-S.num_keys/2);
      if (S.index == 6) {
        x += letter_button_width; 
      }
      x = x - letter_button_width/2;
      y = row1_height - padding - letter_button_width;
      y = y + letter_button_width;
      y = y + y_offset;

      if (abs(mouseX - (x+letter_button_width/2)) < letter_button_width/2 && 
         (abs(mouseY - y) < letter_button_width)) {
        char selected_letter = S.keys.charAt(i);
        currentTyped += selected_letter;
        break;
      }
    }
    section = 0;
  }  
}

void keyPressed() {
  nextTrial(); //if so, advance to next trial
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