;******************************************************************************
; СЕКУНДНЫЙ ТАЙМЕР С НУЛЕВОЙ ПОГРЕШНОСТЬЮ
; ВЕРСИЯ С ПРЕРЫВАНИЯМИ
;
; для PIC 16F84 с частотой 4 МГц (или большинства PIC)
; (этот код был скомпилирован в MPLAB и аппаратно протестирован)
;
; Генерирует событие каждую секунду (или другой период) для любого PIC
; с любой тактовой частотой.
; Эта версия использует прерывания по переполнению таймера timer0.
; Код может быть адаптирован для различных тактовых частот, длин периодов
; и уровней точности.
;******************************************************************************

;==============================================================================
include <p16f628a.inc>		; определение процессора
;==============================================================================
LIST b=12, n=97, t=ON, st=OFF	; настройки MPLAB
				; абсолютная табуляция кода=12, строк=97, обрезать длинные
				; строки=ON, таблица перекодировки символов=OFF

;__CONFIG   _CP_OFF & _WDT_OFF & _PWRTE_ON & _XT_OSC		;16F84
				; настройки для 16F84; защита кода OFF, 
				; сторожевой таймер OFF, таймер при включении питания ON,
				; тип генератор XT - для кварца или керамического резонатора
				; частотой 4 МГц.
__CONFIG b'11111100111000'		;16F628A
;		       9876543210

;==============================================================================
				; переменные
CBLOCK 0x20		; начало ОЗУ в 16F84

bres_hi			; старший байт нашей 24-битной переменной
bres_mid		; средний байт
bres_lo			; младший байт
				; (нам нужно только 3 байта для этой системы)
status_temp		; используется для обслуживания прерывания
w_temp			; используется для обслуживания прерывания

e_sec			; единицы секунд
d_sec			; десятки секунд
e_min
d_min
e_hour
d_hour

ae_min		; время будильника
ad_min
ae_hour
ad_hour

miganie
tune
temp
del

Bits			; регистр служебных бит
				; 0 - секундные точки в памяти
				; 1 - если =1, то прибавляется минута при нажатии кнопки
				; 2 - мигание настраевомого параметра
				; 3 - включение/выключение будильника
				; 4 - 
				; 5 - 
				; 6 - 
				; 7 - 
ENDC

PCL equ 02h

W equ 0 ; Результат направить в аккумулятор.
F equ 1 ; Результат направить в регистр.
Z equ 2 ; Флаг нулевого результата
C equ 0 ; Флаг переноса-заёма
;==============================================================================
			; код
org 0x000 		; установка начала памяти программ на вектор прерывания
reset
goto setup		; настроить прерывания и порты
org 0x004		; вектор прерывания, далее следует код обработчика прерывания.
;==============================================================================

;******************************************************************************
;  ОБРАБОТЧИК ПРЕРЫВАНИЯ - ССЫЛКА    (этот код запускается при каждом прерывании таймера timer0)
;******************************************************************************
;------------------
int_handler
		goto IntHandler
;------------------

TABLE 
		clrf PCLATH
		btfss Bits,0 ; проверка секундной точки
		goto tochkaOFF
		goto tochkaON
tochkaOFF addwf PCL,F ; Содержимое счетчика команд PC увеличивается на величину содержимого аккумулятора W.
	retlw b'00111111' ; ..FEDCBA = 0 Происходит скачек по таблице
	retlw b'00000110' ; .....CB. = 1 на строку со значением,
	retlw b'01011011' ; .G.ED.BA = 2 записанным в аккумуляторе,
	retlw b'01001111' ; .G..DCBA = 3 и далее - возврат по стеку.
	retlw b'01100110' ; .GF..CB. = 4
	retlw b'01101101' ; .GF.DC.A = 5
	retlw b'01111101' ; .GFEDC.A = 6
	retlw b'00000111' ; .....CBA = 7
	retlw b'01111111' ; .GFEDCBA = 8
	retlw b'01101111' ; .GF.DCBA = 9
	retlw b'00000000' ;          = 10

