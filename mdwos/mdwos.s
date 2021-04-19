.import __STARTUP_LOAD__, __BSS_LOAD__ ; Linker generated

.segment "EXEHDR"
.addr __STARTUP_LOAD__ ; Start address
.word __BSS_LOAD__ - __STARTUP_LOAD__ ; Size

.segment "RODATA"
MSG1: .ASCIIZ "MDW OS v0.1.1"
MSG2: .ASCIIZ "(c) 1979 by Matt Welsh"

.segment "STARTUP"

STRP2 = $CE  ; Address used by print function
; Apple II constants
HOME = $FC58
XCURSOR = $24
NEWLINE = $8D
COUT = $FDED
KEYIN = $FD0C
HGRPAGE = $E6
PAGE0 = $C054
PAGE1 = $C055
HGR = $F3E2
HGR2 = $F3D8
HCLR = $F3F2
HPOSN = $F411
WAIT = $FCA8
HGRPAGE1 = $2000


; Main program
JSR main_menu
JMP spin

main_menu:
  JSR HOME

  LDA #14
  STA XCURSOR
  JSR print
  .ASCIIZ "MDW OS v0.1.1"

  LDA #NEWLINE
  JSR COUT
  LDA #10
  STA XCURSOR
  JSR print
  .ASCIIZ "(c) 1985 by Matt Welsh"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #12
  STA XCURSOR
  JSR print
  .ASCIIZ "Please select one:"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #6
  STA XCURSOR
  JSR print
  .ASCIIZ "1. About Matt"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #6
  STA XCURSOR
  JSR print
  .ASCIIZ "2. Research papers"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #6
  STA XCURSOR
  JSR print
  .ASCIIZ "3. Talks"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #6
  STA XCURSOR
  JSR print
  .ASCIIZ "4. Resume and CV"

  LDA #NEWLINE ; newline
  JSR COUT
  JSR COUT
  LDA #1
  STA XCURSOR
  JSR print
  .ASCIIZ "Your selection: "

@menu_input:
  JSR KEYIN
  JSR COUT ; echo out

@menu_1:
  CMP #'1'|$80
  BNE @menu_2
  JSR about_matt
  JMP main_menu

@menu_2:
  CMP #'2'|$80
  BNE @menu_3
  JSR papers
  JMP main_menu

@menu_3:
  CMP #'3'|$80
  BNE @menu_4
  JSR talks
  JMP main_menu

@menu_4:
  CMP #'4'|$80
  BNE @menu_bad
  JSR resume
  JMP main_menu

@menu_bad:
  LDA #NEWLINE ; newline
  JSR COUT
  LDA #1
  STA XCURSOR
  JSR print
  .ASCIIZ "Bad input!"
  JMP @menu_input


about_matt:
  JSR show_picture

  JSR HOME
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "About Matt Welsh"

  LDA #NEWLINE
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "----------------"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  JSR print
  .ASCIIZ "I am a computer scientist and software"

  LDA #NEWLINE
  JSR COUT
  JSR print
  .ASCIIZ "engineer with interests in machine"

  LDA #NEWLINE
  JSR COUT
  JSR print
  .ASCIIZ "learning, distributed systems, mobile"

  LDA #NEWLINE
  JSR COUT
  JSR print
  .ASCIIZ "computing, and networks. I'm currently"

  LDA #NEWLINE
  JSR COUT
  JSR print
  .ASCIIZ "VP of engineering at OctoML, a startup"

  LDA #NEWLINE
  JSR COUT
  JSR print
  .ASCIIZ "in Seattle."

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-- Press any key to go back --"
  JSR $FD0C ; keyin
  RTS

papers:
  JSR HOME

  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "Matt Welsh - Papers"

  LDA #NEWLINE
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-------------------"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-- Press any key to go back --"
  JSR $FD0C ; keyin
  RTS

talks:
  JSR HOME

  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "Matt Welsh - Talks"

  LDA #NEWLINE
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "------------------"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-- Press any key to go back --"
  JSR $FD0C ; keyin
  RTS

resume:
  JSR HOME

  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "Matt Welsh - Resume and CV"

  LDA #NEWLINE
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "--------------------------"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-- Press any key to go back --"
  JSR $FD0C ; keyin
  RTS


print:
  PLA
  STA STRP2
  PLA
  STA STRP2+1

  LDY #0
@printloop:
  INC STRP2
  BNE @noc2  ; If no carry
  INC STRP2+1
@noc2:
  LDA (STRP2),Y
  BEQ @printend
  ORA #$80
  JSR COUT ; cout

  LDA #$50 ; wait amount
  JSR WAIT

  JMP @printloop
@printend:
  LDA STRP2+1
  PHA
  LDA STRP2
  PHA
  RTS

keyin:
@keyloop:
  LDA $C000
  BPL @keyloop
  STA $C010
  RTS

spin:
  @SPIN: NOP
  JMP @SPIN


show_picture:
  jsr HGR
  jsr HGR2
  lda #$20
  sta HGRPAGE
  jsr HCLR

  ldx #0
@draw_line:
  lda mdw_image,X
  sta HGRPAGE1,Y
  inx
  iny
  cpx #6
  bne @draw_line
  rts

mdw_image:
  .byte   $00,$00,$40,$01,$00,$00
  .byte   $00,$00,$0C,$18,$00,$00
  .byte   $00,$00,$70,$07,$00,$00
  .byte   $00,$00,$43,$61,$00,$00
  .byte   $00,$00,$4C,$19,$00,$00
  .byte   $33,$00,$70,$07,$00,$66
  .byte   $30,$06,$40,$01,$30,$06
  .byte   $3f,$06,$40,$01,$30,$7e
  .byte   $40,$07,$30,$06,$70,$01
  .byte   $7c,$07,$30,$06,$70,$1f
  .byte   $00,$18,$0F,$78,$0C,$00
  .byte   $00,$60,$40,$01,$03,$00



