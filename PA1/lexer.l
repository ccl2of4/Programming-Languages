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
LETTER [a-zA-Z]
DIGIT [0-9]

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

[<>] {
	return TOKEN_NEQ;
}

{WHITESPACE} {
  /* Do nothing */
}

{NEWLINE} {
/* Do nothing, but increment line numbers */
 curr_lineno++;
}

{COMMA} {
  return TOKEN_COMMA;
}

[0-9]+ {
	SET_LEXEME(yytext);
 	return TOKEN_INT;
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



