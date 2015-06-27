
#include "xintc.h"
#include "sysace_stdio.h"
#include "fsl.h"
#include "xparameters.h"
#include "string.h"
#include "platform.h"

#define PATH	"a:\\gene"
#define FILE1	"seql1.txt"
#define FILE2	"seql2.txt"
#define DDR2	XPAR_DDR2_SDRAM_MPMC_BASEADDR

typedef struct result
{
	short fill;
	short score;
	short phase;
	short index;
} RESULT;

XIntc intc;
int * iptr3 = 0;
int tmp = 0;
int items = 0;
int running = 0;

void bsw_0_has_data_handler()
{
	getfsl(iptr3[tmp], 2);
	getfsl(iptr3[tmp+1], 2);
	tmp += 2;
	if(tmp >= items) running = 0;
}

int main()
{
	RESULT * rs;
	int * iptr1, * iptr2;
	int i, j;
	int len1, len2;

    init_platform();

    print("\n\r************"); xil_printf("%s %s", __DATE__, __TIME__); print("************\n\r");

    microblaze_disable_interrupts();

    len1 = 0;
    len2 = 0;
    len1 = len1 / 4 + 1;
    len2 = len2 / 4 + 1;

    iptr1 = (int *)DDR2;
    iptr2 = iptr1 + len1 + 10;
    iptr3 = iptr2 + len2 + 10;
    tmp = 0;
    items = 0;
    running = 1;

    i = j = 0;
    while(i<len1 || j<len2)
    {
    	if(i < len1) { putfsl_interruptible(iptr1[i++], 0);}
    	if(j < len2) { putfsl_interruptible(iptr2[j++], 1);}
    	if(running == 0) break;
    }

    while(tmp < items)
    {
    	bsw_0_has_data_handler();
    }

    rs = (RESULT *) iptr3;
    for(i=0; i<(items>>1); i++)
    {
    	xil_printf("%d[%d, %d] \r\n", rs[i].score, rs[i].phase, rs[i].index);
    }

    print("\n\r************ END ************\n\r");
    cleanup_platform();

    return 0;
}

