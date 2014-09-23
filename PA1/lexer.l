%{
#include "parser-defs.h"
#include "parser.tab.h"

/*
 * You may want to use this string to assemble the lexeme
 * of string constants by adding the current matched character from yytext to it.
 * You can do this as buffer += yytext;
 */
string buffer;


/*
 * You may want to track the comment desting depth with this variable.
 */
int comment_depth = 0;

%}


%option noyywrap

WHITESPACE [ \t\f\r\v]+
NEWLINE [\n]
COMMA [,]
LETTER [a-zA-Z_]
DIGIT [0-9]
STRINGCHARS [a-zA-Z0-9 !#\$\%&'\(\)\*\+,\-\.\/:;\<=\>\?@\[\\\]\^_'\{\|\}~\n]
QUOTE [\"]
ESCAPE[\\]

%x STRING
%x COMMENT 

%%

(?i:lambda) {
	return TOKEN_LAMBDA;
}

(?i:if) {
	return TOKEN_IF;
}

(?i:then) {
	return TOKEN_THEN;
}

(?i:else) {
	return TOKEN_ELSE;
}

(?i:in) {
	return TOKEN_IN;
}

(?i:with) {
	return TOKEN_WITH;
}

(?i:fun) {
	return TOKEN_FUN;
}

(?i:let) {
	return TOKEN_LET;
}

(?i:print) {
	return TOKEN_PRINT;
}

(?i:isNil) {
	return TOKEN_ISNIL;
}

(?i:nil) {
	return TOKEN_NIL;
}

(?i:readString) {
	return TOKEN_READSTRING;
}

(?i:readInt) {
	return TOKEN_READINT;
}

[\.] {
	return TOKEN_DOT;
}

[@] {
	return TOKEN_CONS;
}

[#] {
	return TOKEN_TL;
}

[!] {
	return TOKEN_HD;
}

[+] {
	return TOKEN_PLUS;
}

[-] {
	return TOKEN_MINUS;
}

[*] {
	return TOKEN_TIMES;
}

[//] {
	return TOKEN_DIVIDE;
}

[(] {
	return TOKEN_LPAREN;
}

[)] {
	return TOKEN_RPAREN;
}

[&] {
	return TOKEN_AND;
}

[|] {
	return TOKEN_OR;
}

[=] {
	return TOKEN_EQ;
}

[<] {
	return TOKEN_LT;
}

[>] {
	return TOKEN_GT;
}

"<>" {
	return TOKEN_NEQ;
}

{WHITESPACE} {
  /* Do nothing */
}

{COMMA} {
  return TOKEN_COMMA;
}

[0-9]+ {
	SET_LEXEME(yytext);
 	return TOKEN_INT;
}

<INITIAL,COMMENT>{NEWLINE} {
	curr_lineno++;
}

<INITIAL,COMMENT>"(*" {
	if(++comment_depth == 1) {
		BEGIN (COMMENT);
	}
}

<COMMENT>"*)" {
	if(!--comment_depth) {
		BEGIN (INITIAL);	
	}
}

<COMMENT>. {
	/* wait for comment to end */
}

{QUOTE}[^"]*{QUOTE} {
	buffer = "";
	yytext[strlen (yytext) - 1] = 0;
	buffer += (yytext + 1);
	for (char &c : buffer) {
		if (c == '\n') ++curr_lineno;
	}
	SET_LEXEME(buffer);
	return TOKEN_STRING;
}

{QUOTE}[^"]* {
	string trash = yytext;
	for (char &c : trash)
		if (c == '\n') ++curr_lineno;
	SET_LEXEME("String missing closing quotes");
	return TOKEN_ERROR;
}

{LETTER}({LETTER}|{DIGIT})* {
	SET_LEXEME (yytext);
	return TOKEN_IDENTIFIER;
}
. {
  /* Leave this rule at the end of our lexer to "eat up" all illegal strings */
  SET_LEXEME("Unexpected character in input");
  return TOKEN_ERROR;
}



