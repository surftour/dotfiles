" Vim syntax file
" Language:		shell (sh) Korn shell (ksh) bash (sh)
" Maintainer:		Dr. Charles E. Campbell, Jr. <Charles.E.Campbell.1@gsfc.nasa.gov>
" Previous Maintainer:	Lennart Schultz <Lennart.Schultz@ecmwf.int>
" Last Change:	Mar 11, 2002
" Version: 36
" Latest:		http://www.erols.com/astronaut/vim/index.html#vimlinks_syntax
"
" Using the following VIM variables:
" b:is_kornshell               if defined, enhance with kornshell syntax
" b:is_bash                    if defined, enhance with bash syntax
"   is_kornshell               if neither b:is_kornshell or b:is_bash is
"                                 defined, then if is_kornshell is set
"                                 b:is_kornshell is default
"   is_bash                    if none of the previous three variables are
"                                 defined, then if is_bash is set b:is_bash is default
"
" This file includes many ideas from �ric Brunet (eric.brunet@ens.fr)

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" b:is_sh is set when "#! /bin/sh" is found;
" However, it often is just a masquerade by bash (typically Linux)
" or kornshell (typically workstations with Posix "sh").
" So, when the user sets "is_bash" or "is_kornshell",
" a b:is_sh is converted into b:is_bash/b:is_kornshell,
" respectively.
if !exists("b:is_kornshell") && !exists("b:is_bash")
  if exists("is_kornshell")
    let b:is_kornshell= 1
    if exists("b:is_sh")
      unlet b:is_sh
    endif
  elseif exists("is_bash")
    let b:is_bash= 1
    if exists("b:is_sh")
      unlet b:is_sh
    endif
  else
    let b:is_sh= 1
  endif
endif

" sh syntax is case sensitive
syn case match

" Clusters: contains=@... clusters
"==================================
syn cluster shCaseEsacList	contains=shCaseStart,shCase,shCaseBar,shCaseIn,shComment,shDeref,shDerefSimple,shCaseCommandSub,shCaseSingleQuote,shCaseDoubleQuote
syn cluster shCommandSubList1	contains=shArithmetic,shDeref,shDerefSimple,shNumber,shPosnParm,shSetList,shSpecial,shSingleQuote,shDoubleQuote,shStatement,shVariable,shSubSh
syn cluster shCommandSubList2	contains=@shCommandSubList1
syn cluster shDblQuoteList	contains=shCommandSub,shDeref,shDerefSimple,shSpecial,shPosnParm
syn cluster shDerefList	contains=shDeref,shDerefSimple,shDerefVar,shDerefSpecial,shDerefWordError
syn cluster shDerefVarList	contains=shDerefOp,shDerefVarArray,shDerefOpError
syn cluster shIdList	contains=shCommandSub,shWrapLineOperator,shIdWhiteSpace,shDeref,shDerefSimple,shSpecial,shRedir
syn cluster shCaseList	contains=@shCommandSubList1,shCaseEsac,shColon,shCommandSub,shCommandSub,shComment,shDo,shEcho,shExpr,shFor,shHereDoc,shIf,shRedir,shSetList,shSource,shStatement,shVariable,bkshFunction,shSpecial
syn cluster shColonList	contains=@shCaseList
syn cluster shEchoList	contains=shDeref,shDerefSimple,shExpr,shSubSh,shSingleQuote,shDoubleQuote
syn cluster shExprList1	contains=shCharClass,shNumber,shOperator,shSingleQuote,shDoubleQuote,shSpecial,shExpr,shDblBrace,shDeref,shDerefSimple
syn cluster shExprList2	contains=@shExprList1,@shCaseList
syn cluster shLoopList	contains=@shCaseList,shTestOpr,shExpr,shDblBrace,shConditional,shCaseEsac
syn cluster shSubShList	contains=@shCaseList
syn cluster shTestList	contains=shCharClass,shComment,shDeref,shDerefSimple,shDoubleQuote,shExpr,shExpr,shNumber,shOperator,shSingleQuote,shSpecial,shTestOpr
syn cluster shFunctionList	contains=@shCaseList,shOperator