tochkaON addwf PCL,F ; Содержимое счетчика команд PC увеличивается на величину содержимого аккумулятора W.
	retlw b'10111111' ; ..FEDCBA = 0 Происходит скачек по таблице
	retlw b'10000110' ; .....CB. = 1 на строку со значением,
	retlw b'11011011' ; .G.ED.BA = 2 записанным в аккумуляторе,
	retlw b'11001111' ; .G..DCBA = 3 и далее - возврат по стеку.
	retlw b'11100110' ; .GF..CB. = 4
	retlw b'11101101' ; .GF.DC.A = 5
	retlw b'11111101' ; .GFEDC.A = 6
	retlw b'10000111' ; .....CBA = 7
	retlw b'11111111' ; .GFEDCBA = 8
	retlw b'11101111' ; .GF.DCBA = 9
	retlw b'00000000' ;          = 10


;*********************************************************************************************************************
;---------------------------------------------------------------------------------------------------------------------
;  MAIN     (главный цикл программы)
;******************************************************************************
;------------------
main			; переход на метку
;------------------
;-------------------------------------------------
; Замечание! Этот пример использует прерывание по переполнению таймера timer0.
; Оно будет прерывать наш главный программный цикл каждые 256 команд
; и выполнять систему односекундного таймера.
;-------------------------------------------------
main_loop		
			; Замечание! здесь располагается ваш основной программный код,
			; или вызовы к частям основной программы.
			; Прерывание выполняет весь код односекундного таймера.
; код
; код
; код
; код



		btfsc PORTA,4			; переход на показ будильника
		bsf Bits,1	
		btfss PORTA,4
		btfss Bits,1 
		goto ShowTime
		bcf Bits,1		
		goto ShowAlarmTime




; индикация времени------------------------------------
; возможно понадобится сброс порта А или изменение времени включения порта В
ShowTime
		btfsc Bits,3	; проверка будильника
		btfss PORTA,6
		goto SkipResetAlarm
		btfss PORTA,4
		goto SkipResetAlarm
		bcf Bits,3
		bcf PORTA, 6
SkipResetAlarm

		bsf PORTA, 3	; включение сетки
		movf e_min,w	; копирование значения еднинцы секунды в аккумулятор
		call TABLE		; вызов подпрограммы, чтоюы вернуть двоичный код секунды
		movwf PORTB		; запись коды в порт В
		call delay10ms	; задержка на ~10 мс
		bcf PORTA, 3	; выключение сетки

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

		movlw .1			; скрыть десятки часов если они = 0
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

; вход в настройку времени-------------------------------------------------------------------------
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
		movwf tune
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
		goto SkipSetTime				
;		movlw .255	
;		movwf tune2	
back 	btfss PORTA,4		; если кнопка нажата, что пропускаем выход из настройки
		goto SkipSetTime
		decf tune, f
		btfss STATUS,Z
		goto SkipSetTime
;		decf tune2, f
;		btfss STATUS,Z
;		goto back
;		goto next
;next
		movlw b'00000000'	; запрет прерываний   GIE=on TOIE=on (прерывание по переполнению таймера timer0)
		movwf INTCON		; установить. 
		goto WaitOffKey

; установка минут---------------------------------------------------------------------------------
ChangeMin

; если зажата кнопка - переход в настройку часов
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
		movwf tune
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
		goto SetMin
		decfsz tune, f
		goto SetMin
		goto WaitOffKey2

; настройка минут
SetMin	
		movlw .1			; скрыть десятки часов если они = 0
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

		; мигание настраевомого параметра
	   	decf miganie, f
		btfss STATUS,Z
		goto MigMin

		btfss Bits,2
		movlw .100		; время горения минуты
		btfsc Bits,2
		movlw .100		; время затухания минут
		movwf miganie
		movlw b'00000100'	; маска для бита 2
		xorwf Bits,f		; переключить бит 2

MigMin	btfss Bits,2
		goto SkipShowMin	; не показывать минуты
	
		bsf PORTA, 3		; показать минуты
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
		bsf Bits,1		; установить разрешение инкремента
		btfss PORTA,4
		btfss Bits,1 
		goto ChangeMin

		incf e_min
		movlw .10			
		subwf e_min, w	; вычитание 10 из единиц секунд с сохранением в аккумулятор
		btfsc STATUS,Z	; проверка безошибочного выполнения вычитания
		goto MinDes	; если единицы секунд = 10
		goto ResetBits1		; если единицы секунд < 10, переход на проверку минут
