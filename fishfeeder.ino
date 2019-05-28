#include <Servo.h> 

#define ONE_SEC 1000ul
#define ONE_MIN (60*ONE_SEC)
#define ONE_HOUR (60*ONE_MIN)

#define FIRST_FEED	  (20*ONE_SEC)  // Delay for the first feed after PON
#define NEXT_FEED	  (24*ONE_HOUR) // Delay for subsequent feeds

#define SERVO_OUT 9 // Servo motor output, P2.4

#define _HIGH_(x) digitalWrite( (x), HIGH )
#define _LOW_(x) digitalWrite( (x), LOW )

Servo myservo;  // Create servo object to control a servo 
unsigned long last_time, next_time, now, rem_time; 

void mark_time() { last_time = millis(); }
unsigned long millis_elapsed() { return millis() - last_time; }
int hours_elapsed() { return millis_elapsed() / ONE_HOUR; }
int minutes_elapsed() { return millis_elapsed() / ONE_MIN; }

/**
 * Check for BTN2 press
 */
int btnPressed()
{
  if( LOW == digitalRead( PUSH2 ) )
    delay( 20 ); // de-bounce
  return LOW == digitalRead( PUSH2 );
}

/**
 * Blink a LED once.
 * 
 * @param what must be GREEN_LED or RED_LED
 * @param dly is the duration in millis
 */
void blink( int what, int dly )
{
    _HIGH_( what ); delay( dly / 2 );
    _LOW_( what ); delay( dly / 2 );
}

/**
 * Show hours and minutes on the LEDs.
 * 
 * RED_LED show the hours, GREEN_LED - minutes. Long blinks are for 
 * tens, short blinks - for ones.
 * 
 * @param h hours
 * @param n minutes
 */
void show_hr_mn( int h, int n )
{
	int i;
	
	for( i = 0; i < h / 10; i++ )
		blink( RED_LED, 1500 ); 
	for( i = 0; i < h % 10; i++ )
		blink( RED_LED, 500 ); 
	for( i = 0; i < n / 10; i++ )
		blink( GREEN_LED, 1500 ); 
	for( i = 0; i < n % 10; i++ )
		blink( GREEN_LED, 500 ); 
}

/**
 * Show elapsed hours/minutes since the last mark_time().
 */
void show_elapsed()
{
  show_hr_mn( hours_elapsed(), minutes_elapsed() % 60 );
}  

/**
 * Setup procedure.
 */
void setup() 
{ 
  pinMode( RED_LED, OUTPUT );   // Red is an output     
  pinMode( GREEN_LED, OUTPUT ); // Green is an output     
  pinMode( PUSH2, INPUT_PULLUP ); // Push button is an input w/ pull-up
  myservo.attach( SERVO_OUT );  // Attaches the servo on pin
  mark_time(); // Mark starting time

  // Lit both LEDs for a second
  _HIGH_( RED_LED ); _HIGH_( GREEN_LED );
  delay( 1000 );

  // Dim both LEDs
  _LOW_( RED_LED ); _LOW_( GREEN_LED );
  delay( 1000 );

  // Engage the 1-st delay after PON
  next_time = millis() + FIRST_FEED;
} 

void loop() 
{ 
	rem_time = next_time - millis(); // Remaining time 
	while( rem_time > 110 ) // unsigned! minimal delay of 100! 
	{
		if( rem_time > ONE_MIN ) 
		{
      // Show the remaining hours/minutes to the next feed
			show_hr_mn( 
				rem_time / ONE_HOUR, 
				rem_time / ONE_MIN % 60 ); 
			delay( 20 * ONE_SEC ); // Delay 20 seconds
		}
    // If less than a minute, blink 
		else if( rem_time > 10 * ONE_SEC )
		{
			if( btnPressed() )
				break; // Exit loop if button pressed
			blink( GREEN_LED, 300 ); // Blink
		}			
    // If less than 10 seconds, intense blink
		else
		{
			if( btnPressed() )
				break; // Exit loop if button pressed
			blink( GREEN_LED, 100 ); // Intense blink
		}
		rem_time = next_time - millis(); // Calc remaining
	}

  // Engage the next feeding time
	next_time = millis() + NEXT_FEED + rem_time;
	
	if( btnPressed() )
		return; // If the button still pressed, skip the servo movement
	
	myservo.write( 180 );   // Turn to 180deg
	delay( 1000 );          // Delay until servo reaches position

	delay( 1000 );

	myservo.write( 0 );     // Turn to 0deg
	delay( 1000 );          // Delay until servo reaches position
} 