" Echo:
" ====
" This one is needed INSIDE a CommandSub, so that `echo bla` be correct
syn region shEcho matchgroup=shStatement start="\<echo\>"  skip="\\$" matchgroup=shOperator end="$" matchgroup=NONE end="[<>;&|()]"me=e-1 end="\d[<>]"me=e-2 end="#"me=e-1 contains=@shEchoList
syn region shEcho matchgroup=shStatement start="\<print\>" skip="\\$" matchgroup=shOperator end="$" matchgroup=NONE end="[<>;&|()]"me=e-1 end="\d[<>]"me=e-2 end="#"me=e-1 contains=@shEchoList

" This must be after the strings, so that bla \" be correct
syn region shEmbeddedEcho contained matchgroup=shStatement start="\<print\>" skip="\\$" matchgroup=shOperator end="$" matchgroup=NONE end="[<>;&|`)]"me=e-1 end="\d[<>]"me=e-2 end="#"me=e-1 contains=shNumber,shSingleQuote,shDeref,shDerefSimple,shSpecialVar,shSpecial,shOperator,shDoubleQuote,shCharClass

" Error Codes
" ===========
syn match   shDoError "\<done\>"
syn match   shIfError "\<fi\>"
syn match   shInError "\<in\>"
syn match   shCaseError ";;"
syn match   shEsacError "\<esac\>"
syn match   shCurlyError "}"
syn match   shParenError ")"
if exists("b:is_kornshell")
 syn match     shDTestError "]]"
endif
syn match     shTestError "]"

" Options interceptor
" ===================
syn match   shOption  "\s[\-+][a-zA-Z0-9]\+\>"ms=s+1
syn match   shOption  "\s--\S\+"ms=s+1

" Operators:
" =========
syn match   shOperator		"[!&;|]"
syn match   shOperator		"\[[[^:]\|\]]"
syn match   shOperator		"!\=="		skipwhite nextgroup=shPattern
syn match   shPattern	contained	"\<\S\+\())\)\@="	contains=shSingleQuote,shDoubleQuote,shDeref

" Subshells:
" =========
syn region shExpr  transparent matchgroup=shExprRegion start="{" end="}"		contains=@shExprList2
syn region shSubSh transparent matchgroup=shSubShRegion start="(" end=")"		contains=@shSubShList

" Tests
"======
syn region  shExpr transparent matchgroup=shRange start="\[" skip=+\\\\\|\\$+ end="\]" contains=@shTestList
syn region  shExpr transparent matchgroup=shStatement start="\<test\>" skip=+\\\\\|\\$+ matchgroup=NONE end="[;&|]"me=e-1 end="$" contains=@shExprList1
syn match   shTestOpr contained "<=\|>=\|!=\|==\|-.\>\|-\(nt\|ot\|ef\|eq\|ne\|lt\|le\|gt\|ge\)\>\|[!=<>]"
if exists("b:is_kornshell") || exists("b:is_bash")
 syn region  shDblBrace matchgroup=Delimiter start="\[\[" skip=+\\\\\|\\$+ end="\]\]"	contains=@shTestList
 syn region  shDblParen matchgroup=Delimiter start="((" skip=+\\\\\|\\$+ end="))"	contains=@shTestList
endif

" Character Class in Range
" ========================
syn match   shCharClass	contained	"\[:\(backspace\|escape\|return\|xdigit\|alnum\|alpha\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|tab\):\]"

" Loops: do, if, while, until
" =====
syn region shDo  transparent matchgroup=shConditional start="\<do\>" matchgroup=shConditional end="\<done\>" contains=@shLoopList
syn region shIf  transparent matchgroup=shConditional start="\<if\>" matchgroup=shConditional end="\<fi\>"   contains=@shLoopList,shDblBrace,shDblParen
syn region shFor matchgroup=shLoop start="\<for\>" end="\<in\>" end="\<do\>"me=e-2	contains=@shLoopList,shDblParen
if exists("b:is_kornshell") || exists("b:is_bash")
 syn cluster shCaseList add=shRepeat
 syn region shRepeat   matchgroup=shLoop   start="\<while\>" end="\<in\>" end="\<do\>"me=e-2	contains=@shLoopList,shDblParen,shDblBrace
 syn region shRepeat   matchgroup=shLoop   start="\<until\>" end="\<in\>" end="\<do\>"me=e-2	contains=@shLoopList,shDblParen,shDblBrace
 syn region shCaseEsac matchgroup=shConditional start="\<select\>" matchgroup=shConditional end="\<in\>" end="\<do\>" contains=@shLoopList