MinDes 	clrf e_min	; очистка единиц секунд
       	incf d_min	; инкремент десятков секунд
ResetBits1
		movlw .6		
		subwf d_min, w
		btfsc STATUS,Z
		clrf d_min
		bcf Bits,1
		goto ChangeMin


; установка часов-----------------------------------------------------------------------------------------------
ChangeHour 
		bcf Bits,0

; если зажата кнопка - переход в главную программу
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
		movwf tune
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
		goto SetHour
		decfsz tune, f
		goto SetHour
		goto WaitOffKey3 

SetHour
		bsf PORTA, 2		; показать часы
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

		; мигание настраевомого параметра
	   	decf miganie, f
		btfss STATUS,Z
		goto MigHour

		btfss Bits,2
		movlw .100		; время горения минуты
		btfsc Bits,2
		movlw .100		; время затухания минут
		movwf miganie
		movlw b'00000100'	; маска для бита 2
		xorwf Bits,f		; переключить бит 2
	
MigHour	btfss Bits,2
		goto SkipShowHour	; не показывать часы

		movlw .1			; скрыть десятки часов если они = 0
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
		bsf Bits,1		; установить разрешение инкремента
		btfss PORTA,4
		btfss Bits,1 
		goto ChangeHour

		incf e_hour
		bcf Bits,1

		movlw .10		
		subwf e_hour, w
		btfsc STATUS,Z
		goto inc_des_h2
		goto proverka24_2				;проверка 24го часа
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
		movlw b'10100000'	; восстановить INCON
		movwf INTCON		; включить прерывания
goto main_loop		; переход на начало главного цикла.

;ожидания отпускания кнопки------------------------------------------------------------------------------------------
WaitOffKey  
		movlw b'01001001'
		movwf PORTB		
		bsf PORTA,2
		bsf PORTA,3	
		call delay10ms
		bcf PORTA,2
		bcf PORTA,3
		bcf Bits,1
		btfsc PORTA,4	; ожидание отпускания кнопки, чтобы не произошёл инкремент минут при первом отпускании		
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
		btfsc PORTA,4	; ожидание отпускания кнопки, чтобы не произошёл инкремент часов при первом отпускании
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
		btfsc PORTA,4	; ожидание отпускания кнопки, чтобы не произошёл инкремент часов при первом отпускании
		goto WaitOffKey3
		goto main_loop

;---------------------------------------------------------------------------------------------------------------------
;*********************************************************************************************************************










;******************************************************************************
;  ОБРАБОТЧИК ПРЕРЫВАНИЯ     (этот код запускается при каждом прерывании таймера timer0)
;******************************************************************************

IntHandler
;-------------------------------------------------
			; сначала мы сохраним регистры W и состояния
movwf w_temp      	; выгрузить текущее содержимое регистра W
movf	STATUS,w        ; поместить содержимое регистра состояния STATUS в регистр W
movwf status_temp       ; выгрузить содержимое регистра состояния STATUS

;-------------------------------------------------
; Замечание! мы попадаем сюда каждые 256 команд,
; теперь мы можем делать нашу специальную систему односекундного таймера.

; Jyf включает три основных шага:
; * вычесть 256 из нашей 24-битной переменной
; * проверить, достигнута ли контрольная точка
; * если да, прибавить 1,000,000 к 24-битной переменной и сгенерировать событие.
;-------------------------------------------------
			; * здесь используется оптимизированное 24-битное вычитание 
			; Оно сделано с минимумом команд.
			; Мы вычитаем 256 из 24-битной переменной,
			; просто декрементируя средний байт.

tstf bres_mid		; сперва проверим на mid==0
skpnz			; nz = нет потери значимости
decf bres_hi,f		; z, потеря значимости - тогда декрементируем самый старший байт (msb)

decfsz bres_mid,f	; декрементируем средний байт (вычитаем 256)

			; теперь полное 24-битное оптимизированное вычитание выполнено!
			; это примерно в 4 раза быстрее, чем "должное" 24-битное вычитание

