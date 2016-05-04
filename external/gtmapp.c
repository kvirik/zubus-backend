#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main ()
{

    /* Where GT.M lives */
    char gtmdir [] = "/usr/local/gtm";

    /* Where the application lives */
    char appdir []  = "/usr/local/gtm/avto";

    /* Where the user applications lives */
    char uappdir []  = "/usr/local/gtm/avto/user /usr/local/gtm/avto/sys";

    /* GT.M database descriptor file */
    char gtmdb []  = "/usr/local/gtm/avto/db/mumps.gld";

    /* MUMPS program to execute */
    char mumpspgm [] = "^%WCGI";

    /* GTMXC_gtmwin library path */
    char xcpath [] = "/usr/local/gtm/gtmwin.xc";

    char routpath [256];
    char execute [256];
    char gtmgbldir [256];

    setenv("gtm_dist", gtmdir, 1);
    setenv("GTMXC_gtmwin", xcpath, 1);

    sprintf(gtmgbldir, "%s", gtmdb);
    setenv("gtmgbldir", gtmgbldir, 1);

    sprintf (routpath, "%s %s", gtmdir, uappdir);
    setenv("gtmroutines", routpath, 1);

    sprintf(execute,"cd %s;%s/mumps -run %s", appdir, gtmdir, mumpspgm);

    if (system(execute)) /* Invoke GT.M */
    { /* Error occured */
        printf("CONTENT-TYPE: TEXT/PLAIN\n\nError!!!\n");
        printf("gtmdir      = %s\n", gtmdir);
        printf("database    = %s\n", gtmdb);
        printf("gtmgbldir   = %s\n", getenv("gtmgbldir"));
        printf("gtmroutines = %s\n", getenv("gtmroutines"));
        printf("gtm_dist    = %s\n", getenv("gtm_dist"));
        printf("execute     = %s\n", execute);
    }
}
