%{
#include "stdio.h"
#include "sys/types.h"
int lines;
int words;
char *directory[]={"tests/case_1.pcat","tests/case_2.pcat","tests/case_3.pcat","tests/case_4.pcat","tests/case_5.pcat","tests/case_6.pcat","tests/case_7.pcat","tests/case_8.pcat","tests/case_9.pcat","tests/case_10.pcat"};

%}
%option     nounput

DIGIT       [0-9]
INTEGER     {DIGIT}+
REAL        {DIGIT}+"."{DIGIT}*
KEYWORD     AND|ARRAY|BEGIN|BY|DIV|DO|ELSE|ELSIF|END|EXIT|FOR|IF|IN|IS|LOOP|MOD|NOT|OF|OR|OUT|PROCEDURE|PROGRAM|READ|RECORD|RETURN|THEN|TO|TYPE|VAR|WHILE|WRITE
STRING      \"[^"\n]*\"
ID          [a-zA-Z][a-zA-Z0-9]*
OPERATOR    ":="|"+"|"-"|"*"|"/"|"<"|"<="|">"|">="|"="|"<>"
DELIMITER   ":"|";"|","|"."|"("|")"|"["|"]"|"{"|"}"|"<"|">"
COMMENT     "(*"([^*]|\*+[^*)])*\*+")"

%%
"\n"        {lines++;}
{KEYWORD}   {words++;}
{ID}        {words++;}
{DELIMITER} {words++;}
{OPERATOR}  {words++;}
{REAL}      {words++;}
{STRING}    {words++;}
{INTEGER}   {words++;}
" "         {;}/*do nothing*/
"\t"        {;}
{COMMENT}   {
	     for(int i=0;i<yyleng;i++){
	     	 if(yytext[i]=='\n'){lines++;} 
	     }
	     }

%%

int main(int argc,char **argv)
{
	FILE *f2 = fopen("result.txt","w");
	for(int i=0;i<10;i++)
	{
	lines=0;
        words=0;
	FILE *f1 = fopen(directory[i],"r");
	yyin=f1;
	yylex();
	fprintf(f2,"%s\t",directory[i]);
	fprintf(f2,"words:%d\t",words);
	fprintf(f2,"lines:%d\t\n",lines);
	fclose(f1);
	}
	fclose(f2);
	return 0;
}

int yywrap()
{
	return 1;
}