else
 syn region shRepeat   matchgroup=shLoop   start="\<while\>" end="\<do\>"me=e-2	contains=@shLoopList
 syn region shRepeat   matchgroup=shLoop   start="\<until\>" end="\<do\>"me=e-2	contains=@shLoopList
endif

" Case: case...esac
" ====
syn region  shCaseEsac	matchgroup=shConditional start="\<case\>" end="\<esac\>"	contains=@shCaseEsacList
syn keyword shCaseIn	contained skipwhite skipnl in			nextgroup=shCase,shCaseStart,shCaseBar,shComment,shCaseSingleQuote,shCaseDoubleQuote
syn region  shCase	contained skipwhite skipnl matchgroup=shConditional start="[^$()]\{-})"ms=s,hs=e  end=";;" end="esac"me=s-1 contains=@shCaseList nextgroup=shCaseStart,shCase,shCaseBar,shComment
syn match   shCaseBar	contained skipwhite "[^|"`'()]\{-}|"hs=e		nextgroup=shCase,shCaseStart,shCaseBar,shComment,shCaseSingleQuote,shCaseDoubleQuote
syn match   shCaseStart	contained skipwhite skipnl "("		nextgroup=shCase,shCaseBar
syn region  shCaseSingleQuote	matchgroup=shOperator start=+'+ skip=+\\\\\|\\.+ end=+'+	contains=shStringSpecial		skipwhite skipnl nextgroup=shCaseBar	contained
syn region  shCaseDoubleQuote matchgroup=shOperator start=+"+ skip=+\\\\\|\\.+ end=+"+	contains=@shDblQuoteList,shStringSpecial	skipwhite skipnl nextgroup=shCaseBar	contained
syn region  shCaseCommandSub  start=+`+ skip=+\\\\\|\\.+ end=+`+		contains=@shCommandSubList1		skipwhite skipnl nextgroup=shCaseBar	contained

" Misc
"=====
syn match   shWrapLineOperator "\\$"
syn region  shCommandSub   start="`" skip="\\\\\|\\." end="`" contains=@shCommandSubList1

" $(..) is not supported by sh (Bourne shell).  However, apparently
" some systems (HP?) have as their /bin/sh a (link to) Korn shell
" (ie. Posix compliant shell).  /bin/ksh should work for those
" systems too, however, so the following syntax will flag $(..) as
" an Error under /bin/sh.  By consensus of vimdev'ers!
if exists("b:is_kornshell") || exists("b:is_bash")
 syn region shCommandSub matchgroup=shCmdSubRegion start="\$("  skip='\\\\\|\\.' end=")"  contains=@shCommandSubList2
 syn region shArithmetic matchgroup=shArithRegion  start="\$((" skip='\\\\\|\\.' end="))" contains=@shCommandSubList2
 syn match  shSkipInitWS contained	"^\s\+"
else
 syn region shCommandSub matchgroup=Error start="$(" end=")" contains=@shCommandSubList2
endif

if exists("b:is_bash")
 syn cluster shCommandSubList1 add=bashSpecialVariables,bashStatement
 syn cluster shCaseList	 add=bashAdminStatement,bashStatement
 syn keyword bashSpecialVariables contained	BASH	HISTCONTROL	LANG	OPTERR	PWD
 syn keyword bashSpecialVariables contained	BASH_ENV	HISTFILE	LC_ALL	OPTIND	RANDOM
 syn keyword bashSpecialVariables contained	BASH_VERSINFO	HISTFILESIZE	LC_COLLATE	OSTYPE	REPLY
 syn keyword bashSpecialVariables contained	BASH_VERSION	HISTIGNORE	LC_MESSAGES	PATH	SECONDS
 syn keyword bashSpecialVariables contained	CDPATH	HISTSIZE	LINENO	PIPESTATUS	SHELLOPTS
 syn keyword bashSpecialVariables contained	DIRSTACK	HOME	MACHTYPE	PPID	SHLVL
 syn keyword bashSpecialVariables contained	EUID	HOSTFILE	MAIL	PROMPT_COMMAND	TIMEFORMAT
 syn keyword bashSpecialVariables contained	FCEDIT	HOSTNAME	MAILCHECK	PS1	TIMEOUT
 syn keyword bashSpecialVariables contained	FIGNORE	HOSTTYPE	MAILPATH	PS2	UID
 syn keyword bashSpecialVariables contained	GLOBIGNORE	IFS	OLDPWD	PS3	auto_resume
 syn keyword bashSpecialVariables contained	GROUPS	IGNOREEOF	OPTARG	PS4	histchars
 syn keyword bashSpecialVariables contained	HISTCMD	INPUTRC
 syn keyword bashStatement		chmod	fgrep	install	rm	sort
 syn keyword bashStatement		clear	find	less	rmdir	strip
 syn keyword bashStatement		du	gnufind	ls	rpm	tail
 syn keyword bashStatement		egrep	gnugrep	mkdir	sed	touch
 syn keyword bashStatement		expr	grep	mv	sleep	complete
 syn keyword bashAdminStatement	daemon	killproc	reload	start	stop
 syn keyword bashAdminStatement	killall	nice	restart	status
endif

if exists("b:is_kornshell")
 syn cluster shCommandSubList1 add=kshSpecialVariables,kshStatement
 syn cluster shCaseList	 add=kshStatement
 syn keyword kshSpecialVariables contained	CDPATH	HISTFILE	MAILCHECK	PPID	RANDOM
 syn keyword kshSpecialVariables contained	COLUMNS	HISTSIZE	MAILPATH	PS1	REPLY
 syn keyword kshSpecialVariables contained	EDITOR	HOME	OLDPWD	PS2	SECONDS
 syn keyword kshSpecialVariables contained	ENV	IFS	OPTARG	PS3	SHELL
 syn keyword kshSpecialVariables contained	ERRNO	LINENO	OPTIND	PS4	TMOUT
 syn keyword kshSpecialVariables contained	FCEDIT	LINES	PATH	PWD	VISUAL
 syn keyword kshSpecialVariables contained	FPATH	MAIL
 syn keyword kshStatement		cat	expr	less	printenv	strip
 syn keyword kshStatement		chmod	fgrep	ls	rm	stty
 syn keyword kshStatement		clear	find	mkdir	rmdir	tail
 syn keyword kshStatement		cp	grep	mv	sed	touch
 syn keyword kshStatement		du	install	nice	sort	tput
 syn keyword kshStatement		egrep	killall
endif

syn match   shSource	"^\.\s"
syn match   shSource	"\s\.\s"
syn region  shColon	start="^\s*:" end="$\|" end="#"me=e-1 contains=@shColonList

" Comments
"=========
syn cluster	shCommentGroup	contains=shTodo
syn keyword	shTodo	contained	TODO
syn match	shComment		"#.*$" contains=@shCommentGroup

" String and Character constants
"===============================
syn match   shNumber		"-\=\<\d\+\>"
syn match   shSpecial	contained	"\\\d\d\d\|\\[abcfnrtv0]"
syn region  shSingleQuote	matchgroup=shOperator start=+'+ end=+'+		contains=shStringSpecial
syn region  shDoubleQuote     matchgroup=shOperator start=+"+ skip=+\\"+ end=+"+	contains=@shDblQuoteList,shStringSpecial
syn match   shStringSpecial	contained	"[^[:print:]]"
syn match   shSpecial		"\\[\\\"\'`$]"

