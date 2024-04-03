; Autor reseni: Marek Kužel xkuzel11
; Pocet cyklu k serazeni puvodniho retezce:6068
; Pocet cyklu razeni sestupne serazeneho retezce:8000
; Pocet cyklu razeni vzestupne serazeneho retezce:335
; Pocet cyklu razeni retezce s vasim loginem:1434
; Implementovany radici algoritmus:bubble sort
; ------------------------------------------------

; DATA SEGMENT
                .data
;login:          .asciiz "vitejte-v-inp-2023"    ; puvodni uvitaci retezec
;login:          .asciiz "vvttpnjiiee3220---"  ; sestupne serazeny retezec
;login:          .asciiz "---0223eeiijnpttvv"  ; vzestupne serazeny retezec
login:          .asciiz "xkuzel11"            ; SEM DOPLNTE VLASTNI LOGIN
                                                ; A POUZE S TIMTO ODEVZDEJTE

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize - "funkce" print_string)

; CODE SEGMENT
                .text


;r7 - current char
;r9 - next char
;r8 - pointer to the string
;r10 - bool to check if the string is sorted
;
;r15 - helper register
main:
        lui r8, login       
        daddi r10, r0, 1
        daddi r9, r0, 1
        jal first_loop

first_loop:
        daddi r8, r0, login     ;load the address of the string
        xor r15, r15, r15       ;nullify r15
        slti r11, r10, 1         ;if the byte is 0
        bnez r11, end
        nop
        daddi r10,r0, 0         ;swap bool = 0
        jal second_loop
        nop
        b first_loop

second_loop:
        lb r7, 0(r8)            ;loads a byte
        lb r9, 1(r8)            ;loads a byte
        slti r15, r9, 1         ;if the byte is \0
        bnez r15,first_loop    ;if \0 go to end
        
        nop
        slt r15, r9, r7         ;if the byte is smaller than the previous one
        bnez r15, swap          ;if yes swap
        addi r8, r8, 1          ;else increment the pointer
        nop
        b second_loop

swap:
        addi r16, r8, 1         ;r16 = r8 + 1
        sb r9, 0(r8)            ;swap the bytes
        sb r7, 1(r8)
        daddi r10, r0, 1        ;r9 = 0 - bool to check if we swapped
        daddi r15 , r0 , 0      ;nullify r15
        b second_loop
        nop
end:
        daddi r4, r0, login     ;load the address of the string
        jal print_string
        syscall 0

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address