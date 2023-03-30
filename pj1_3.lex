%{
#include "stdio.h"
#include "sys/types.h"
#include "ctype.h"
int row=1;
int col=1;
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
BADCHAR     [^DIGITa-zA-Z\t\nOPERATORDELIMITER"]
UNTERSTR    \"[^"\t\n]*"\n"
UNTERCOM    "(*"([^*]|\*+[^*)])*

%%
"\n"        {++row;col=1;}
{KEYWORD}   {fprintf(f2,"%d\t%d\treserved keyword\t%s\n",row,col,yytext);col+=yyleng;}
{ID}        {
            if (yyleng>255)
                 fprintf(f2,"%d\t%d\tidentifier      \tan overly long identifier\n",row,col);
            else fprintf(f2,"%d\t%d\tidentifier      \t%s\n",row,col,yytext);
            col+=yyleng;} 
{DELIMITER} {fprintf(f2,"%d\t%d\tdelimiter       \t%s\n",row,col,yytext);col+=yyleng;}
{OPERATOR}  {fprintf(f2,"%d\t%d\toperator        \t%s\n",row,col,yytext);col+=yyleng;}
{REAL}      {
            if (yyleng-1<32)
                 fprintf(f2,"%d\t%d\treal            \t%s\n",row,col,yytext);
            else fprintf(f2,"%d\t%d\treal            \tan out of range real\n",row,col);
            col+=yyleng;}
{STRING}    {
             int blank_count=0;
             for(int i=0;i<yyleng;i++){
                 if(isspace(yytext[i]))
                 blank_count++;
             }
             if(blank_count==1)fprintf(f2,"%d\t%d\tstring          \tan invalid string with tab in it\n",row,col);
             else if(blank_count>1)fprintf(f2,"%d\t%d\tstring          \tan invalid string with many tabs in it\n",row,col);
             else {
                 if(yyleng>255+2)fprintf(f2,"%d\t%d\tstring          \tan overly long string\n",row,col);
                 else fprintf(f2,"%d\t%d\tstring          \t%s\n",row,col,yytext);
             }
            col+=yyleng;}
{INTEGER}   {
            if (yyleng>8)
                 fprintf(f2,"%d\t%d\tinteger         \tan out of range integer\n",row,col);
            else fprintf(f2,"%d\t%d\tinteger         \t%s\n",row,col,yytext);
            col+=yyleng;}
"\t"        {col+=4;}
" "         {col+=1;}
{COMMENT}   {
	     for(int i=0;i<yyleng;i++){
	     	 if(yytext[i]=='\n'){row++;col=1;} 
	     }
	     }
{BADCHAR}   {fprintf(f2,"%d\t%d\t                \ta bad character (bell)\n",row,col);col+=yyleng;}
{UNTERSTR}  {
	     fprintf(f2,"%d\t%d\t                \tan unterminated string\n",row,col);col=1;row++;}
{UNTERCOM}  {fprintf(f2,"%d\t%d\t                \tan unterminated comment\n",row,col);col+=yyleng;}
            
%%

int main(int argc,char **argv)
{
	f2 = fopen("result3.txt","w");
	FILE *f1 = fopen("tests/case_11.pcat","r");
	fprintf(f2,"tests/case_11.pcat\n");
	fprintf(f2,"ROW\tCOL\tTYPE\t\t\tTOKEN/MESSAGE\n");
	yyin=f1;
	yylex();
	fclose(f1);
	fprintf(f2,"\n");
	fclose(f2);
	return 0;
}

int yywrap()
{
	return 1;
}
