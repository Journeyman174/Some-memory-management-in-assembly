section .data
;; defining constants, you can use these as immediate values in your code
CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS

offset dd 0 ; memorez offset
tag dd 0 ; tag-ul rezultat din adresa
address0 dd 0 ; adresa de inceput in caz de CACHE_MIS

section .text
    global load
    extern printf

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)
    ;; DO NOT MODIFY

    ;; TODO: Implment load
    ;; FREESTYLE STARTS HERE

;calculam tag-ul corespunzator address
    push edx ; salvez in stiva edx
    shr edx, 3 ; am facut 3 shift right si in edx am tag-ul cautat
    mov dword [tag], edx
    pop edx ; aduc din stiva edx
    push edx
    and edx, 0x00000007
    mov dword [offset], edx
    pop edx
    push edx
    and edx, 0xfffffff8
    mov dword [address0], edx
    pop edx

;caut in vectorul de taguri
    xor esi, esi
;    
    push eax
    mov eax, [tag] 

caut:
    cmp eax, dword [ebx+esi]
    je CACHE_HIT
    inc esi
    cmp esi, CACHE_LINES
    je CACHE_MISS
    jmp caut
;
CACHE_HIT:
     pop eax
     push eax
     mov eax, CACHE_LINE_SIZE
     mul esi
     mov esi, eax
     pop eax
     push edi
     mov edi, dword [offset]
     add edi, ecx
     push ebx
     mov bl, byte [edi + esi]
     mov [eax], bl
     pop ebx
     pop edi
     jmp exit
;
CACHE_MISS:
    pop eax
    mov esi, 0
    push eax
    mov eax, CACHE_LINE_SIZE
    mul edi
    add eax,ecx
    push ecx
    mov ecx, dword [address0]
;
;copiez de la adresa de inceput a grului de 8 octeti din car face parte in cache
copiez:
    push ebx
    mov bl, byte [ecx + esi]   
    mov byte [eax+esi], bl
    pop ebx
;
    inc esi
    cmp esi,7
    jle copiez
;
    xor ecx,ecx
    mov ecx, [tag]
    mov  [ebx+edi],ecx
    pop ecx
    mov esi,edi
    mov edi, [offset]
;
    jmp CACHE_HIT
        
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
exit:
    popa
    leave
    ret
    ;; DO NOT MODIFY


