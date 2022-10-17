;Set R0 to 0 for input mode
mov R1,#0

;Set R0 to string location
ldr R0,=MyFile

;Open file
swi 0x66
bcs Exit ;exit if file open fails
mov R4,R0 ; save file handle to R4

readLoop:
swi 0x6c ;read int from file
bcs endRead
add R9,R9,#1 ;R9 as count Register

;Compare Counter, if past 2nd Int Read
;Jump to Loop1
cmp R9,#2
bGT Loop1

;move int to R8(1st Int(x))
cmp R9,#1
movEQ R8,R0

;move int to R7(2nd Int(y))
cmp R9,#2
movEQ R7,R0

;Finds and Store Ints <= 1st Int(x) into R6
Loop1:
cmp R0,R8
addLE R6,R6,#1

;Find and Store Ints == 2nd Int(y) into R5
cmp R0,R7
addEQ R5,R5,#1

;Prepare next Int read
mov R0,R4 ; recall file handle to R0
b readLoop

endRead:
cmp R9,#2 ;Error check # of Ints, exit w/ Error Message
bLT intExit

;***Start Output***
mov R0,#1 ;set file handle to stdout

;Print Int(x)
ldr R1,=std0
swi 0x69
mov R1,R8
swi 0x6b
mov R0,#1
ldr R1,=Space
swi 0x69

;Print Int(y)
ldr R1,=std1
swi 0x69
mov R1,R7
swi 0x6b
ldr R1,=Space
swi 0x69

;Print # of Ints <= Int(x)
ldr R1,=std2
swi 0x69
mov R1,R6
swi 0x6b
ldr R1,=Space
swi 0x69

;Print # of Ints == Int(y)
ldr R1,=std3
swi 0x69
mov R1,R5
swi 0x6b
ldr R1,=Space
swi 0x69

;Print total # of Ints
ldr R1,=std4
swi 0x69
mov R1,R9
swi 0x6b
ldr R1,=Space
swi 0x69

;set R0 to file handle for file to be closed
mov R0,R4
swi 0x68 ; close file

normalExit:
mov R0,#1
ldr R1,=exitStr2
swi 0x69
swi 0x11

;Exit if file can not be opened
Exit:
mov R0,#1
ldr R1,=exitStr
swi 0x69
mov R0,R4
swi 0x68
swi 0x11

;Exit if not enough Ints in file
intExit:
mov R0,#1
ldr R1,=exitStr1
swi 0x69
mov R0,R4
swi 0x68
swi 0x11

.data
MyFile: .asciz "integers.dat" ; Label for MyFile also note: \0 after string 

;Output Strings
Space: .asciz "\n"
std0: .asciz "First Int(x) = "
std1: .asciz "Second Int(y) = "
std2: .asciz "# of Ints <= to Int(x) = "
std3: .asciz "# of occurences of Int(y) = "
std4: .asciz "Total # of Integers = "
exitStr: .asciz "File Failed to Open!!! ***Exiting Now***"
exitStr1: .asciz "File does has not enough Integers to complete required Tasks!!!"
exitStr2: .asciz "File Parse and Task Completed Successfully. Exiting Now!"
