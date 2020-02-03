;******************************************************************************
; ��������� ������ � ������� ������������
; ������ � ������������
;
; ��� PIC 16F84 � �������� 4 ��� (��� ����������� PIC)
; (���� ��� ��� ������������� � MPLAB � ��������� �������������)
;
; ���������� ������� ������ ������� (��� ������ ������) ��� ������ PIC
; � ����� �������� ��������.
; ��� ������ ���������� ���������� �� ������������ ������� timer0.
; ��� ����� ���� ����������� ��� ��������� �������� ������, ���� ��������
; � ������� ��������.
;******************************************************************************

;==============================================================================
include <p16f628a.inc>		; ����������� ����������
;==============================================================================
LIST b=12, n=97, t=ON, st=OFF	; ��������� MPLAB
				; ���������� ��������� ����=12, �����=97, �������� �������
				; ������=ON, ������� ������������� ��������=OFF

;__CONFIG   _CP_OFF & _WDT_OFF & _PWRTE_ON & _XT_OSC		;16F84
				; ��������� ��� 16F84; ������ ���� OFF, 
				; ���������� ������ OFF, ������ ��� ��������� ������� ON,
				; ��� ��������� XT - ��� ������ ��� ������������� ����������
				; �������� 4 ���.
__CONFIG b'11111100111000'		;16F628A
;		       9876543210

;==============================================================================
				; ����������
CBLOCK 0x20		; ������ ��� � 16F84

bres_hi			; ������� ���� ����� 24-������ ����������
bres_mid		; ������� ����
bres_lo			; ������� ����
				; (��� ����� ������ 3 ����� ��� ���� �������)
status_temp		; ������������ ��� ������������ ����������
w_temp			; ������������ ��� ������������ ����������

e_sec			; ������� ������
d_sec			; ������� ������
e_min
d_min
e_hour
d_hour

ae_min		; ����� ����������
ad_min
ae_hour
ad_hour

miganie
tune
temp
del

Bits			; ������� ��������� ���
				; 0 - ��������� ����� � ������
				; 1 - ���� =1, �� ������������ ������ ��� ������� ������
				; 2 - ������� ������������� ���������
				; 3 - ���������/���������� ����������
				; 4 - 
				; 5 - 
				; 6 - 
				; 7 - 
ENDC

PCL equ 02h

W equ 0 ; ��������� ��������� � �����������.
F equ 1 ; ��������� ��������� � �������.
Z equ 2 ; ���� �������� ����������
C equ 0 ; ���� ��������-����
;==============================================================================
			; ���
org 0x000 		; ��������� ������ ������ �������� �� ������ ����������
reset
goto setup		; ��������� ���������� � �����
org 0x004		; ������ ����������, ����� ������� ��� ����������� ����������.
;==============================================================================

;******************************************************************************
;  ���������� ���������� - ������    (���� ��� ����������� ��� ������ ���������� ������� timer0)
;******************************************************************************
;------------------
int_handler
		goto IntHandler
;------------------

TABLE 
		clrf PCLATH
		btfss Bits,0 ; �������� ��������� �����
		goto tochkaOFF
		goto tochkaON
tochkaOFF addwf PCL,F ; ���������� �������� ������ PC ������������� �� �������� ����������� ������������ W.
	retlw b'00111111' ; ..FEDCBA = 0 ���������� ������ �� �������
	retlw b'00000110' ; .....CB. = 1 �� ������ �� ���������,
	retlw b'01011011' ; .G.ED.BA = 2 ���������� � ������������,
	retlw b'01001111' ; .G..DCBA = 3 � ����� - ������� �� �����.
	retlw b'01100110' ; .GF..CB. = 4
	retlw b'01101101' ; .GF.DC.A = 5
	retlw b'01111101' ; .GFEDC.A = 6
	retlw b'00000111' ; .....CBA = 7
	retlw b'01111111' ; .GFEDCBA = 8
	retlw b'01101111' ; .GF.DCBA = 9
	retlw b'00000000' ;          = 10

tochkaON addwf PCL,F ; ���������� �������� ������ PC ������������� �� �������� ����������� ������������ W.
	retlw b'10111111' ; ..FEDCBA = 0 ���������� ������ �� �������
	retlw b'10000110' ; .....CB. = 1 �� ������ �� ���������,
	retlw b'11011011' ; .G.ED.BA = 2 ���������� � ������������,
	retlw b'11001111' ; .G..DCBA = 3 � ����� - ������� �� �����.
	retlw b'11100110' ; .GF..CB. = 4
	retlw b'11101101' ; .GF.DC.A = 5
	retlw b'11111101' ; .GFEDC.A = 6
	retlw b'10000111' ; .....CBA = 7
	retlw b'11111111' ; .GFEDCBA = 8
	retlw b'11101111' ; .GF.DCBA = 9
	retlw b'00000000' ;          = 10


