#include <tonc.h>
int main() {
    REG_DISPCNT = DCNT_MODE3 | DCNT_BG2;
    tte_init_bmp(3, &vwf_default, NULL);
    m3_fill(CLR_MAGENTA);
    while(1) {
        vid_vsync();
        tte_printf("#{P:40,70}FROSTCRUSH GBA");
        tte_printf("#{P:30,90}ASSET BURNER ACTIVE");
    }
    return 0;
}
