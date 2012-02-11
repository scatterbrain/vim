" ------------------------------------------------------------------------------
" Vim omni-completion script
" Author: Oscar Hellström
" Email: oscar@oscarh.net
" Version: 2006-06-23
" ------------------------------------------------------------------------------

" Patterns for completions {{{1
let s:erlangLocalFuncBeg    = '\(\<[0-9A-Za-z_-]*\|\s*\)$'
let s:erlangExternalFuncBeg = '\<[0-9A-Za-z_-]\+:[0-9A-Za-z_-]*$'
let s:ErlangBlankLine       = '^\s*\(%.*\)\?$'

" Main function for completion {{{1
function! erlangcomplete#Complete(findstart, base)
	" 0) Init {{{2
	let lnum = line('.')
	let column = col('.') 
	let line = strpart(getline('.'), 0, column - 1)

	let _ = []

	" 1) First, check if completion is impossible {{{2
"	if line =~ '[^~\\]%'
"		return -1
"	endif

"	echo "fs: " .a:findstart. " b:" . a:base." \n line" . line ." line[col - 1]:" . line[column - 1] . " line[col - 2]:" . line[column - 2] .  "\n" . line . "\n"
"


	" Determine context in which we are running 
	let l:linestart = strpart(line, 0, column)
"		echo "asd |" . linestart. "|\n" . line
"
	let l:context = 'none'

	let record_matches_list = matchlist(linestart, '#\s*\(\l\w*\)\?[\s\n]*\([.{]\)\?[\s\n]*\(\l\w*\)\?')

	if !empty(record_matches_list)
	" we are dealing with record definition
		let [ found_part, record_name, record_access, record_field ; l:_ ] = record_matches_list

		if (record_name == '') 
			" we are at   Z#
			"               ^^^ here
			
			" we should complete with record names
			let context = 'records_show_all'
		elseif (record_access == "") 
			" we can get record name Z#reco
			"                              ^^^^
			"
			" we should complete from existing record names...
			let context = 'records_complete'
		elseif (record_access == ".")
			" we are at  Z#record.
			"                     ^^^ shoudl complete with list of fields
			let context = 'records_fields_complete'
		elseif (record_access == "{")
			" we are inside recods definition
			
			let match_pos_end = stridx(line, found_part) + len(found_part)
			if (match_pos_end >= column - 2)
				" XXX: very dumb assertion
				" we do record field completition only in
				" next 2 symbols to opening curly brace {
				" which is not good 
				" TODO: how find are we in a record definition or not?
				let context = 'records_fieldsname_complete'
			endif
		endif
	endif

	let macro_matches_list = matchlist(linestart, '?\(\l\w*\)\?$')

	if !empty(macro_matches_list)
	" we are dealing with record definition
		let [ @_, macro_name ; l:_ ] = macro_matches_list

		if macro_name == ""
			" completing list of all macroses
			" we are at ?
			"            ^ here
			let context = 'macros_show_all'
		else
			" we are at ?ma
			"              ^^^ completing macro name
			let context = 'macros_complete'
		endif
	endif

	if (context == 'records_show_all' || context == 'records_complete') 
		if a:findstart
			return column - len(record_name) - 1
		else
			return s:erlangFindLocalRecords(a:base)
		endif
	elseif (context == 'records_fields_complete' || context == 'records_fieldsname_complete')
		if a:findstart
			return column - len(record_field) - 1
		else
			return s:erlangFindRecordFields(record_name, a:base)
		endif
	elseif (context == 'macros_show_all' || context == 'macros_complete')
		if a:findstart
			return column
			return column - len(macro_name) - 2
		else
			return s:erlangFindMacroDef(a:base)
		endif
	endif


	" 2) Check if the char to the left of us are part of a function call {{{2
	"
	" Nothing interesting is written at the char just before the cursor
	" This means _anything_ could be started here
	" In this case, keyword completion should probably be used,
	" for now we'll only try and complete local functions.
	" TODO: Examine if we can stare Identifiers end complete on them
	" Is this worth it? Is /completion/ of a "blank" wanted? Can we consider (
	" interesting and check if we are in a function call etc.?
	if line[column - 2] !~ '[0-9A-Za-z:_-]'
		if a:findstart
			return column
		else
			return s:erlangFindLocalFunc(a:base)
		endif
	endif
	

	" 3) Function in external module {{{2
	if line =~ s:erlangExternalFuncBeg
		let delimiter = match(line, ':[0-9A-Za-z_-]*$') + 1
		if a:findstart
			return delimiter
		else
			let module = matchstr(line, '\(\<\)\@<=[0-9A-Za-z_-]\+:\@=')
			return s:erlangFindExternalFunc(module, a:base)
		endif
	endif

	" 4) Local function {{{2
	if line =~ s:erlangLocalFuncBeg
		let funcstart = match(line, ':\@<![0-9A-Za-z_-]*$')
		if a:findstart
			return funcstart
		else
			return s:erlangFindLocalFunc(a:base)
		endif
	endif

	" 5) Unhandled situation {{{2
	if a:findstart
		return -1
	else
		return []
	endif