;*********************************************************************************************************************
;---------------------------------------------------------------------------------------------------------------------
;  MAIN     (������� ���� ���������)
;******************************************************************************
;------------------
main			; ������� �� �����
;------------------
;-------------------------------------------------
; ���������! ���� ������ ���������� ���������� �� ������������ ������� timer0.
; ��� ����� ��������� ��� ������� ����������� ���� ������ 256 ������
; � ��������� ������� �������������� �������.
;-------------------------------------------------
main_loop		
			; ���������! ����� ������������� ��� �������� ����������� ���,
			; ��� ������ � ������ �������� ���������.
			; ���������� ��������� ���� ��� �������������� �������.
; ���
; ���
; ���
; ���



		btfsc PORTA,4			; ������� �� ����� ����������
		bsf Bits,1	
		btfss PORTA,4
		btfss Bits,1 
		goto ShowTime
		bcf Bits,1		
		goto ShowAlarmTime




; ��������� �������------------------------------------
; �������� ����������� ����� ����� � ��� ��������� ������� ��������� ����� �
ShowTime
		btfsc Bits,3	; �������� ����������
		btfss PORTA,6
		goto SkipResetAlarm
		btfss PORTA,4
		goto SkipResetAlarm
		bcf Bits,3
		bcf PORTA, 6
SkipResetAlarm

		bsf PORTA, 3	; ��������� �����
		movf e_min,w	; ����������� �������� ������� ������� � �����������
		call TABLE		; ����� ������������, ����� ������� �������� ��� �������
		movwf PORTB		; ������ ���� � ���� �
		call delay10ms	; �������� �� ~10 ��
		bcf PORTA, 3	; ���������� �����

		bsf PORTA, 2
		movf d_min,w
		call TABLE
		movwf PORTB
		call delay10ms
		bcf PORTA, 2

		bsf PORTA, 1
		movf e_hour,w
		call TABLE
		movwf PORTB
		call delay10ms
		bcf PORTA, 1

		movlw .1			; ������ ������� ����� ���� ��� = 0
		subwf d_hour,w
		btfss STATUS,C
		goto SkipShowDesHour 
		bsf PORTA, 0
		movf d_hour,w
		call TABLE
		movwf PORTB
		call delay10ms
		bcf PORTA, 0
SkipShowDesHour

; ���� � ��������� �������-------------------------------------------------------------------------
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		movwf tune
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		goto SkipSetTime				
;		movlw .255	
;		movwf tune2	
back 	btfss PORTA,4		; ���� ������ ������, ��� ���������� ����� �� ���������
		goto SkipSetTime
		decf tune, f
		btfss STATUS,Z
		goto SkipSetTime
;		decf tune2, f
;		btfss STATUS,Z
;		goto back
;		goto next
;next
		movlw b'00000000'	; ������ ����������   GIE=on TOIE=on (���������� �� ������������ ������� timer0)
		movwf INTCON		; ����������. 
		goto WaitOffKey

; ��������� �����---------------------------------------------------------------------------------
ChangeMin

; ���� ������ ������ - ������� � ��������� �����
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		movwf tune
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		goto SetMin
		decfsz tune, f
		goto SetMin
		goto WaitOffKey2

; ��������� �����
SetMin	
		movlw .1			; ������ ������� ����� ���� ��� = 0
		subwf d_hour,w
		btfss STATUS,C
		goto SkipShowDesHour1 
		bsf PORTA, 0
		movf d_hour,w
		call TABLE
		movwf PORTB
		call delay10ms
		bcf PORTA, 0
SkipShowDesHour1

		bsf PORTA, 1
		movf e_hour,w
		call TABLE
		movwf PORTB
		call delay10ms
		bcf PORTA, 1

		; ������� ������������� ���������
	   	decf miganie, f
		btfss STATUS,Z
		goto MigMin

		btfss Bits,2
		movlw .100		; ����� ������� ������
		btfsc Bits,2
		movlw .100		; ����� ��������� �����
		movwf miganie
		movlw b'00000100'	; ����� ��� ���� 2
		xorwf Bits,f		; ����������� ��� 2

MigMin	btfss Bits,2
		goto SkipShowMin	; �� ���������� ������
	
		bsf PORTA, 3		; �������� ������
		movf e_min,w
		call TABLE
		movwf PORTB
		call delay10ms
		bcf PORTA, 3

		bsf PORTA, 2
		movf d_min,w
		call TABLE
		movwf PORTB
		call delay10ms
		bcf PORTA, 2	
SkipShowMin
		btfsc PORTA,4
		bsf Bits,1		; ���������� ���������� ����������
		btfss PORTA,4
		btfss Bits,1 
		goto ChangeMin

		incf e_min
		movlw .10			
		subwf e_min, w	; ��������� 10 �� ������ ������ � ����������� � �����������
		btfsc STATUS,Z	; �������� ������������� ���������� ���������
		goto MinDes	; ���� ������� ������ = 10
		goto ResetBits1		; ���� ������� ������ < 10, ������� �� �������� �����
MinDes 	clrf e_min	; ������� ������ ������
       	incf d_min	; ��������� �������� ������
ResetBits1
		movlw .6		
		subwf d_min, w
		btfsc STATUS,Z
		clrf d_min
		bcf Bits,1
		goto ChangeMin


; ��������� �����-----------------------------------------------------------------------------------------------
ChangeHour 
		bcf Bits,0