goto int_exit		; nz, значит, секунда ещё не прошла.
			; в большинстве случаев полностью "фиктивное" ("холостое") прерывание
			; занимает только 9 команд.
;------------------------
			; * проверить, достигли ли мы одной секунды.
			; попадаем сюда только когда средний байт==0, 
			; то есть это может оказаться одна секунда.
			; попадаем сюда только 1 раз из каждых 256 раз.
			; (это наша самая оптимизированная проверка)
			; она достигается когда bres_mid==0.

tstf bres_hi		; также проверить старший байт на ноль
skpz			; z = и старший, и младший байты равны нулю - прошла секунда!
goto int_exit		; nz, нет, секунда ещё не прошла.
;-------------------------------------------------
; Попадаем сюда только если мы достигли одной секунды.
; теперь мы можем сгенерировать наше ежесекундное событие, например, 
; подобное добавлению к нашим часам одной секунды, или какое-либо ещё.
; (в этом примере мы переключаем светодиод)
; Что нам ещё нужно сделать - так это прибавить 1,000,000
; к нашей 24-битной переменно и начать сначала.
;-------------------------------------------------
			; Сначала прибавляем 1,000,000.
			; Одна секунда = 1,000,000 = 0F 42 40 (в шестнадцатеричном формате)
			; Поскольку мы знаем, что старший байт==0 и средний байт==0,
			; это делает весь процесс очень быстрым.
			; Это оптимизированное 24-битное сложение, поскольку мы можем
			; просто загружать два старших байта и нам нужно выполнить настоящее
			; сложение только с младшим байтом. Это намного быстрее, чем
			; "должное" 24-битное сложение.

; вместо 1,000,000 (0x0F4240) плюсуем 500,000 (0x07A120) чтобы событие происходило каждые полсекунды

;movlw 0x0F		; получаем значение старшего байта
;movwf bres_hi		; загружаем его в старший байт нашей переменной
;movlw 0x42		; получаем значение среднего байта
;movwf bres_mid		; загружаем его в средний байт
;movlw 0x40		; значение младшего байта, которое нужно прибавить
;addwf bres_lo,f		; прибавляем его к остатку, содержащемуся в младшем байте

movlw 0x07		; получаем значение старшего байта
movwf bres_hi		; загружаем его в старший байт нашей переменной
movlw 0xA1		; получаем значение среднего байта
movwf bres_mid		; загружаем его в средний байт
movlw 0x20		; значение младшего байта, которое нужно прибавить
addwf bres_lo,f		; прибавляем его к остатку, содержащемуся в младшем байте

skpnc			; nc = переполнения нет, то есть значение среднего байта не меняется

incf bres_mid,f		; c, переполнение младшего байта - инкрементируем средний байт
			; это оптимизировано с расчётом на то, что значение среднего байта известно,
			; и средний байт не переполнится от одного инкремента.
			; Наше оптимизированное 24-битное сложение выполнено!
			; Это приблизительное в два раза быстрее "должного"
			; 24-битного сложения.
;-------------------------
			; теперь мы выполним "событие", которое мы выполняем каждую секунду.
			; Замечание! Для этого примера мы переключаем светодиод, который
			; таким образом даёт мигающий светодиод, который одну секундку включен
			; и одну секунду выключен.
			; Добавьте сюда ваш собственный код для вашего ежесекундного события.

			; Замечание! Мой светодиод подключен к porta,3
			; ваш светодиод может быть подключен к другому выводу.
;movlw b'00001010'	; маска для бита 3
;xorwf PORTA,f		; переключить PORTA,bit3 (переключить светодиод)

		movlw b'00000001'	; маска для бита 0
		xorwf Bits,f		; переключить бит 0 - секундную точку
		btfss Bits,0		; eесли бит 0 в регистре Bits = 0, то следующая инструкция пропускается
		goto out 
		incf e_sec,f

		movlw .10			
		subwf e_sec, w	; вычитание 10 из единиц секунд с сохранением в аккумулятор
		btfss STATUS,Z	; проверка безошибочного выполнения вычитания
		goto out		; если единицы секунд < 10, переход на проверку минут
		clrf e_sec	; очистка единиц секунд
		incf d_sec	; инкремент десятков секунд

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
		goto proverka24				;проверка 24го часа
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

		btfss Bits, 3		; сравнение текущего времени с будильником
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
; теперь наше ежесекундное событие выполнено, мы можем выйти из обработчика прерывания
;-------------------------------------------------
			; в заключение мы восстанавливаем регистры W и состояния, а также
			; сбрасываем флаг прерывания TMRO, которое мы только что обработали.