endfunction

" Auxiliary functions for completion {{{1 
" Find the next non-blank line {{{2
function! s:erlangFindNextNonBlank(lnum)
	let lnum = nextnonblank(a:lnum + 1)
	let line = getline(lnum)
	while line =~ s:ErlangBlankLine && 0 != lnum
		let lnum = nextnonblank(lnum + 1)
		let line = getline(lnum)
   endwhile
   return lnum
endfunction
			
" vim: foldmethod=marker:
" Find external function names {{{2
function! s:erlangFindExternalFunc(module, base)
	let functions = []

	if (g:erl_connection) 
		erlcall 'funclist' 'vistel' 'functions' '[' . a:module. ', "' . a:base . '"]'

		if (funclist[0] == 'ok' && len(funclist[1]) > 0)
			"			let f = map(funclist[1], "{'word': v:val, 'kind': 'f'}")
			"			return f
			let f = []
			for funName in funclist[1]
				erlcall 'funcArgs' 'vistel' 'get_arglists' '["' . a:module. '", "' . funName . '"]'

				let funcArgs = map(funcArgs,"'(' . join(v:val, ',').')'")
				let funcArgs1 = join(funcArgs, "|")

				call complete_add({'word': funName, 'kind': 'f', 'menu': funcArgs1})
				unlet funcArgs
			endfor

			return []
		endif
	endif

	return functions
endfunction

" Find local function names {{{2
function! s:erlangFindLocalFunc(base)
	" begin at line 1
	let lnum = s:erlangFindNextNonBlank(1)
	if "" == a:base
		let base = '\w' " used to match against word symbol
	else
		let base = a:base
	endif
	while 0 != lnum && !complete_check()
		let line = getline(lnum)
		let function_name = matchstr(line, '^' . base . '[0-9A-Za-z_-]\+(\@=')
		if function_name != ""
			call complete_add(function_name)
		endif
		let lnum = s:erlangFindNextNonBlank(lnum)
	endwhile

	if (g:erl_connection) 
		erlcall 'module_list' 'vistel' 'modules' '["'. a:base .'"]'

		if (module_list[0] == 'ok')
			let m = map(module_list[1], "{'word': v:val, 'kind': 'm'}")
			return m
		endif
	endif

	return []
endfunction


" Find available records {{{2
function! s:erlangFindLocalRecords(base)
	" begin at line 1
	let lnum = s:erlangFindNextNonBlank(1)
	if "" == a:base
		let base = '\w' " used to match against word symbol
	else
		let base = a:base
	endif
	while 0 != lnum && !complete_check()
		let line = getline(lnum)
		let record_name_list = matchlist(line, '^\s*-record(\(' . a:base . '[0-9A-Za-z_-]\+\),\@=')
		if !empty(record_name_list)
			call complete_add(record_name_list[1])
		endif
		let lnum = s:erlangFindNextNonBlank(lnum)
	endwhile

	if (g:erl_connection) 
		let this_file = expand("%:p")
		erlcall 'record_lst' 'vistel' 'records_list' '["'. this_file .'","'. a:base .'"]'
"		echo '["'. this_file .'","'. a:base .'"]'
"		echo record_lst
"		call getchar()

		if (record_lst[0] == 'ok')
			let r = map(record_lst[1], "{'word': v:val, 'kind': 'r'}")
			return r
		endif
	endif
	

	return []
endfunction


" Find record field names {{{2
function! s:erlangFindRecordFields(record_name, base)
	" begin at line 1
	"
	if (g:erl_connection) 
		let this_file = expand("%:p")
		erlcall 'record_lst' 'vistel' 'record_fields' '["'. this_file .'","'.a:record_name.'","'. a:base .'"]'

		if (record_lst[0] == 'ok')
			let r = map(record_lst[1], "{'word': v:val, 'kind': 'rf'}")
			return r
		endif
	endif

	return []
endfunction

" Find macro definitions {{{2
function! s:erlangFindMacroDef(base)
	" begin at line 1
	let lnum = s:erlangFindNextNonBlank(1)
	if "" == a:base
		let base = '\w' " used to match against word symbol
	else
		let base = a:base
	endif

	while 0 != lnum && !complete_check()
		let line = getline(lnum)
		let macro_name_list = matchlist(line, '^\s*-define(\(' . a:base . '[0-9A-Za-z_-]\+\)[,()]\@=')
		if !empty(macro_name_list)
			call complete_add(macro_name_list[1])
		endif
		let lnum = s:erlangFindNextNonBlank(lnum)
	endwhile

	return []
endfunction