; ���� ������ ������ - ������� � ������� ���������
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		movwf tune
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		goto SetHour
		decfsz tune, f
		goto SetHour
		goto WaitOffKey3 

SetHour
		bsf PORTA, 2		; �������� ����
		movf d_min,w
		call TABLE
		movwf PORTB
		call delay10ms
		clrf PORTA
		bcf PORTA, 2

		bsf PORTA, 3
		movf e_min,w
		call TABLE
		movwf PORTB
		call delay10ms
		clrf PORTA
		bcf PORTA, 3

		; ������� ������������� ���������
	   	decf miganie, f
		btfss STATUS,Z
		goto MigHour

		btfss Bits,2
		movlw .100		; ����� ������� ������
		btfsc Bits,2
		movlw .100		; ����� ��������� �����
		movwf miganie
		movlw b'00000100'	; ����� ��� ���� 2
		xorwf Bits,f		; ����������� ��� 2
	
MigHour	btfss Bits,2
		goto SkipShowHour	; �� ���������� ����

		movlw .1			; ������ ������� ����� ���� ��� = 0
		subwf d_hour,w
		btfss STATUS,C
		goto SkipShowDesHour2 
		bsf PORTA, 0		
		movf d_hour,w
		call TABLE
		movwf PORTB
		call delay10ms
		clrf PORTA
		bcf PORTA, 0
SkipShowDesHour2

		bsf PORTA, 1
		movf e_hour,w
		call TABLE
		movwf PORTB
		call delay10ms
		clrf PORTA
		bcf PORTA, 1
SkipShowHour

		btfsc PORTA,4
		bsf Bits,1		; ���������� ���������� ����������
		btfss PORTA,4
		btfss Bits,1 
		goto ChangeHour

		incf e_hour
		bcf Bits,1

		movlw .10		
		subwf e_hour, w
		btfsc STATUS,Z
		goto inc_des_h2
		goto proverka24_2				;�������� 24�� ����
inc_des_h2	incf d_hour
			clrf e_hour

proverka24_2 movlw .4		
		subwf e_hour, w
		btfsc STATUS,Z
		goto clr_hour_2
		goto ChangeHour
clr_hour_2	movlw .2		
 		subwf d_hour, w
		btfsc STATUS,Z
		goto reset_time_2
		goto ChangeHour
reset_time_2	clrf e_hour
				clrf d_hour

		goto ChangeHour

SkipSetTime 
		movlw b'10100000'	; ������������ INCON
		movwf INTCON		; �������� ����������
goto main_loop		; ������� �� ������ �������� �����.

;�������� ���������� ������------------------------------------------------------------------------------------------
WaitOffKey  
		movlw b'01001001'
		movwf PORTB		
		bsf PORTA,2
		bsf PORTA,3	
		call delay10ms
		bcf PORTA,2
		bcf PORTA,3
		bcf Bits,1
		btfsc PORTA,4	; �������� ���������� ������, ����� �� ��������� ��������� ����� ��� ������ ����������		
		goto WaitOffKey
		goto ChangeMin

WaitOffKey2  
		movlw b'00111001'
		movwf PORTB		
		bsf PORTA,0	
		call delay10ms
		bcf PORTA,0
		movlw b'00001111'
		movwf PORTB		
		bsf PORTA,1	
		call delay10ms
		bcf PORTA,1
		movlw .255
		movwf tune	
		bcf Bits,1
		btfsc PORTA,4	; �������� ���������� ������, ����� �� ��������� ��������� ����� ��� ������ ����������
		goto WaitOffKey2
		goto ChangeHour

WaitOffKey3  
		movlw b'00111001'
		movwf PORTB		
		bsf PORTA,0	
		call delay10ms
		bcf PORTA,0
		movlw b'00001001'
		movwf PORTB		
		bsf PORTA,1	
		call delay10ms
		bcf PORTA,1
		movlw b'00001001'
		movwf PORTB		
		bsf PORTA,2	
		call delay10ms
		bcf PORTA,2
		movlw b'00001111'
		movwf PORTB		
		bsf PORTA,3	
		call delay10ms
		bcf PORTA,3
		bcf Bits,1
		btfsc PORTA,4	; �������� ���������� ������, ����� �� ��������� ��������� ����� ��� ������ ����������
		goto WaitOffKey3
		goto main_loop

;---------------------------------------------------------------------------------------------------------------------
;*********************************************************************************************************************










;******************************************************************************
;  ���������� ����������     (���� ��� ����������� ��� ������ ���������� ������� timer0)
;******************************************************************************

IntHandler
;-------------------------------------------------
			; ������� �� �������� �������� W � ���������
movwf w_temp      	; ��������� ������� ���������� �������� W
movf	STATUS,w        ; ��������� ���������� �������� ��������� STATUS � ������� W
movwf status_temp       ; ��������� ���������� �������� ��������� STATUS

;-------------------------------------------------
; ���������! �� �������� ���� ������ 256 ������,
; ������ �� ����� ������ ���� ����������� ������� �������������� �������.