" File redirection highlighted as operators
"==========================================
syn match	shRedir	"\d\=>\(&[-0-9]\)\="
syn match	shRedir	"\d\=>>-\="
syn match	shRedir	"\d\=<\(&[-0-9]\)\="
syn match	shRedir	"\d<<-\="

" Shell Input Redirection (Here Documents)
if version < 600
 syn region shHereDoc matchgroup=shRedir start="<<\s*\**END[a-zA-Z_0-9]*\**"  matchgroup=shRedir end="^END[a-zA-Z_0-9]*$"
 syn region shHereDoc matchgroup=shRedir start="<<-\s*\**END[a-zA-Z_0-9]*\**" matchgroup=shRedir end="^\s*END[a-zA-Z_0-9]*$"
 syn region shHereDoc matchgroup=shRedir start="<<\s*\**EOF\**"  matchgroup=shRedir end="^EOF$"
 syn region shHereDoc matchgroup=shRedir start="<<-\s*\**EOF\**" matchgroup=shRedir end="^\s*EOF$"
 syn region shHereDoc matchgroup=shRedir start="<<\s*\**\.\**"  matchgroup=shRedir end="^\.$"
 syn region shHereDoc matchgroup=shRedir start="<<-\s*\**\.\**" matchgroup=shRedir end="^\s*\.$"
