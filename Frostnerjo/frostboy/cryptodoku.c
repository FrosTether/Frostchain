#include <tonc.h>
int main() {
    REG_DISPCNT = DCNT_MODE3 | DCNT_BG2;
    tte_init_bmp(3, &vwf_default, NULL);
    m3_fill(CLR_BLACK);
    while(1) {
        vid_vsync();
        tte_printf("#{P:10,140}NODE SPEED: 906.6 H/s");
        tte_printf("#{P:10,10}FROSTNERJO VALIDATOR v218");
    }
    return 0;
}