; Jyf �������� ��� �������� ����:
; * ������� 256 �� ����� 24-������ ����������
; * ���������, ���������� �� ����������� �����
; * ���� ��, ��������� 1,000,000 � 24-������ ���������� � ������������� �������.
;-------------------------------------------------
			; * ����� ������������ ���������������� 24-������ ��������� 
			; ��� ������� � ��������� ������.
			; �� �������� 256 �� 24-������ ����������,
			; ������ ������������� ������� ����.

tstf bres_mid		; ������ �������� �� mid==0
skpnz			; nz = ��� ������ ����������
decf bres_hi,f		; z, ������ ���������� - ����� �������������� ����� ������� ���� (msb)

decfsz bres_mid,f	; �������������� ������� ���� (�������� 256)

			; ������ ������ 24-������ ���������������� ��������� ���������!
			; ��� �������� � 4 ���� �������, ��� "�������" 24-������ ���������

goto int_exit		; nz, ������, ������� ��� �� ������.
			; � ����������� ������� ��������� "���������" ("��������") ����������
			; �������� ������ 9 ������.
;------------------------
			; * ���������, �������� �� �� ����� �������.
			; �������� ���� ������ ����� ������� ����==0, 
			; �� ���� ��� ����� ��������� ���� �������.
			; �������� ���� ������ 1 ��� �� ������ 256 ���.
			; (��� ���� ����� ���������������� ��������)
			; ��� ����������� ����� bres_mid==0.

tstf bres_hi		; ����� ��������� ������� ���� �� ����
skpz			; z = � �������, � ������� ����� ����� ���� - ������ �������!
goto int_exit		; nz, ���, ������� ��� �� ������.
;-------------------------------------------------
; �������� ���� ������ ���� �� �������� ����� �������.
; ������ �� ����� ������������� ���� ������������ �������, ��������, 
; �������� ���������� � ����� ����� ����� �������, ��� �����-���� ���.
; (� ���� ������� �� ����������� ���������)
; ��� ��� ��� ����� ������� - ��� ��� ��������� 1,000,000
; � ����� 24-������ ��������� � ������ �������.
;-------------------------------------------------
			; ������� ���������� 1,000,000.
			; ���� ������� = 1,000,000 = 0F 42 40 (� ����������������� �������)
			; ��������� �� �����, ��� ������� ����==0 � ������� ����==0,
			; ��� ������ ���� ������� ����� �������.
			; ��� ���������������� 24-������ ��������, ��������� �� �����
			; ������ ��������� ��� ������� ����� � ��� ����� ��������� ���������
			; �������� ������ � ������� ������. ��� ������� �������, ���
			; "�������" 24-������ ��������.

; ������ 1,000,000 (0x0F4240) ������� 500,000 (0x07A120) ����� ������� ����������� ������ ����������

;movlw 0x0F		; �������� �������� �������� �����
;movwf bres_hi		; ��������� ��� � ������� ���� ����� ����������
;movlw 0x42		; �������� �������� �������� �����
;movwf bres_mid		; ��������� ��� � ������� ����
;movlw 0x40		; �������� �������� �����, ������� ����� ���������
;addwf bres_lo,f		; ���������� ��� � �������, ������������� � ������� �����

movlw 0x07		; �������� �������� �������� �����
movwf bres_hi		; ��������� ��� � ������� ���� ����� ����������
movlw 0xA1		; �������� �������� �������� �����
movwf bres_mid		; ��������� ��� � ������� ����
movlw 0x20		; �������� �������� �����, ������� ����� ���������
addwf bres_lo,f		; ���������� ��� � �������, ������������� � ������� �����

skpnc			; nc = ������������ ���, �� ���� �������� �������� ����� �� ��������

incf bres_mid,f		; c, ������������ �������� ����� - �������������� ������� ����
			; ��� �������������� � �������� �� ��, ��� �������� �������� ����� ��������,
			; � ������� ���� �� ������������ �� ������ ����������.
			; ���� ���������������� 24-������ �������� ���������!
			; ��� ��������������� � ��� ���� ������� "��������"
			; 24-������� ��������.
;-------------------------
			; ������ �� �������� "�������", ������� �� ��������� ������ �������.
			; ���������! ��� ����� ������� �� ����������� ���������, �������
			; ����� ������� ��� �������� ���������, ������� ���� �������� �������
			; � ���� ������� ��������.
			; �������� ���� ��� ����������� ��� ��� ������ ������������� �������.

			; ���������! ��� ��������� ��������� � porta,3
			; ��� ��������� ����� ���� ��������� � ������� ������.
;movlw b'00001010'	; ����� ��� ���� 3
;xorwf PORTA,f		; ����������� PORTA,bit3 (����������� ���������)

		movlw b'00000001'	; ����� ��� ���� 0
		xorwf Bits,f		; ����������� ��� 0 - ��������� �����
		btfss Bits,0		; e���� ��� 0 � �������� Bits = 0, �� ��������� ���������� ������������
		goto out 
		incf e_sec,f

		movlw .10			
		subwf e_sec, w	; ��������� 10 �� ������ ������ � ����������� � �����������
		btfss STATUS,Z	; �������� ������������� ���������� ���������
		goto out		; ���� ������� ������ < 10, ������� �� �������� �����
		clrf e_sec	; ������� ������ ������
		incf d_sec	; ��������� �������� ������

		movlw .6		
		subwf d_sec, w
		btfss STATUS,Z
		goto out
		clrf d_sec
		incf e_min

		movlw .10		
		subwf e_min, w
		btfss STATUS,Z
		goto out
		clrf e_min
		incf d_min

		movlw .6		
		subwf d_min, w
		btfss STATUS,Z
		goto out
		clrf d_min
		incf e_hour


		movlw .10		
		subwf e_hour, w
		btfss STATUS,Z
		goto proverka24				;�������� 24�� ����
		incf d_hour
		clrf e_hour