else
 syn region shHereDoc matchgroup=shRedir start="<<\s*\**\z(\h\w*\)\**"  matchgroup=shRedir end="^\z1$"
 syn region shHereDoc matchgroup=shRedir start="<<-\s*\**\z(\h\w*\)\**" matchgroup=shRedir end="^\s*\z1$"
endif

" Identifiers
"============
syn match  shVariable "\<\([bwglsav]:\)\=\w*\ze="	nextgroup=shSetIdentifier
syn match  shIdWhiteSpace  contained	"\s"
syn match  shSetIdentifier contained	"="	nextgroup=shPattern,shDeref,shDerefSimple,shDoubleQuote,shSingleQuote
if exists("b:is_bash")
  syn region shSetList matchgroup=shStatement start="\<\(declare\|typeset\|local\|export\|unset\)\>[^/]"me=e-1 end="$" end="[|)]"me=e-1 matchgroup=shOperator end="[;&]"me=e-1 matchgroup=NONE end="#\|="me=e-1 contains=@shIdList
  syn region shSetList matchgroup=shStatement start="\<set\>[^/]"me=e-1 end="$"		matchgroup=shOperator end="[;&]"me=e-1 matchgroup=NONE end="[#=]"me=e-1 contains=@shIdList
  syn match  shStatement "\<\(declare\|typeset\|local\|export\|set\|unset\)$"
elseif exists("b:is_kornshell")
  syn region shSetList matchgroup=shStatement start="\<\(typeset\|export\|unset\)\>[^/]"me=e-1 end="$" end="[)|]"me=e-1	matchgroup=shOperator end="[;&]"me=e-1 matchgroup=NONE end="[#=]"me=e-1 contains=@shIdList
  syn region shSetList matchgroup=shStatement start="\<set\>[^/]"me=e-1 end="$"		matchgroup=shOperator end="[;&]"me=e-1 matchgroup=NONE end="[#=]"me=e-1 contains=@shIdList
  syn match  shStatement "\<\(typeset\|set\|export\|unset\)$"
else
  syn region shSetList matchgroup=shStatement start="\<\(set\|export\|unset\)\>[^/]"me=e-1 end="$" end="[)|]"me=e-1 matchgroup=shOperator end="[;&]" matchgroup=NONE end="[#=]"me=e-1 contains=@shIdList
  syn match  shStatement "\<\(set\|export\|unset\)$"
endif

if exists("b:is_bash") || exists("b:is_kornshell")
  " handles functions which start:  Function () {
  syn cluster shCommandSubList1  add=bkshFunction
  syn match   bkshFunction		"^\s*\<\h\w*\>\s*()"	skipwhite skipnl nextgroup=bkshFunctionRegion contains=bkshFunctionParen
  syn region  bkshFunctionRegion transparent contained	matchgroup=Delimiter start="{" end="}" contains=@shFunctionList
  syn match   bkshFunctionParen  contained	"[()]"
endif

" Parameter Dereferencing
" =======================
syn match  shDerefSimple		"\$\w\+"			nextgroup=shDerefVarArray
syn region shDeref		matchgroup=PreProc start="\${" end="}"	contains=@shDerefList nextgroup=shDerefVarArray
syn match  shDerefWordError	contained	"[^}$[]"
if exists("b:is_bash") || exists("b:is_kornshell")
 syn match  shDerefSimple		"\$#"
 syn region shDeref		matchgroup=PreProc start="\${##\=" end="}"	contains=@shDerefList
endif

"        bash : ${!prefix*}
"        bash : ${#parameter}
if exists("b:is_bash")
 syn region shDeref		matchgroup=PreProc start="\${!" end="\*\=}"	contains=@shDerefList,shDerefOp
 syn match  shDerefVar	contained	"{\@<=!\w\+"			nextgroup=@shDerefVarList
endif

