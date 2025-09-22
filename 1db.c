char array[] = {0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90};

void main()
{
    int i;

    TRISB = 0x00;
    TRISD = 0xFF;


    i = EEPROM_Read(0x00);
    if (i < 0 || i > 9) i = 0;

    PORTB = array[i];

    while (1)
    {
        if (PORTD.F0 == 0xFF)
        {
            delay_ms(200);
            if (PORTD.F0 == 0xFF)
            {
                if (i < 9)
                {
                    i++;
                    PORTB = array[i];
                    EEPROM_Write(0x00, i);
                    delay_ms(10);
                }
            }
        }

        if (PORTD.F1 == 0xFF)
        {
            delay_ms(200);
            if (PORTD.F1 == 0xFF)
            {
                if (i > 0)
                {
                    i--;
                    PORTB = array[i];
                    EEPROM_Write(0x00, i);
                    delay_ms(10);
                }
            }
        }
    }
}