proverka24 
		movlw .4		
		subwf e_hour, w
		btfss STATUS,Z
		goto out
		movlw .2		
 		subwf d_hour, w
		btfsc STATUS,Z
		goto reset_time
		goto out
reset_time	clrf e_hour
			clrf d_hour


out nop

		btfss Bits, 3		; ��������� �������� ������� � �����������
		goto int_exit

		movf ae_min, w
		subwf e_min, w
		btfsc STATUS,Z
		goto AScanDMin
		goto int_exit
AScanDMin
		movf ad_min, w
		subwf d_min, w
		btfsc STATUS,Z
		goto AScanEHour
		goto int_exit	
AScanEHour
		movf ae_hour, w
		subwf e_hour, w
		btfsc STATUS,Z
		goto AScanDHour
		goto int_exit
AScanDHour
		movf ad_hour, w
		subwf d_hour, w
		btfsc STATUS,Z
		bsf PORTA, 6
		goto int_exit



						
;-------------------------------------------------
; ������ ���� ������������ ������� ���������, �� ����� ����� �� ����������� ����������
;-------------------------------------------------
			; � ���������� �� ��������������� �������� W � ���������, � �����
			; ���������� ���� ���������� TMRO, ������� �� ������ ��� ����������.
int_exit

BCF INTCON,T0IF		; �������� ���� ���������� tmr0
movf status_temp,w     	; ������ ����� �������� ��������� STATUS
movwf STATUS            ; ��������������� ���������� �������� STATUS, ������� ���� �� ����������
swapf w_temp,f
swapf w_temp,w         	; ��������������� ���������� �������� W, ������ ���� �� ����������

retfie			; ������������ �� ����������
;---------------------------------------------------------------------------------------------------------------------
;*********************************************************************************************************************




















































; ������� ��� ����������
ORG H'200' ; ���� ������ �������� ��� ����������

ALARM_TABLE 
clrf PCLATH
bsf PCLATH, 1	; ���������� PCLATH ������������ � PCH ��� ��������� PLC
addwf PCL,F ; ���������� �������� ������ PC ������������� �� �������� ����������� ������������ W.
retlw b'00111111' ; ..FEDCBA = 0 ���������� ������ �� �������
retlw b'00000110' ; .....CB. = 1 �� ������ �� ���������,
retlw b'01011011' ; .G.ED.BA = 2 ���������� � ������������,
retlw b'01001111' ; .G..DCBA = 3 � ����� - ������� �� �����.
retlw b'01100110' ; .GF..CB. = 4
retlw b'01101101' ; .GF.DC.A = 5
retlw b'01111101' ; .GFEDC.A = 6
retlw b'00000111' ; .....CBA = 7
retlw b'01111111' ; .GFEDCBA = 8
retlw b'01101111' ; .GF.DCBA = 9
retlw b'00000000' ;          = 10


;*********************************************************************************************************************
;���������----------------------------------------------------------------------------------------------------------
ShowAlarmTime
		btfsc Bits,3	; �������� ����������
		btfss PORTA,6
		goto SkipResetAlarm1
		btfss PORTA,4
		goto SkipResetAlarm1
		bcf Bits,3
		bcf PORTA, 6
SkipResetAlarm1
;		btfsc Bits,1
;		goto Alarm

		btfsc PORTA,4			; ������� �� ����� ����������
		bsf Bits,1	
		btfss PORTA,4
		btfss Bits,1 
		goto ShowSegment
		bcf Bits,1		
		goto ShowTime
	
ShowSegment	
		bsf PORTA, 3	; ��������� �����
		movf ae_min,w	; ����������� �������� ������� ������� � �����������
		call ALARM_TABLE ; ����� ������������, ����� ������� �������� ��� �������
		movwf PORTB		; ������ ���� � ���� �
		call delay2	; �������� �� ~10 ��
		bcf PORTA, 3	; ���������� �����

		bsf PORTA, 2
		movf ad_min,w
		call ALARM_TABLE
		movwf PORTB
		call delay2
		bcf PORTA, 2

		bsf PORTA, 1
		movf ae_hour,w
		call ALARM_TABLE
		movwf PORTB
		call delay2
		bcf PORTA, 1

		movlw .1			; ������ ������� ����� ���� ��� = 0
		subwf ad_hour,w
		btfss STATUS,C
		goto ASkipShowDesHour 
		bsf PORTA, 0
		movf ad_hour,w
		call ALARM_TABLE
		movwf PORTB
		call delay2
		bcf PORTA, 0
ASkipShowDesHour

