function! StartGolf(start, finish)
    " Split panes
    split end
    vsplit start

    " Fill first, move to next
    call append(line(0), split(a:start, "\n"))
    normal dd
    setlocal nomodifiable
    exe "normal \<c-w>\<c-w>"

    " Fill second, move to next
    call append(line(0), split(a:finish, "\n"))
    normal dd
    setlocal nomodifiable
    exe "normal \<c-w>\<c-w>"

    " Place starting text in main buffer
    call append(line(0), split(a:start, "\n"))
    normal ddgg

    " Start tracking all commands
    normal qa
endfunction

function! FinishGolf(finish, goalLength, string)
    " Finish recording
    normal q

    let contents = join(getline(1,'$'), "\n")
    if a:finish != contents
        echom "Contents do not match goal!"
    else
        vs output
        call append(0, "You took: " . len(@a) . " keystrokes." )
        call append(1, "The goal was: " . a:goalLength . " keystrokes." )
        if len(@a) <= a:goalLength
            call append(2, "The code to type into the keypad on the door is: " . a:string)
        else
            call append(2, "Try again! (Restart Vim, repeat commands.)" )
        endif
        call append(3, "You typed the following:")
        call append(4, @a)
        set nomodifiable
    endif
endfunction

function! One()
    let g:startFile = 'one.start'
    let g:endFile = 'one.goal'

    let g:startText = join(readfile(g:startFile), "\n")
    let g:endText = join(readfile(g:endFile), "\n")
    let g:goalLength = 32
    let g:answer = 'its-only-mooing-when-i-do-it'

    call StartGolf(g:startText, g:endText)
endfunction

command! HoleOne :call One()
command! HoleTwo :call Two()
command! HoleThree :call Three()
command! Done :call FinishGolf(g:endText, g:goalLength, g:answer)