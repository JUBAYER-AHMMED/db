char arraycc[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F}; // 0-9
int i;

void main() {
    int number = 7250;   // Starting number
    int digits[4];       // Store individual digits

    TrisB = 0x00;  // 7-segment data port
    TrisC = 0x00;  // Digit select port
    PORTB = 0x00;
    PORTC = 0x00;

    while(1) {
        // Split number into digits
        digits[0] = number / 1000;             // Thousands
        digits[1] = (number / 100) % 10;       // Hundreds
        digits[2] = (number / 10) % 10;        // Tens
        digits[3] = number % 10;               // Units

        // Multiplex 4-digit 7-segment display
        for( i=0; i<100; i++) { // Repeat to maintain display (~1s)
            PORTC.F0 = 0;
            PORTB = arraycc[digits[0]];
            delay_ms(3);
            PORTC.F0 = 1;

            PORTC.F1 = 0;
            PORTB = arraycc[digits[1]];
            delay_ms(3);
            PORTC.F1 = 1;

            PORTC.F2 = 0;
            PORTB = arraycc[digits[2]];
            delay_ms(3);
            PORTC.F2 = 1;

            PORTC.F3 = 0;
            PORTB = arraycc[digits[3]];
            delay_ms(3);
            PORTC.F3 = 1;
        }

        number++;  // Increment number
        if(number > 7300) {
            number = 7250;  // Reset to start
        }
    }
}