; ������� � ��������� ����������-------------------------------------------------------------------------
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		movwf tune
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		goto SkipSetAlarm				
	 	btfss PORTA,4		; ���� ������ ������, ��� ���������� ����� �� ���������
		goto SkipSetAlarm
		decf tune, f
		btfss STATUS,Z
		goto SkipSetAlarm

AWaitOffKey  
		movlw b'00111001'
		movwf PORTB		
		bsf PORTA,2	
		call delay2
		bcf PORTA,2
		movlw b'00001111'
		movwf PORTB		
		bsf PORTA,3	
		call delay2
		bcf PORTA,3
		movlw .255
		movwf tune	
		bcf Bits,1
		btfsc PORTA,4	; �������� ���������� ������, ����� �� ��������� ��������� ����� ��� ������ ����������		
		goto AWaitOffKey

; ��������� �����---------------------------------------------------------------------------------
AChangeMin

; ���� ������ ������ - ������� � ��������� �����
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		movwf tune
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		goto ASetMin
		decfsz tune, f
		goto ASetMin
		goto AWaitOffKey2

; ��������� �����
ASetMin	
		movlw .1			; ������ ������� ����� ���� ��� = 0
		subwf ad_hour,w
		btfss STATUS,C
		goto ASkipShowDesHour1 
		bsf PORTA, 0
		movf ad_hour,w
		call ALARM_TABLE
		movwf PORTB
		call delay2
		bcf PORTA, 0
ASkipShowDesHour1

		bsf PORTA, 1
		movf ae_hour,w
		call ALARM_TABLE
		movwf PORTB
		call delay2
		bcf PORTA, 1

		; ������� ������������� ���������
	   	decf miganie, f
		btfss STATUS,Z
		goto AMigMin

		btfss Bits,2
		movlw .100		; ����� ������� ������
		btfsc Bits,2
		movlw .100		; ����� ��������� �����
		movwf miganie
		movlw b'00000100'	; ����� ��� ���� 2
		xorwf Bits,f		; ����������� ��� 2

AMigMin	btfss Bits,2
		goto ASkipShowMin	; �� ���������� ������
	
		bsf PORTA, 3		; �������� ������
		movf ae_min,w
		call ALARM_TABLE
		movwf PORTB
		call delay2
		bcf PORTA, 3

		bsf PORTA, 2
		movf ad_min,w
		call ALARM_TABLE
		movwf PORTB
		call delay2
		bcf PORTA, 2	
ASkipShowMin
		btfsc PORTA,4
		bsf Bits,1		; ���������� ���������� ����������
		btfss PORTA,4
		btfss Bits,1 
		goto AChangeMin

		incf ae_min
		movlw .10			
		subwf ae_min, w	; ��������� 10 �� ������ ������ � ����������� � �����������
		btfsc STATUS,Z	; �������� ������������� ���������� ���������
		goto AMinDes	; ���� ������� ������ = 10
		goto AResetBits1		; ���� ������� ������ < 10, ������� �� �������� �����
AMinDes 	clrf ae_min	; ������� ������ ������
       	incf ad_min	; ��������� �������� ������
AResetBits1
		movlw .6		
		subwf ad_min, w
		btfsc STATUS,Z
		clrf ad_min
		bcf Bits,1
		goto AChangeMin

AWaitOffKey2  
		movlw b'00111001'
		movwf PORTB		
		bsf PORTA,0	
		call delay2
		bcf PORTA,0
		movlw b'00001111'
		movwf PORTB		
		bsf PORTA,1	
		call delay2
		bcf PORTA,1
		movlw .255
		movwf tune	
		bcf Bits,1
		btfsc PORTA,4	; �������� ���������� ������, ����� �� ��������� ��������� ����� ��� ������ ����������
		goto AWaitOffKey2

; ��������� �����-----------------------------------------------------------------------------------------------
AChangeHour nop
		bcf Bits,0

; ���� ������ ������ - ������� � ������� ���������
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		movwf tune
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		goto ASetHour
		decfsz tune, f
		goto ASetHour
AWaitOffKey3  
		movlw b'00111001'
		movwf PORTB		
		bsf PORTA,0	
		call delay2
		bcf PORTA,0
		movlw b'00001001'
		movwf PORTB		
		bsf PORTA,1	
		call delay2
		bcf PORTA,1
		movlw b'00001001'
		movwf PORTB		
		bsf PORTA,2	
		call delay2
		bcf PORTA,2
		movlw b'00001111'
		movwf PORTB		
		bsf PORTA,3	
		call delay2
		bcf PORTA,3
		bcf Bits,1
		btfsc PORTA,4	; �������� ���������� ������, ����� �� ��������� ��������� ����� ��� ������ ����������
		goto AWaitOffKey3
		goto OnOffAlarm

