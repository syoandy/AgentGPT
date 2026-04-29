LABEL : START
COMMENT : Launch MicroSIP softphone.
OPEN FILE : C:\Users\Mango\AppData\Local\MicroSIP\MicroSIP.exe :  : 0
DELAY : 2000
COMMENT : Wait for MicroSIP window to be ready.
WAIT FOR : *MicroSIP* : appear : 0 : 0
COMMENT : Activate the dial field.
SWITCH TO WINDOW : *MicroSIP* : 0
COMMENT : Dial the QA test line.
TYPE TEXT : 786-948-1567
Keyboard : Enter : KeyPress
COMMENT : Wait 4500 ms for call to connect.
DELAY : 4500
COMMENT : Play local audio file.
OPEN FILE : C:\Users\Mango\OneDrive\Desktop\aventura_obsesion.wav :  : 0
COMMENT : Re-focus MicroSIP before hangup.
SWITCH TO WINDOW : *MicroSIP* : 0
COMMENT : Hang up call.
Keyboard : Escape : KeyPress
COMMENT : Restart loop.
GOTO : START
