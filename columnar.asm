section .data
    extern len_cheie, len_haystack
    nr_linii dd 1 ; variabila ce pastreaza nr de linii ale matricei plaintext 
    linii dd 1 ; nr. de caractere din matrice prelucrate
    vect dd 1 ; memoreaza index vector de ordonare cheie
    matrice times 200 db 255 ; matrice plain text initializata cu valoarea 255

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 
    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY
    ;; TODO: Implment columnar_transposition
    ;; FREESTYLE STARTS HERE

    mov ecx, 199

;initializare matrice
sterg:
    mov byte[matrice + ecx], 255
    loop sterg
    xor ecx, ecx
    xor eax, eax

;copiaza plaintext in matricea formatata
incarca:
    mov al, byte [esi + ecx]
    mov byte [matrice + ecx], al
    inc ecx
    cmp ecx, [len_haystack]
    jne incarca
    xor eax, eax ; pun 0 in eax, edx
    xor edx, edx
    mov eax, [len_haystack]
    div dword [len_cheie]
    inc eax
    mov [nr_linii], eax
    dec eax
    mov [linii], eax
    xor eax, eax ; index citire scriere text
    xor ecx, ecx ; index vector ordine cheie 
    mov [vect], ecx ; mem copie lui ecx
    xor edx, edx ; index linie

;ecx index cyphretext
;eax nr. caractere prelucrate
;vector index vector ordonare lexicografica
col:
    push ecx
    mov ecx, [vect]
    mov edx, [edi + 4 * ecx] ; citesc coloana din vectorul de ordine cheie in edx
    pop ecx
    push eax
    mov al, byte [matrice + edx]
    mov byte [ebx+ecx], al ; ecx index in text cifrat
    pop eax

lin:
    inc eax
    add edx, [len_cheie]
    push eax
    mov al, byte [matrice + edx]
;   PRINTF32 `%c\n\x0`, byte [matrice + edx]
    cmp al, 255
    je nu
    inc ecx
    mov byte [ebx + ecx], al

nu:
    pop eax
;   PRINTF32 `%u\n\x0`, eax
;   PRINTF32 `%c\n\x0`, byte [ebx + ecx]
;   PRINTF32 `%u\n\x0`, [linii]
;   PRINTF32 `%u\n\x0`, ecx

    cmp eax, [linii]
    jne lin
    push ecx
    mov ecx, dword [vect]
    inc ecx
    cmp ecx, [len_cheie]
    je exit0
    mov [vect], ecx
    pop ecx
    inc ecx
    push eax
    xor eax, eax
    mov eax, [linii]
    add eax, [nr_linii]
    mov [linii], eax
    pop eax
    jmp col

exit0:
    pop ecx
    
exit:    
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
