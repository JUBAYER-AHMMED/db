#define digitL portc.f1
#define digitR portc.f2

unsigned char array[] = {
   0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90
};

void displayNumber(int num) {
    int Left_digit = num / 10;
    int Right_digit = num % 10;

    // Left digit
    portb = array[Left_digit];
    digitL = 1;
    digitR = 0;
    delay_ms(2);
    digitL = 0;

    // Right digit
    portb = array[Right_digit];
    digitR = 1;
    digitL = 0;
    delay_ms(2);
    digitR = 0;
}

void main() {
    int i = 0;
    int countUpPressed = 0, countDownPressed = 0;

    TRISB = 0;
    TRISC = 0;
    TRISD.F0 = 1;
    TRISD.F1 = 1;

    portb = 0;
    portc = 0;

    while (1) {
        displayNumber(i);

        if (PORTD.F0 == 1 && countUpPressed == 0) {
            i++;
            if (i > 99) i = 0;
            countUpPressed = 1;
        }
        if (PORTD.F0 == 0) {
            countUpPressed = 0;
        }

        if (PORTD.F1 == 1 && countDownPressed == 0) {
            i--;
            if (i < 0) i = 0;
            countDownPressed = 1;
        }
        if (PORTD.F1 == 0) {
            countDownPressed = 0;
        }
    }
}