/*** Allard Group jun.allard@uci.edu                    ***/

void initializeStiffSites();

/*******************************************************************************/
//  GLOBAL VARIABLES for initializing stiff sites
/*******************************************************************************/
int stiffEnd, stiffStart;
double stiffiSites[NFILMAX][NMAX];
//
/********************************************************************************************************/
void initializeStiffSites()
{
    //initializes stiffiSites to 0 (none phosphorylated)
    for(nf=0;nf<NFil;nf++)
    {
        for(ty=0;ty<iSiteTotal[nf];ty++)
        {
            stiffiSites[nf][ty]=0;
        }
    }

    if (TALKATIVE)
    {
        for(nf=0;nf<NFil;nf++)
        {
            printf("These are the occupied sites for filament %ld: %s\n", nf, occupiedSites);
        }
    }
    
    //read string and assign to double vector
    // 1 is occupied iSite (phosphorylated), 0 is unoccupied
    for(nf=0;nf<NFil;nf++)
    {
        stiffCase = iSiteTotal[nf];
        
        switch (stiffCase)
        {
            
            case 1:
            
            // eventually want to be able have different phosphorylation settings per iSite per filament
            sscanf(occupiedSites,"%lf", &stiffiSites[nf][0]);
            break;
            
            case 2:
            
            // eventually want to be able have different phosphorylation settings per iSite per filament
            sscanf(occupiedSites,"%lf_%lf", &stiffiSites[nf][0],&stiffiSites[nf][1]);
            break;
                
            case 4:
                
            // eventually want to be able have different phosphorylation settings per iSite per filament
            sscanf(occupiedSites,"%lf_%lf_%lf_%lf", &stiffiSites[nf][0],&stiffiSites[nf][1],&stiffiSites[nf][2],&stiffiSites[nf][3]);
            break;
            
            case 6:
            
            // eventually want to be able have different phosphorylation settings per iSite per filament
            sscanf(occupiedSites,"%lf_%lf_%lf_%lf_%lf_%lf", &stiffiSites[nf][0],&stiffiSites[nf][1],&stiffiSites[nf][2],&stiffiSites[nf][3],&stiffiSites[nf][4],&stiffiSites[nf][5]);
            break;
            
            default:
            printf("Create case for stiffening %d sites.\n",stiffCase);
            fflush(stdout);
            exit(0);
            break;
            
            // could include a case to read occupiedSites from a file of either locations or of 0,1s
            
        }
    }
    
    // for debugging, print which iSites are declared stiff
    if (TALKATIVE)
    {
        for(nf=0;nf<NFil;nf++)
        {
            for (iy=0;iy<iSiteTotal[nf];iy++)
            {
                printf("stiffiSites[ %ld ][ %ld ] =  %f\n",nf,iy, stiffiSites[nf][iy]);
                fflush(stdout);
            }
        }
    }
    
    //initializes stiffened rods to 0 (none stiff)
    for(nf=0;nf<NFil;nf++)
    {
        for(i=0;i<N[nf];i++)
        {
            StiffSites[nf][i] =0;
        }
    }

    /********************************************************/
    /******************* STIFFEN SEGMENTS *******************/
    /********************************************************/
    
    // When Stiffening is implemented in rotations, stiffening at point i means that angle i-2,i-1,i is fixed
    // For intuition's sake, it would be better for stiffening at point i to mean that angle i-1,i,i+1 is fixed
    // Therefore each stiffStart and stiffEnd has an additional '+1' to shift where the fixed angle is located
    
    // Currently do not want to stiffen site 0. If stiffen site 0 then no rotation can occur at base.
    // Need to implement extra condition in rotation code for case where all segments are stiff (no movement - no rotation)
    
    if(StiffenRange != -1) // If StiffenRange is set to -1, then no stiffening occurs. All StiffSites are left at 0.
    {
        for(nf=0;nf<NFil;nf++)
        {
            for(ty=0;ty<iSiteTotal[nf];ty++)
            {
                if(stiffiSites[nf][ty]==1) //might want to check the truth value on this - equals for double?
                {
                    // set beginning of stiffening range
                    if(iSite[nf][ty]-StiffenRange +1 >= 1) // above 0
                    {
                        stiffStart = iSite[nf][ty]-StiffenRange +1; // add one to make iSite fixed point instead of iSite-1
                    }
                    else // if stiffenrange goes below 1, start stiffening at 1 (do not want to stiffen site 0 - see above)
                    {
                        stiffStart = 1;
                    }
                    
                    //set end of stiffening range
                    // if stiffenrange goes above N, end at N
                    if(iSite[nf][ty]+StiffenRange+1 +1 >= N[nf])
                    {
                        stiffEnd = N[nf];
                    }
                    else
                    {
                        stiffEnd=iSite[nf][ty]+StiffenRange+1 +1; // add one to make iSite fixed point instead of iSite-1
                    }
                    
                    // declare which segments are stiff, exclusive of right endpoint (because included +1 above)
                    for(i=stiffStart;i<stiffEnd;i++)
                    {
                        StiffSites[nf][i]=1; //set that joint to "stiff"
                    }
                }
            }
        }
    }

    // for debugging, count and print the total number of stiff segments
    if (TALKATIVE)
    {
        for(nf=0;nf<NFil;nf++)
        {
            totalStiff[nf] = 0;
            for (i=0;i<N[nf];i++)
            {
                if (StiffSites[nf][i]==1)
                {
                    totalStiff[nf]++;
                }
            }
            printf("Total Stiff on filament %ld: %d\n",nf, totalStiff[nf]);
            fflush(stdout);
            
            if (totalStiff[nf] >= N[nf])
            {
                // Include error for completely stiff
                // May cause convergence problems?
                printf("Warning! Filament %ld is completely stiff!\n",nf);
                fflush(stdout);
                
                // exit(0);
            }
        }
    }
}

/********************************************************************************************************/