int_exit

BCF INTCON,T0IF		; сбросить флаг прерывания tmr0
movf status_temp,w     	; достаём копию регистра состояния STATUS
movwf STATUS            ; восстанавливаем содержимое регистра STATUS, которое было до прерывания
swapf w_temp,f
swapf w_temp,w         	; восстанавливаем содержимое регистра W, котрое было до прерывания

retfie			; возвращаемся из прерывания
;---------------------------------------------------------------------------------------------------------------------
;*********************************************************************************************************************




















































; таблица для будильника
ORG H'200' ; блок памяти программ для будильника

ALARM_TABLE 
clrf PCLATH
bsf PCLATH, 1	; содержимое PCLATH записывается в PCH при изменении PLC
addwf PCL,F ; Содержимое счетчика команд PC увеличивается на величину содержимого аккумулятора W.
retlw b'00111111' ; ..FEDCBA = 0 Происходит скачек по таблице
retlw b'00000110' ; .....CB. = 1 на строку со значением,
retlw b'01011011' ; .G.ED.BA = 2 записанным в аккумуляторе,
retlw b'01001111' ; .G..DCBA = 3 и далее - возврат по стеку.
retlw b'01100110' ; .GF..CB. = 4
retlw b'01101101' ; .GF.DC.A = 5
retlw b'01111101' ; .GFEDC.A = 6
retlw b'00000111' ; .....CBA = 7
retlw b'01111111' ; .GFEDCBA = 8
retlw b'01101111' ; .GF.DCBA = 9
retlw b'00000000' ;          = 10


;*********************************************************************************************************************
;будильник----------------------------------------------------------------------------------------------------------
ShowAlarmTime
		btfsc Bits,3	; проверка будильника
		btfss PORTA,6
		goto SkipResetAlarm1
		btfss PORTA,4
		goto SkipResetAlarm1
		bcf Bits,3
		bcf PORTA, 6
SkipResetAlarm1
;		btfsc Bits,1
;		goto Alarm

		btfsc PORTA,4			; переход на показ будильника
		bsf Bits,1	
		btfss PORTA,4
		btfss Bits,1 
		goto ShowSegment
		bcf Bits,1		
		goto ShowTime
	
ShowSegment	
		bsf PORTA, 3	; включение сетки
		movf ae_min,w	; копирование значения еднинцы секунды в аккумулятор
		call ALARM_TABLE ; вызов подпрограммы, чтоюы вернуть двоичный код секунды
		movwf PORTB		; запись коды в порт В
		call delay2	; задержка на ~10 мс
		bcf PORTA, 3	; выключение сетки

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

		movlw .1			; скрыть десятки часов если они = 0
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

; переход в настройку будильника-------------------------------------------------------------------------
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
		movwf tune
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
		goto SkipSetAlarm				
	 	btfss PORTA,4		; если кнопка нажата, что пропускаем выход из настройки
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
		btfsc PORTA,4	; ожидание отпускания кнопки, чтобы не произошёл инкремент минут при первом отпускании		
		goto AWaitOffKey

; установка минут---------------------------------------------------------------------------------
AChangeMin

; если зажата кнопка - переход в настройку часов
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
		movwf tune
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
		goto ASetMin
		decfsz tune, f
		goto ASetMin
		goto AWaitOffKey2

; настройка минут
ASetMin	
		movlw .1			; скрыть десятки часов если они = 0
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

		; мигание настраевомого параметра
	   	decf miganie, f
		btfss STATUS,Z
		goto AMigMin

		btfss Bits,2
		movlw .100		; время горения минуты
		btfsc Bits,2
		movlw .100		; время затухания минут
		movwf miganie
		movlw b'00000100'	; маска для бита 2
		xorwf Bits,f		; переключить бит 2

