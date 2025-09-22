// LED Flasher with PIC16F877A
void main() {
   TRISB = 0x00;   // Set PORTB as Output
   PORTB = 0x00;   // Initialize PORTB as LOW

   while(1) {
   int i;
   for(i = 1000; i < 6000;i+=1000)
   {
   PORTB.F0 = 1;
   vdelay_ms(i);
   PORTB.F0 = 0;   // LED OFF
   vdelay_ms(6000-i);
   }

         // LED ON (RB0)
        // 500 ms Delay
        // 500 ms Delay
   }
}