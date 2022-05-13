; Use HL as Pointer
; if '>', inc HL
; if '<', dec HL
; if '+', inc (HL)
; if '-', dec (HL)
; if '.', output char that's at (HL)
; if ',', input byte to (HL)
; if '[' && (HL) := 0, inc HL until ']'
; if ']' && (HL) != 0, dec until '['
