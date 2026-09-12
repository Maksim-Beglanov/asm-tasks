%macro pcall 1-*
        %rep %0 - 1
                %rotate -1
                push dword %1
        %endrep
        %rotate -1
        call %1
        add esp, 4 * %0 - 4
%endmacro

%macro _syscall3 4
        push ebx

        %rep 3
                %rotate -1
                push dword %1
        %endrep
        %rotate -1
        pop ebx
        pop ecx
        pop edx
        mov eax, %1
        int 80h

        pop ebx
%endmacro

%macro write 3
        _syscall3 4, %1, %2, %3
%endmacro

%macro read 3
        _syscall3 3, %1, %2, %3
%endmacro

%macro _open 3
        _syscall3 5, %1, %2, %3
%endmacro

%macro close 1
        push ebx

        mov eax, 6
        mov ebx, %1
        int 80h

        pop ebx
%endmacro

%macro _exit 1
        mov eax, 1
        mov ebx, %1
        int 80h
%endmacro

%macro _fcom 0-1
    %if %0 > 0
        %if %1 = 0
            ftst
        %else
            fcom %1
        %endif
    %else
        fcom
    %endif
        fstsw ax
        sahf
%endmacro
