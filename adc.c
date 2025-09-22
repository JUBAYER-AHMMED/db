int valADC;         // Variable to hold ADC value
char x[6];          // Allocate enough space for 5-digit ADC + null terminator

void main() {
    UART1_Init(9600);   // Initialize UART
    Delay_ms(100);      // Allow UART to stabilize
    ADC_Init();         // Initialize ADC

    while(1) {
        valADC = ADC_Read(0);       // Read analog input from RA0
        IntToStr(valADC, x);        // Convert to string

        UART1_Write_Text("Analog value = ");
        UART1_Write_Text(x);
        UART1_Write(13);            // Carriage return
        UART1_Write(10);            // Line feed (newline)

        Delay_ms(1000);             // Wait before next read
    }
}