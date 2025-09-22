#define digitL portc.f1
#define digitR portc.f2

// Common anode 7-segment display pattern
unsigned char array[] = {
   0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90
};

void main() {
    int i = 0;
    int j, Left_digit = 0, Right_digit = 0;

    TRISB = 0x00;   // PORTB as output (segments)
    TRISC = 0x00;   // PORTC as output (digit control)
    portb = 0x00;
    portc = 0x00;

    while (1) {
        Left_digit = i / 10;
        Right_digit = i % 10;

        for (j = 0; j < 50; j++) {
            // Display Left digit
            portb = array[Left_digit]; // Send pattern
            digitL = 1;                // Enable left digit (common anode = HIGH)
            digitR = 0;                // Disable right digit
            delay_ms(5);              // Small delay
            digitL = 0;               // Turn off left digit

            // Display Right digit
            portb = array[Right_digit];
            digitR = 1;                // Enable right digit
            digitL = 0;                // Disable left digit
            delay_ms(5);
            digitR = 0;                // Turn off right digit
        }

        i++;
        if (i > 99) i = 0;  // Reset after 99
    }
}