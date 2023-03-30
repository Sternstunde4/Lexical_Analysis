%{
#include "stdio.h"
#include "sys/types.h"
int row;
int col;
char *directory[]={"tests/case_1.pcat","tests/case_2.pcat","tests/case_3.pcat","tests/case_4.pcat","tests/case_5.pcat","tests/case_6.pcat","tests/case_7.pcat","tests/case_8.pcat","tests/case_9.pcat","tests/case_10.pcat"};
FILE *f2;
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
"\n"        {++row;col=1;}
{KEYWORD}   {fprintf(f2,"%d\t%d\treserved keyword\t%s\n",row,col,yytext);col+=yyleng;}
{ID}        {fprintf(f2,"%d\t%d\tidentifier      \t%s\n",row,col,yytext);col+=yyleng;} 
{DELIMITER} {fprintf(f2,"%d\t%d\tdelimiter       \t%s\n",row,col,yytext);col+=yyleng;}
{OPERATOR}  {fprintf(f2,"%d\t%d\toperator        \t%s\n",row,col,yytext);col+=yyleng;}
{REAL}      {fprintf(f2,"%d\t%d\treal            \t%s\n",row,col,yytext);col+=yyleng;}
{STRING}    {fprintf(f2,"%d\t%d\tstring          \t%s\n",row,col,yytext);col+=yyleng;}
{INTEGER}   {fprintf(f2,"%d\t%d\tinteger         \t%s\n",row,col,yytext);col+=yyleng;}
"\t"        {col+=4;}
" "         {col+=1;}
{COMMENT}   {
	     for(int i=0;i<yyleng;i++){
	     	 if(yytext[i]=='\n'){row++;col=1;} 
	     }
	     }

%%

int main(int argc,char **argv)
{
	f2 = fopen("result2.txt","w");
	for(int i=0;i<10;i++)
	{
	row=1;
	col=1;
	FILE *f1 = fopen(directory[i],"r");
	fprintf(f2,"%s\n",directory[i]);
	fprintf(f2,"ROW\tCOL\tTYPE\t\t\tTOKEN/MESSAGE\n");
	yyin=f1;
	yylex();
	fclose(f1);
	fprintf(f2,"\n");
	}
	fclose(f2);
	return 0;
}

int yywrap()
{
	return 1;
}