ASetHour
		bsf PORTA, 2		; �������� ����
		movf ad_min,w
		call ALARM_TABLE
		movwf PORTB
		call delay2
		clrf PORTA
		bcf PORTA, 2

		bsf PORTA, 3
		movf ae_min,w
		call ALARM_TABLE
		movwf PORTB
		call delay2
		clrf PORTA
		bcf PORTA, 3

		; ������� ������������� ���������
	   	decf miganie, f
		btfss STATUS,Z
		goto AMigHour

		btfss Bits,2
		movlw .100		; ����� ������� ������
		btfsc Bits,2
		movlw .100		; ����� ��������� �����
		movwf miganie
		movlw b'00000100'	; ����� ��� ���� 2
		xorwf Bits,f		; ����������� ��� 2
	
AMigHour	
		btfss Bits,2
		goto ASkipShowHour	; �� ���������� ����
		movlw .1			; ������ ������� ����� ���� ��� = 0
		subwf ad_hour,w
		btfss STATUS,C
		goto ASkipShowDesHour2 
		bsf PORTA, 0		
		movf ad_hour,w
		call ALARM_TABLE
		movwf PORTB
		call delay2
		clrf PORTA
		bcf PORTA, 0
ASkipShowDesHour2

		bsf PORTA, 1
		movf ae_hour,w
		call ALARM_TABLE
		movwf PORTB
		call delay2
		clrf PORTA
		bcf PORTA, 1
ASkipShowHour

		btfsc PORTA,4
		bsf Bits,1		; ���������� ���������� ����������
		btfss PORTA,4
		btfss Bits,1 
		goto AChangeHour

		incf ae_hour
		bcf Bits,1

		movlw .10		
		subwf ae_hour, w
		btfsc STATUS,Z
		goto Ainc_des_h2
		goto Aproverka24_2				;�������� 24�� ����
Ainc_des_h2	incf ad_hour
			clrf ae_hour

Aproverka24_2 movlw .4		
		subwf ae_hour, w
		btfsc STATUS,Z
		goto Aclr_hour_2
		goto AChangeHour
Aclr_hour_2	movlw .2		
 		subwf ad_hour, w
		btfsc STATUS,Z
		goto Areset_time_2
		goto AChangeHour
Areset_time_2	clrf ae_hour
				clrf ad_hour

		goto AChangeHour


; ��������� / ���������� ����������
OnOffAlarm
; ���� ������ ������ - ������� � ����� ������� ����������
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		movwf tune
		btfss PORTA,4		; �������� ����� �, ����� ���������� ���������
		goto AOnOff
		decfsz tune, f
		goto AOnOff
		goto AWaitOffKey4

; ��������� �����
AOnOff	
		btfsc Bits, 3
		goto ShowOnA
		goto ShowOffA

ShowOnA
		movlw b'00111111'
		movwf PORTB		
		bsf PORTA,2	
		call delay2
		bcf PORTA,2

		movlw b'01010100'
		movwf PORTB		
		bsf PORTA,3	
		call delay2
		bcf PORTA,3

		goto ScanButton

ShowOffA
		movlw b'00111111'
		movwf PORTB		
		bsf PORTA,0	
		call delay2
		bcf PORTA,0

		movlw b'01110001'
		movwf PORTB		
		bsf PORTA,1	
		call delay2
		bcf PORTA,1

		movlw b'01110001'
		movwf PORTB		
		bsf PORTA,2	
		call delay2
		bcf PORTA,2
		goto ScanButton

ScanButton
		btfsc PORTA,4
		bsf Bits,1		; ���������� ���������� ����������
		btfss PORTA,4
		btfss Bits,1 
		goto OnOffAlarm

		movlw b'00001000'
		xorwf Bits, f

		bcf Bits,1
		goto OnOffAlarm

AWaitOffKey4  
		movlw b'00111001'
		movwf PORTB		
		bsf PORTA,0	
		call delay2
		bcf PORTA,0
		movlw b'00001111'
		movwf PORTB		
		bsf PORTA,1	
		call delay2
		bcf PORTA,1
		movlw .255
		movwf tune	
		bcf Bits,1
		btfsc PORTA,4	; �������� ���������� ������, ����� �� ��������� ��������� ����� ��� ������ ����������
		goto AWaitOffKey4

SkipSetAlarm
		goto ShowAlarmTime






Alarm
		decfsz tune, f
		goto FlashA
		goto Motor
Motor	
		movlw b'00100000'
		xorwf PORTA,f
		movlw .255
		movwf tune
		goto Alarm

FlashA	btfsc PORTA,4
		bsf Bits,1		; ���������� ���������� ����������
		btfss PORTA,4
		btfss Bits,1 
		goto Alarm
		goto ShowAlarmTime
















;*********************************************************************************************************************
;---------------------------------------------------------------------------------------------------------------------
;  ���������     (����������� ������ ���� ��� ��� �������)
;******************************************************************************
;------------------
setup			; ������� �� �����
;------------------

;-------------------------------------------------
; ���������! ������ ��� 16F84.
; ���������! ����� �� ����������� ��������� � ����������� ������.
; ��� ������ PIC ���� ��� ����� ����� ������ ��������������� �������.
;-------------------------------------------------
			; ��������� �������� OPTION