AMigMin	btfss Bits,2
		goto ASkipShowMin	; не показывать минуты
	
		bsf PORTA, 3		; показать минуты
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
		bsf Bits,1		; установить разрешение инкремента
		btfss PORTA,4
		btfss Bits,1 
		goto AChangeMin

		incf ae_min
		movlw .10			
		subwf ae_min, w	; вычитание 10 из единиц секунд с сохранением в аккумулятор
		btfsc STATUS,Z	; проверка безошибочного выполнения вычитания
		goto AMinDes	; если единицы секунд = 10
		goto AResetBits1		; если единицы секунд < 10, переход на проверку минут
AMinDes 	clrf ae_min	; очистка единиц секунд
       	incf ad_min	; инкремент десятков секунд
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
		btfsc PORTA,4	; ожидание отпускания кнопки, чтобы не произошёл инкремент часов при первом отпускании
		goto AWaitOffKey2

; установка часов-----------------------------------------------------------------------------------------------
AChangeHour nop
		bcf Bits,0

; если зажата кнопка - переход в главную программу
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
		movwf tune
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
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
		btfsc PORTA,4	; ожидание отпускания кнопки, чтобы не произошёл инкремент часов при первом отпускании
		goto AWaitOffKey3
		goto OnOffAlarm

ASetHour
		bsf PORTA, 2		; показать часы
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

		; мигание настраевомого параметра
	   	decf miganie, f
		btfss STATUS,Z
		goto AMigHour

		btfss Bits,2
		movlw .100		; время горения минуты
		btfsc Bits,2
		movlw .100		; время затухания минут
		movwf miganie
		movlw b'00000100'	; маска для бита 2
		xorwf Bits,f		; переключить бит 2
	
AMigHour	
		btfss Bits,2
		goto ASkipShowHour	; не показывать часы
		movlw .1			; скрыть десятки часов если они = 0
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
		bsf Bits,1		; установить разрешение инкремента
		btfss PORTA,4
		btfss Bits,1 
		goto AChangeHour

		incf ae_hour
		bcf Bits,1

		movlw .10		
		subwf ae_hour, w
		btfsc STATUS,Z
		goto Ainc_des_h2
		goto Aproverka24_2				;проверка 24го часа
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


; включение / отключение будильника
OnOffAlarm
; если зажата кнопка - переход в показ времени будильника
		btfss PORTA,4
		movlw .255
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
		movwf tune
		btfss PORTA,4		; проверка порта А, чтобы пропустить настройку
		goto AOnOff
		decfsz tune, f
		goto AOnOff
		goto AWaitOffKey4

; настройка минут
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
		bsf Bits,1		; установить разрешение инкремента
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
		btfsc PORTA,4	; ожидание отпускания кнопки, чтобы не произошёл инкремент часов при первом отпускании
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
		bsf Bits,1		; установить разрешение инкремента
		btfss PORTA,4
		btfss Bits,1 
		goto Alarm
		goto ShowAlarmTime
















;*********************************************************************************************************************
;---------------------------------------------------------------------------------------------------------------------
;  НАСТРОЙКА     (выполняется только один раз при запуске)
;******************************************************************************
;------------------
setup			; переход на метку
;------------------

;-------------------------------------------------
; Замечание! версия для 16F84.
; Замечание! здесь мы настраиваем периферию и направления портов.
; Для разных PIC этот код нужно будет менять соответственным образом.
;-------------------------------------------------
			; настройка регистра OPTION
movlw b'10001000'	;
     ;  x-------	; 7, 0=включить, 1=отключить, подтяжка порта portb
     ;  -x------	; 6, 1=/, бит выбора фронта прерывания
     ;  --x-----	; 5, источник таймера timer0, 0=внутренний генератор, 1=внешний вывод.
     ;  ---x----	; 4, внешний фронт timer0, 1=\
     ;  ----x---	; 3, привязка предделителя, 1=wdt, 0=timer0
     ;  -----x--	; 2,1,0, значение предделителя таймера timer0
     ;  ------x-	;   000=2, 001=4, 010=8, 011=16, и т.д.
     ;  -------x	; 
			; Замечание! Мы привязываем предделитель к wdt, таким образом timer0
			; НЕ имеет предделителя и будет переполняться каждые 256 команд
			; и вызывать прерывание.