syn match  shDerefSpecial	contained	"{\@<=[-*@?0]"			nextgroup=shDerefOp,shDerefOpError
syn match  shDerefSpecial	contained	"\({[#!]\)\@<=[[:alnum:]*@]\+"	nextgroup=@shDerefVarList,shDerefOp
syn match  shDerefVar	contained	"{\@<=\w\+"			nextgroup=@shDerefVarList

" sh ksh bash : ${var[... ]...}  array reference
syn region  shDerefVarArray	contained	matchgroup=shDeref start="\[" end="]"	contains=@shCommandSubList2 nextgroup=shDerefOp,shDerefOpError

"    ksh bash : ${parameter:-word}    word is default value
"    ksh bash : ${parameter:=word}    assign word as default value
"    ksh bash : ${parameter:?word}    display word if parameter is null
"    ksh bash : ${parameter#pattern}  remove small left  pattern
"    ksh bash : ${parameter##pattern} remove large left  pattern
"    ksh bash : ${parameter%pattern}  remove small right pattern
"    ksh bash : ${parameter%%pattern} remove large right pattern
syn match shDerefOpError	contained	":[[:punct:]]"
if exists("b:is_bash") || exists("b:is_kornshell")
 syn cluster shDerefPatternList	contains=shDerefPattern,shDerefString
 syn match  shDerefOp	contained	":\=[-=?]"	nextgroup=@shDerefPatternList
 syn match  shDerefOp	contained	"#\{1,2}"	nextgroup=@shDerefPatternList
 syn match  shDerefOp	contained	"%\{1,2}"	nextgroup=@shDerefPatternList
 syn match  shDerefPattern	contained	"[^{}]\+"	contains=shDeref,shDerefSimple,shDerefPattern,shDerefString,shCommandSub nextgroup=shDerefPattern
 syn region shDerefPattern	contained	start="{" end="}"	contains=shDeref,shDerefSimple,shDerefString,shCommandSub nextgroup=shDerefPattern
 syn region shDerefString	contained	matchgroup=shOperator start=+'+ end=+'+		contains=shStringSpecial
 syn region shDerefString     contained	matchgroup=shOperator start=+"+ skip=+\\"+ end=+"+	contains=@shDblQuoteList,shStringSpecial
endif

"        bash : ${parameter:+word}
"        bash : ${parameter:offset:length}
"        bash : ${parameter//pattern/string}
"        bash : ${parameter//pattern}
if exists("b:is_bash")
 syn match  shDerefOp	contained	":\=+"	nextgroup=@shDerefPatternList
 syn region shDerefOp	contained	start=":[$[:alnum:]]"me=e-1 end=":"me=e-1 contains=@shCommandSubList2 nextgroup=shDerefPOL
 syn match  shDerefPOL	contained	":[^}]\{-1,}"	contains=@shCommandSubList2
 syn match  shDerefOp	contained	"/\{1,2}"	nextgroup=shDerefPat
 syn match  shDerefPat	contained	"[^/}]\{1,}"	nextgroup=shDerefPatStringOp
 syn match  shDerefPatStringOp contained	"/"	nextgroup=shDerefPatString
 syn match  shDerefPatString	contained	"[^}]\{1,}"
endif

" A bunch of useful sh keywords
syn keyword shStatement	break	eval	newgrp	return	ulimit
syn keyword shStatement	cd	exec	pwd	shift	umask
syn keyword shStatement	chdir	exit	read	test	wait
syn keyword shStatement	continue	kill	readonly	trap
syn keyword shConditional	contained	elif	else	then
syn keyword shCondError		elif	else	then

if exists("b:is_kornshell") || exists("b:is_bash")
 syn keyword shFunction	function
 syn keyword shStatement	alias	fg	integer	printf	times
 syn keyword shStatement	autoload	functions	jobs	r	true
 syn keyword shStatement	bg	getopts	let	stop	type
 syn keyword shStatement	false	hash	nohup	suspend	unalias
 syn keyword shStatement	fc	history	print	time	whence

 if exists("b:is_bash")
  syn keyword shStatement	bind	disown	help	popd	shopt
  syn keyword shStatement	builtin	enable	logout	pushd	source
  syn keyword shStatement	dirs
 else
  syn keyword shStatement	login	newgrp
 endif
endif

" Syncs
" =====
if !exists("sh_minlines")
  let sh_minlines = 200
