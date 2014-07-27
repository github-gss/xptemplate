if exists( "g:__FILTERVALUE_VIM__" ) && g:__FILTERVALUE_VIM__ >= XPT#ver
    finish
endif
let g:__FILTERVALUE_VIM__ = XPT#ver



let s:oldcpo = &cpo
set cpo-=< cpo+=B

let g:EmptyFilter = {}

let s:proto = {}

fun! s:New( nIndent, text, ... ) dict "{{{
    let self.nIndent = a:nIndent
    let self.text    = a:text

    " force to use this
    let self.force   = a:0 == 1 && a:1
    let self.marks   = 'innerMarks'

    let self.rc      = 1 " right status. 0 means nothing should be updated.
    let self.toBuild = 0
endfunction "}}}

fun! s:AdjustIndent( startPos ) dict "{{{

    if self.text !~ '\n'
        let self.nIndent = 0
        return
    endif


    let nIndent = XPT#getIndentNr( a:startPos[0], a:startPos[1] )
    let [ nIndent, self.nIndent ] = [ max( [ 0, nIndent + self.nIndent ] ), 0 ]

    if nIndent == 0
        return
    endif


    let indentSpaces = repeat( ' ', nIndent )

    let self.text = substitute( self.text, '\n', "\n" . indentSpaces, 'g' )

endfunction "}}}

fun! s:AdjustTextAction( flt_rst, context ) dict "{{{

    if !has_key( a:flt_rst, 'text' )
        return
    endif

    " no more need to copy nIndent from action to flt_rst
    " if has_key( a:flt_rst, 'resetIndent' )

    "     let self.nIndent = self.action.nIndent

    "     unlet self.action.nIndent
    "     unlet self.action.resetIndent

    " endif

    " indent adjusting should be done just before put onto screen.
    " call self.AdjustIndent( a:context.startPos )

endfunction "}}}

exe XPT#let_sid
let g:FilterValue = XPT#class( s:sid, s:proto )

let &cpo = s:oldcpo
