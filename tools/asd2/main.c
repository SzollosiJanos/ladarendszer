#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void swap(int* a, int* b){
    int temp=*a;
    *a=*b;
    *b=temp;
}

char* replaceWord(const char* s, const char* oldW,
                const char* newW)
{
    char* result;
    int i, cnt = 0;
    int newWlen = strlen(newW);
    int oldWlen = strlen(oldW);

    // Counting the number of times old word
    // occur in the string
    for (i = 0; s[i] != '\0'; i++) {
        if (strstr(&s[i], oldW) == &s[i]) {
            cnt++;

            // Jumping to index after the old word.
            i += oldWlen - 1;
        }
    }

    // Making new string of enough length
    result = (char*)malloc(i + cnt * (newWlen - oldWlen) + 1);

    i = 0;
    while (*s) {
        // compare the substring with the result
        if (strstr(s, oldW) == s) {
            strcpy(&result[i], newW);
            i += newWlen;
            s += oldWlen;
        }
        else
            result[i++] = *s++;
    }

    result[i] = '\0';
    return result;
}

int main()
{
    FILE* fp;
    FILE* out;
    fp=fopen("backup.txt","rt");
    out=fopen("output.txt","wt");
    int ladaid,weaponid,skinid,chance,rare,fn,mw,ft,ww,bs,fn_s,mw_s,ft_s,ww_s,bs_s;
    char name[200];
    char* name2;
    int db=1;
    int sum=0;
    while (1)
    {
        fscanf(fp, "%d", &ladaid);
        fscanf(fp, "%d", &weaponid);
        fscanf(fp, "%s", name);
        fscanf(fp, "%d", &skinid);
        fscanf(fp, "%d", &chance);
        fscanf(fp, "%d", &rare);
        fscanf(fp, "%d", &fn);
        fscanf(fp, "%d", &mw);
        fscanf(fp, "%d", &ft);
        fscanf(fp, "%d", &ww);
        fscanf(fp, "%d", &bs);
        fscanf(fp, "%d", &fn_s);
        fscanf(fp, "%d", &mw_s);
        fscanf(fp, "%d", &ft_s);
        fscanf(fp, "%d", &ww_s);
        fscanf(fp, "%d", &bs_s);
        float ifloat;
        sum=fn+mw+ft+ww+bs+fn_s+mw_s+ft_s+ww_s+bs_s;
        sum/=2;
        if(fn>sum){
            printf("unusual data. line: %d\tfn \t%d\n",db,fn);
            printf("%s %d %d %d %d %d %d %d %d %d %d\n\n",name,fn,mw,ft,ww,bs,fn_s,mw_s,ft_s,ww_s,bs_s);
        }
        if(mw>sum){
            printf("unusual data. line: %d\tmw \t%d\n",db,mw);
            printf("%s %d %d %d %d %d %d %d %d %d %d\n\n",name,fn,mw,ft,ww,bs,fn_s,mw_s,ft_s,ww_s,bs_s);
        }
        if(ft>sum){
            printf("unusual data. line: %d\tft \t%d\n",db,ft);
            printf("%s %d %d %d %d %d %d %d %d %d %d\n\n",name,fn,mw,ft,ww,bs,fn_s,mw_s,ft_s,ww_s,bs_s);
        }
        if(ww>sum){
            printf("unusual data. line: %d\tww \t%d\n",db,ww);
            printf("%s %d %d %d %d %d %d %d %d %d %d\n\n",name,fn,mw,ft,ww,bs,fn_s,mw_s,ft_s,ww_s,bs_s);
        }
        if(bs>sum){
            printf("unusual data. line: %d\tbs \t%d\n",db,bs);
            printf("%s %d %d %d %d %d %d %d %d %d %d\n\n",name,fn,mw,ft,ww,bs,fn_s,mw_s,ft_s,ww_s,bs_s);
        }
        if(fn_s>sum){
            printf("unusual data. line: %d\tfn_s \t%d\n",db,fn_s);
            printf("%s %d %d %d %d %d %d %d %d %d %d\n\n",name,fn,mw,ft,ww,bs,fn_s,mw_s,ft_s,ww_s,bs_s);
        }
        if(mw_s>sum){
            printf("unusual data. line: %d\tmw_s \t%d\n",db,mw_s);
            printf("%s %d %d %d %d %d %d %d %d %d %d\n\n",name,fn,mw,ft,ww,bs,fn_s,mw_s,ft_s,ww_s,bs_s);
        }
        if(ft_s>sum){
            printf("unusual data. line: %d\tft_s \t%d\n",db,ft_s);
            printf("%s %d %d %d %d %d %d %d %d %d %d\n\n",name,fn,mw,ft,ww,bs,fn_s,mw_s,ft_s,ww_s,bs_s);
        }
        if(ww_s>sum){
            printf("unusual data. line: %d\tww_s \t%d\n",db,ww_s);
            printf("%s %d %d %d %d %d %d %d %d %d %d\n\n",name,fn,mw,ft,ww,bs,fn_s,mw_s,ft_s,ww_s,bs_s);
        }
        if(bs_s>sum){
            printf("unusual data. line: %d\tbs_s \t%d\n",db,bs_s);
            printf("%s %d %d %d %d %d %d %d %d %d %d\n\n",name,fn,mw,ft,ww,bs,fn_s,mw_s,ft_s,ww_s,bs_s);
        }
        while(1){

            if(fn<mw){swap(&fn,&mw);continue;}
            if(mw<ft){swap(&mw,&ft);continue;}
            if(ft<ww){swap(&ft,&ww);continue;}
            if(ww<bs){swap(&ww,&bs);continue;}

            if(fn_s<mw_s){swap(&fn_s,&mw_s);continue;}
            if(mw_s<ft_s){swap(&mw_s,&ft_s);continue;}
            if(ft_s<ww_s){swap(&ft_s,&ww_s);continue;}
            if(ww_s<bs_s){swap(&ww_s,&bs_s);continue;}

            if(fn_s<fn && fn_s!=0){swap(&fn_s,&fn);continue;}
            if(mw_s<mw && mw_s){swap(&mw_s,&mw);continue;}
            if(ft_s<ft && ft_s){swap(&ft_s,&ft);continue;}
            if(ww_s<ww && ww_s){swap(&ww_s,&ww);continue;}
            if(bs_s<bs && bs_s){swap(&bs_s,&bs);continue;}

            ifloat=(float)fn;
            ifloat*=1.25;
            if(ifloat>fn_s){fn_s=(int)ifloat+1;continue;}

            ifloat=(float)mw;
            ifloat*=1.25;
            if(ifloat>mw_s){mw_s=(int)ifloat+1;continue;}

            ifloat=(float)ft;
            ifloat*=1.25;
            if(ifloat>ft_s){ft_s=(int)ifloat+1;continue;}

            ifloat=(float)ww;
            ifloat*=1.25;
            if(ifloat>ww_s){ww_s=(int)ifloat+1;continue;}

            ifloat=(float)bs;
            ifloat*=1.25;
            if(ifloat>bs_s){bs_s=(int)ifloat+1;continue;}

            break;
        }
        name2 = replaceWord(name, ":", " ");
        fprintf(out,"INSERT INTO `lada_ladaskin`(`ladaid`,`fegyverid`,`skin_name`,`skin_id`,`chance`,`rare`,`fn`,`mw`,`ft`,`ww`,`bs`,`fn_s`,`mw_s`,`ft_s`,`ww_s`,`bs_s`) VALUES (");
        fprintf(out,"%d,%d,%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d);",ladaid,weaponid,name2,skinid,chance,rare,fn,mw,ft,ww,bs,fn_s,mw_s,ft_s,ww_s,bs_s);
        if(ladaid==39 && skinid==10048){
            break;
        }else{
            fprintf(out,"\n");
        }
        db++;
    }


    return 0;
}


