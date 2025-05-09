ORG 0
	; start w/ 100 BPM normal  
    
    loadi 100
	or bit9
    out metronome

    
    call tensecdelay
    
    ; 100 BPM flashing mode
    loadi 100

    out metronome
    
    call tenSecDelay
    
    ; goes from 256 bpm down to zero
    call slowdown
    
    ; finally, in switches-out leds for the rest of the time
    infloop:
    in switches
    out metronome
	jump infloop
    
    
slowdown:

	sLoop:
    load max
    out metronome
    
    call tenthsecdelay
    
    load max
    sub one
    store max
    jpos sLoop
    
    loadi 256
	store max
	return

tenthSecDelay:
	out timer
    pollLoop2:
      in timer
      sub one
    jneg pollLoop2 ; keep jumping untill 100 deciseconds
    return
    
tenSecDelay:
	out timer
    pollLoop:
      in timer
      sub hundred
    jneg pollLoop ; keep jumping untill 100 deciseconds
    return

one: DW 1
hundred: DW 100
max: DW 256

Bit9:      DW &B1000000000

; IO address constants
Switches:  EQU 000
metronome: EQU 032
Timer:     EQU 002

