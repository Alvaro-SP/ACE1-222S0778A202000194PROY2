
chcp 65001
@REM C:\Users\alvaro\OneDrive - Facultad de Ingeniería de la Universidad de San Carlos de Guatemala\6 S E X T O   S E M E S T R E\arquiiiiiiii  1\LAB ARQUI\PRACTICAS\4\ACE1-222S0778A202000194PRAC4\P4.asm
copy "C:\Users\alvaro\OneDrive - Facultad de Ingeniería de la Universidad de San Carlos de Guatemala\6 S E X T O   S E M E S T R E\arquiiiiiiii  1\LAB ARQUI\PROYECTOS\2\ACE1-222S0778A202000194PROY2\PROY2.asm" "C:\MASM\MASM611\BIN\PROY2.asm"
copy "C:\Users\alvaro\OneDrive - Facultad de Ingeniería de la Universidad de San Carlos de Guatemala\6 S E X T O   S E M E S T R E\arquiiiiiiii  1\LAB ARQUI\PROYECTOS\2\ACE1-222S0778A202000194PROY2\MACP2.inc" "C:\MASM\MASM611\BIN\MACP2.inc"
copy "C:\Users\alvaro\OneDrive - Facultad de Ingeniería de la Universidad de San Carlos de Guatemala\6 S E X T O   S E M E S T R E\arquiiiiiiii  1\LAB ARQUI\PROYECTOS\2\ACE1-222S0778A202000194PROY2\FILEP2.inc" "C:\MASM\MASM611\BIN\FILEP2.inc"
DEL /F /A "C:\MASM\MASM611\BIN\PROY2.exe"
cd "C:\Program Files (x86)\DOSBox-0.74-3\"
DOSBox.exe
@REM pause