endif
if !exists("sh_maxlines")
  let sh_maxlines = 2 * sh_minlines
endif
exec "syn sync minlines=" . sh_minlines . " maxlines=" . sh_maxlines
syn sync match shCaseEsacSync grouphere	shCaseEsac	"\<case\>"
syn sync match shCaseEsacSync groupthere	shCaseEsac	"\<esac\>"
syn sync match shDoSync	grouphere	shDo	"\<do\>"
syn sync match shDoSync	groupthere	shDo	"\<done\>"
syn sync match shForSync	grouphere	shFor	"\<for\>"
syn sync match shForSync	groupthere	shFor	"\<in\>"
syn sync match shIfSync	grouphere	shIf	"\<if\>"
syn sync match shIfSync	groupthere	shIf	"\<fi\>"
syn sync match shUntilSync	grouphere	shRepeat	"\<until\>"
syn sync match shWhileSync	grouphere	shRepeat	"\<while\>"

" The default highlighting.
hi def link shArithRegion		shShellVariables
hi def link shCaseBar		shConditional
hi def link shCaseIn		shConditional
hi def link shCaseCommandSub		shCommandSub
hi def link shCaseDoubleQuote		shDoubleQuote
hi def link shCaseSingleQuote		shSingleQuote
hi def link shCaseStart		shConditional
hi def link shCmdSubRegion		shShellVariables
hi def link shColon		shStatement

hi def link shDeref		shShellVariables
hi def link shDerefOp		shOperator

hi def link shDerefVar		shDeref
hi def link shDerefPOL		shDerefOp
hi def link shDerefPatString		shDerefPattern
hi def link shDerefPatStringOp	shDerefOp
hi def link shDerefSimple		shDeref
hi def link shDerefSpecial		shDeref
hi def link shDerefString		shDoubleQuote

hi def link shDoubleQuote		shString
hi def link shEcho		shString
hi def link shEmbeddedEcho		shString
hi def link shHereDoc		shString
hi def link shLoop		shStatement
hi def link shOption		shCommandSub
hi def link shPattern		shString
hi def link shPosnParm		shShellVariables
hi def link shRange		shOperator
hi def link shRedir		shOperator
hi def link shSingleQuote		shString
hi def link shSource		shOperator
hi def link shStringSpecial		shSpecial
hi def link shSubShRegion		shOperator
hi def link shTestOpr		shConditional
hi def link shVariable		shSetList
hi def link shWrapLineOperator	shOperator

if exists("b:is_bash")
  hi def link bashAdminStatement	shStatement
  hi def link bashSpecialVariables	shShellVariables
  hi def link bashStatement		shStatement
  hi def link bkshFunction		Function
  hi def link bkshFunctionParen	Delimiter
endif
if exists("b:is_kornshell")
  hi def link kshSpecialVariables	shShellVariables
  hi def link kshStatement		shStatement
  hi def link bkshFunction		Function
  hi def link bkshFunctionParen	Delimiter
endif

hi def link shCaseError		Error
hi def link shCondError		Error
hi def link shCurlyError		Error
hi def link shDerefError		Error
hi def link shDerefOpError		Error
hi def link shDerefWordError		Error
hi def link shDoError		Error
hi def link shEsacError		Error
hi def link shIfError		Error
hi def link shInError		Error
hi def link shParenError		Error
hi def link shTestError		Error
if exists("b:is_kornshell")
  hi def link shDTestError		Error
endif

hi def link shArithmetic		Special
hi def link shCharClass		Identifier
hi def link shCommandSub		Special
hi def link shComment		Comment
hi def link shConditional		Conditional
hi def link shExprRegion		Delimiter
hi def link shFunction		Function
hi def link shFunctionName		Function
hi def link shNumber		Number
hi def link shOperator		Operator
hi def link shRepeat		Repeat
hi def link shSetList		Identifier
hi def link shShellVariables		PreProc
hi def link shSpecial		Special
hi def link shStatement		Statement
hi def link shString		String
hi def link shTodo		Todo

" Current Syntax
" ==============
if exists("b:is_bash")
 let b:current_syntax = "bash"
elseif exists("b:is_kornshell")
 let b:current_syntax = "ksh"
else
 let b:current_syntax = "sh"
endif

" vim: ts=15
