; This is your structure
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc
    
section .text
    global ages

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
    ;; DO NOT MODIFY
    ;; TODO: Implement ages
    ;; FREESTYLE STARTS HERE

next_age:
    dec edx	; len - 1 este offset in dates
    mov eax, [esi + my_date.year] ;
    mov ebx, [edi + my_date_size * edx + my_date.year]
    sub eax, ebx ; scad eax = an curent - an nastere
    jle zero ; an curent <= an nastere - absurd deci varsta 0
    mov dword [ecx + edx * 4], eax ; scriu varsta in all_ages pe pozitia corespunzatoare
    mov ax, [esi + my_date.month] ; ax = luna curenta
    mov bx, [edi + my_date_size * edx + my_date.month]
    cmp ax, bx ; ax = luna curenta
    jl scad_unu ; ax = luna curenta 
    je ver_zi

go:
    cmp edx, 0
    jz exit
    jmp next_age

ver_zi:
    mov ax, [esi + my_date.day] ; 
    mov bx, [edi + my_date_size * edx + my_date.day]
    cmp ax, bx ; ax zi curenta
    jl scad_unu
    jmp go
	
scad_unu:
    mov eax, [ecx + edx * 4]
    dec eax
    mov dword [ecx + edx * 4], eax ; scriu varsta in all_ages pe pozitia corespunzatoare
    jmp go

zero:
    mov dword [ecx + edx * 4], 0
    jmp next_age
    
exit:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