movlw b'10001000'	;
     ;  x-------	; 7, 0=��������, 1=���������, �������� ����� portb
     ;  -x------	; 6, 1=/, ��� ������ ������ ����������
     ;  --x-----	; 5, �������� ������� timer0, 0=���������� ���������, 1=������� �����.
     ;  ---x----	; 4, ������� ����� timer0, 1=\
     ;  ----x---	; 3, �������� ������������, 1=wdt, 0=timer0
     ;  -----x--	; 2,1,0, �������� ������������ ������� timer0
     ;  ------x-	;   000=2, 001=4, 010=8, 011=16, � �.�.
     ;  -------x	; 
			; ���������! �� ����������� ������������ � wdt, ����� ������� timer0
			; �� ����� ������������ � ����� ������������� ������ 256 ������
			; � �������� ����������.
banksel OPTION_REG	; ������� ���������� ���� ���������
movwf OPTION_REG	; ��������� ������ � OPTION_REG
banksel 0		; ��������� � ����������� ����� ��������� bank 0

;��������� �������� INTCON--------------------------------------------------------------------
			; ��� ������� ������� ���� �� �������� ����������
			; �� ������������ ������� timer0.
			; ���������� ���������� ���������� (enable interrupts last)
			; ��������� ����������
movlw b'10100000'	; GIE=on TOIE=on (���������� �� ������������ ������� timer0)
movwf INTCON		; ����������.
; bit 7: ���������� ���������� ����������: 	1=��������� ��� ��������������� ����������
;											0=��� ���������� ���������
; bit 6: ���������� ���������� �� ������������ �������: 1=��������� ����������
;														0=���������� ���������
; bit 5: ���������� ���������� �� ������������ TMR0: 1=���������; 0=���������
; bit 4: ���������� �������� ���������� INT: 1=���������; 0=���������
; bit 3: ���������� ���������� �� ��������� ������� �� ������ RB7-RB4: 1=���������; 0=���������
; bit 2: ���� ���������� �� ������������ TMR0: 1=��������� ������������ TMR0; 0=������������ �� ����
; bit 1: ���� �������� ����������
; bit 0: ���� ���������� RB7-RB4

; ��������� �������� PCON---------------------------------------------------------
movlw b'00001000'
banksel PCON	; ������� ���������� ���� ���������
movwf PCON
banksel 0		; ��������� � ����������� ����� ���������

; bit 3: ����� ������� ��������� ����������: 1=4���; 0=32���
; bit 1: ���� ������ �� ��������� �������
; bit 0: ���� ������ �� �������� ����������

;��������� ����������� ������� ����� PORTB------------------------------------------------------------------------
			; 1=����, 0=�����
	
movlw b'00000000'	; ��� 8 ������� ����� portb ������������� ��� ������
banksel TRISB		; ������� ���������� ���� ���������
movwf TRISB		; ���������� ����� �� ���� portb
banksel 0		; ��������� � ����������� ����� ��������� bank 0
clrf PORTB	

;��������� ����������� ������� ����� PORTA---------------------------------------------------------------------------
			
			; 1=����, 0=�����
movlw b'00010000'	; ��� 5 ����� porta ������������� ��� ������,
			; (� 16F84 ���� porta ����� ������ ������� 5 ���)
banksel TRISB	; ������� ���������� ���� ���������
movwf TRISA		; ���������� ����� �� ���� porta
banksel 0		; ��������� � ����������� ����� ���������
clrf PORTA	
;-------------------------------------------------
; ���������! ������ ���������� ����� ��������� � ��� ����� ���������
; ������ ������ (count) ��� ����� ������� � ���� 24-������ ����������.
;-------------------------------------------------
			; ���������! ���� ������ ���������� �������� ������� 4 ���, �������
			; ������������� 1,000,000 �������� � �������.
			; ��� ����� ������ � 1 �������, ������� �� ������ ���������
			; 1,000,000 �������� ������ ���.
			; 1,000,000 = 0F 42 40 (� ����������������� �������)
			; ��� ����� ����� �������� 256 �������� ��� ������� ����,
			; ����� ������� �� ������ ���������� 1 � �������� �����.
			; ���� �����, ��������� ������������ �������� �����.
			; ����� �� ��������� 24-������ ����������.
movlw 0x0F		; �������� �������� �������� �����
movwf bres_hi		; ��������� � ������� ����

movlw 0x42 +1		; �������� �������� �������� ����� (��������, ��� �� ��������� � ���� 1)
movwf bres_mid		; ��������� � ������� ����

movlw 0x40		; �������� �������� �������� �����
movwf bres_lo		; ��������� � ������� ����
			; ������ ��������� ���������, �� ����� ������ ����������.
;-------------------------------------------------
goto main		; ��������� ������� ���� ���������
;---------------------------------------------------------------------------------------------------------------------
;*********************************************************************************************************************

delay2 ; �������� ��� 2 ����� ���������
		clrf PCLATH
		bsf PCLATH, 1	; ���������� PCLATH ������������ � PCH ��� ��������� PLC
		movlw .255	
		movwf del	
		delay21 decf del, f
		btfss STATUS,Z
		goto delay21
		return	

delay10ms 
		clrf PCLATH
		movlw .255	
		movwf del	
		delay decf del, f
		btfss STATUS,Z
		goto delay
		return		

;==============================================================================
	end		; ����� ���� ����� ��� �������� ����.
;==============================================================================