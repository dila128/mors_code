module Encryption(
    input wire clk,
    input wire rst,
    input wire red_btn,   // Kırmızı buton
    input wire blue_btn,  // Mavi buton
    input wire green_btn, // Yeşil buton 
    output reg red_led,   // Kırmızı LED
    output reg blue_led,  // Mavi LED
    output reg green_led  // Yeşil LED
);

    reg [7:0] input_data;         // Giriş veri
    reg [7:0] output_data;        // Şifrelenmiş veri 
    reg [7:0] symbol_index;       // Sembol indeksi
    reg [7:0] symbol_time;        // Sembol süresi
    reg [7:0] symbol_list[7:0];   // Huffman kodlarının listesi

    // Huffman kodlarının tanımlanması
    initial begin
        symbol_list[0] = 8'b00000000; // A
        symbol_list[1] = 8'b00000001; // B
        symbol_list[2] = 8'b00000010; // C
        // Diğer harfler için huffman kodlarını ekleyin
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            input_data <= 8'b0;
            output_data <= 8'b0;
            symbol_index <= 3'b0;
            symbol_time <= 5'b0;
            red_led <= 1'b0;
            blue_led <= 1'b0;
            green_led <= 1'b0;
        end else begin
            // Giriş veriyi oku
            if (red_btn) begin
                input_data <= input_data + 1;
                symbol_index <= 3'b0;
                symbol_time <= 5'b0;
                red_led <= 1'b1;
            end else if (blue_btn) begin
                symbol_index <= symbol_index + 1;
                symbol_time <= 5'b0;
                blue_led <= 1'b1;
            end else if (green_btn) begin
                symbol_time <= symbol_time + 1;
                green_led <= 1'b1;
            end else begin
                red_led <= 1'b0;
                blue_led <= 1'b0;
                green_led <= 1'b0;
            end

            // Sesli harfleri atla
            if (input_data[6:0] == 7'b0110001 || input_data[6:0] == 7'b0110101 || input_data[6:0] == 7'b0111001 || input_data[6:0] == 7'b0111111 || input_data[6:0] == 7'b1000111 || input_data[6:0] == 7'b1010111 || input_data[6:0] == 7'b1100111) begin
                input_data <= input_data + 1;
            end

            // Huffman kodlama yap
            output_data <= symbol_list[symbol_index];

            // Sembol süresine göre LED'leri kontrol et
            if (symbol_time >= output_data[4:0]) begin
                red_led <= 1'b0;
                blue_led <= 1'b0;
                green_led <= 1'b0;
            end 
        end
    end

endmodule