banksel OPTION_REG	; выбрать надлежащий банк регистров
movwf OPTION_REG	; загрузить данные в OPTION_REG
banksel 0		; вернуться к нормальному банку регистров bank 0

;настройка регистра INTCON--------------------------------------------------------------------
			; для данного примера кода мы включаем прерывание
			; по переполнению таймера timer0.
			; прерывания включаются последними (enable interrupts last)
			; установка прерывания
movlw b'10100000'	; GIE=on TOIE=on (прерывание по переполнению таймера timer0)
movwf INTCON		; установить.
; bit 7: Глобальное разрешение прерываний: 	1=разрешены все немаскированные прерывания
;											0=все прерывания запрещены
; bit 6: Разрешение прерываний от периферийных модулей: 1=разрешены прерывания
;														0=прерывания запрещены
; bit 5: Разрешение прерывания по переполнению TMR0: 1=разрешено; 0=запрещено
; bit 4: Разрешение внешнего прерывания INT: 1=разрешено; 0=запрещено
; bit 3: Разрешение прерывания по изменению сигнала на входах RB7-RB4: 1=разрешено; 0=запрещено
; bit 2: Флаг прерывания по переполнению TMR0: 1=произошло переполнение TMR0; 0=переполнения не было
; bit 1: Флаг внешнего прерывания
; bit 0: Флаг прерывания RB7-RB4

; настройка регистра PCON---------------------------------------------------------
movlw b'00001000'
banksel PCON	; выбрать надлежащий банк регистров
movwf PCON
banksel 0		; вернуться к нормальному банку регистров

; bit 3: Выбор частоты тактового генератора: 1=4МГц; 0=32кГц
; bit 1: Флаг сброса по включению питания
; bit 0: Флаг сброса по снижению напряжения

;установка направлений выводов порта PORTB------------------------------------------------------------------------
			; 1=вход, 0=выход
	
movlw b'00000000'	; все 8 выводов порта portb устанавливаем как выходы
banksel TRISB		; выбрать надлежащий банк регистров
movwf TRISB		; установить маску на порт portb
banksel 0		; вернуться к нормальному банку регистров bank 0
clrf PORTB	

;установка направлений выводов порта PORTA---------------------------------------------------------------------------
			
			; 1=вход, 0=выход
movlw b'00010000'	; все 5 порта porta устанавливаем как выходы,
			; (в 16F84 порт porta имеет только младшие 5 бит)
banksel TRISB	; выбрать надлежащий банк регистров
movwf TRISA		; установить маску на порт porta
banksel 0		; вернуться к нормальному банку регистров
clrf PORTA	
;-------------------------------------------------
; Замечание! Теперь аппаратная часть настроена и нам нужно загрузить
; первый отсчёт (count) для одной секунды в нашу 24-битную переменную.
;-------------------------------------------------
			; Замечание! Этот пример использует тактовую частоту 4 МГц, которой
			; соответствует 1,000,000 отсчётов в секунду.
			; Нам нужен период в 1 секунду, поэтому мы должны загружать
			; 1,000,000 отсчётов каждый раз.
			; 1,000,000 = 0F 42 40 (в шестнадцатеричном формате)
			; Нам также нужно добавить 256 отсчётов для первого раза,
			; таким образом мы просто прибавляем 1 к среднему байту.
			; Если нужно, проверить переполнение среднего байта.
			; здесь мы загружаем 24-битную переменную.
movlw 0x0F		; получить значение старшего байта
movwf bres_hi		; загрузить в старший байт

movlw 0x42 +1		; получить значение среднего байта (заметьте, что мы прибавили к нему 1)
movwf bres_mid		; загрузить в средний байт

movlw 0x40		; получить значение младшего байта
movwf bres_lo		; загрузить в младший байт
			; теперь установка завершена, мы можем начать исполнение.
;-------------------------------------------------
goto main		; запустить главный цикл программы
;---------------------------------------------------------------------------------------------------------------------
;*********************************************************************************************************************

delay2 ; зарержка для 2 блока программы
		clrf PCLATH
		bsf PCLATH, 1	; содержимое PCLATH записывается в PCH при изменении PLC
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
	end		; после этой точки нет никакого кода.
;==============================================================================