" Vim syntax file
" Language:	DSSSL
" Maintainer:	Johannes Zellner <johannes@zellner.org>
" Last Change:	Die, 01 Mai 2001 11:41:51 +0200
" Filenames:	*.dsl
" URL:		http://www.zellner.org/vim/syntax/dsl.vim
" $Id: dsl.vim,v 1.5 2001/05/01 20:52:31 joze Exp $

if exists("b:current_syntax") | finish | endif

runtime syntax/xml.vim
syn cluster xmlRegionHook add=dslRegion,dslComment
syn cluster xmlCommentHook add=dslCond

" EXAMPLE:
"   <![ %output.html; [
"     <!-- some comment -->
"     (define html-manifest #f)
"   ]]>
"
" NOTE: 'contains' the same as xmlRegion, except xmlTag / xmlEndTag
syn region  dslCond matchgroup=dslCondDelim start="\[\_[^[]\+\[" end="]]" contains=xmlCdata,@xmlRegionCluster,xmlComment,xmlEntity,xmlProcessing,@xmlRegionHook

" NOTE, that dslRegion and dslComment do both NOT have a 'contained'
" argument, so this will also work in plain dsssl documents.

syn region dslRegion matchgroup=Delimiter start=+(+ end=+)+ contains=dslRegion,dslString,dslComment
syn match dslString +"\_[^"]*"+ contained
syn match dslComment +;.*$+ contains=dslTodo
syn keyword dslTodo contained TODO FIXME XXX display

" The default highlighting.
hi def link dslTodo		Todo
hi def link dslString		String
hi def link dslComment		Comment
" compare the following with xmlCdataStart / xmlCdataEnd
hi def link dslCondDelim	Type

let b:current_syntax = "dsl"
