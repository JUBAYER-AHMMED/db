#define digitL portc.f0
#define digitR portc.f1

// Common anode 7-segment patterns for digits 0–9
char arrayca[] = { 0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90 };
unsigned char array[] = { 0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90 };

void main() {
    int j;
    int m;
    int Left_digit = 0, Right_digit = 0;
    int bt_zero = 0, bt_one = 0;
    int number = 0;

    int fromIndex = -1;
    int toIndex = -1;
    int confirmStep = 0;   // 0 = waiting FROM, 1 = waiting TO

    TrisB = 0x00; // segments output
    TrisC = 0x00; // digit control output
    TRISD.F0 = 1; // button 0
    TRISD.F1 = 1; // button 1
    TRISD.F7 = 1; // confirm button

    PortB = 0x00;
    PortC = 0x00;
    PortD = 0x00;

    while (1) {
        // Button increment logic
        if (PortD.F0 == 1) {
            Delay_ms(20);
            if (PortD.F0 == 1) {
                bt_zero++;
                if (bt_zero == 10) bt_zero = 0;
            }
        }

        if (PortD.F1 == 1) {
            Delay_ms(20);
            if (PortD.F1 == 1) {
                bt_one++;
                if (bt_one == 10) bt_one = 0;
            }
        }

        // Update current number
        number =  bt_zero * 10 + bt_one ;

        // Confirm button pressed
        if (PortD.F7 == 1) {
            Delay_ms(20);
            if (PortD.F7 == 1) {
                if (confirmStep == 0) {
                    fromIndex = number;   // save FROM
                    confirmStep = 1;
                } else if (confirmStep == 1) {
                    toIndex = number;     // save TO
                    confirmStep = 2;      // done, start iteration
                }
            }
        }

        // If confirmed, start iteration from FROM ? TO
        if (confirmStep == 2) {
            m = fromIndex;  // initialize once

            while (1) {
                Left_digit = m / 10;
                Right_digit = m % 10;

                // Refresh both digits multiple times for stable display
                for (j = 0; j < 20; j++) {  // adjust 20 for display duration
                    // Left digit
                    portb = array[Left_digit];
                    digitL = 1; digitR = 0;
                    delay_ms(3);
                    digitL = 0;

                    // Right digit
                    portb = array[Right_digit];
                    digitR = 1; digitL = 0;
                    delay_ms(3);
                    digitR = 0;
                }

                // Increment number
                m++;
                if (m > toIndex) m = fromIndex;  // loop back
            }
        }

        // Display digits normally (before confirmation)
        PortC.F0 = 1;
        PortB = arrayca[bt_zero];
        Delay_ms(2);
        PortC.F0 = 0;

        PortC.F1 = 1;
        PortB = arrayca[bt_one];
        Delay_ms(2);
        PortC.F1 = 0;
    }
}