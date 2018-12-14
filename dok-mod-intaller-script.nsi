!include "MUI.nsh"
!include 'LogicLib.nsh'
!define VERSION v0.16

Function StrUpper
  Exch $0 ; Original string
  Push $1 ; Final string
  Push $2 ; Current character
  Push $3
  Push $4
  StrCpy $1 ""
Loop:
  StrCpy $2 $0 1 ; Get next character
  StrCmp $2 "" Done
  StrCpy $0 $0 "" 1
  StrCpy $3 65 ; 65 = ASCII code for A
Loop2:
  IntFmt $4 %c $3 ; Get character from current ASCII code
  StrCmp $2 $4 Match
  IntOp $3 $3 + 1
  StrCmp $3 91 NoMatch Loop2 ; 91 = ASCII code one beyond Z
Match:
  StrCpy $2 $4 ; It 'matches' (either case) so grab the uppercase version
NoMatch:
  StrCpy $1 $1$2 ; Append to the final string
  Goto Loop
Done:
  StrCpy $0 $1 ; Return the final string
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Exch $0
FunctionEnd

### TimeStamp
!ifndef TimeStamp
    !define TimeStamp "!insertmacro _TimeStamp"
    !macro _TimeStamp FormatedString
        !ifdef __UNINSTALL__
            Call un.__TimeStamp
        !else
            Call __TimeStamp
        !endif
        Pop ${FormatedString}
    !macroend
 
!macro __TimeStamp UN
Function ${UN}__TimeStamp
    ClearErrors
    ## Store the needed Registers on the stack
        Push $0 ; Stack $0
        Push $1 ; Stack $1 $0
        Push $2 ; Stack $2 $1 $0
        Push $3 ; Stack $3 $2 $1 $0
        Push $4 ; Stack $4 $3 $2 $1 $0
        Push $5 ; Stack $5 $4 $3 $2 $1 $0
        Push $6 ; Stack $6 $5 $4 $3 $2 $1 $0
        Push $7 ; Stack $7 $6 $5 $4 $3 $2 $1 $0
        ;Push $8 ; Stack $8 $7 $6 $5 $4 $3 $2 $1 $0
 
    ## Call System API to get the current system Time
        System::Alloc 16
        Pop $0
        System::Call 'kernel32::GetLocalTime(i) i(r0)'
        System::Call '*$0(&i2, &i2, &i2, &i2, &i2, &i2, &i2, &i2)i (.r1, .r2, n, .r3, .r4, .r5, .r6, .r7)'
        System::Free $0
 
        IntFmt $2 "%02i" $2
        IntFmt $3 "%02i" $3
        IntFmt $4 "%02i" $4
        IntFmt $5 "%02i" $5
        IntFmt $6 "%02i" $6
 
    ## Generate Timestamp
        ;StrCpy $0 "YEAR=$1$\nMONTH=$2$\nDAY=$3$\nHOUR=$4$\nMINUITES=$5$\nSECONDS=$6$\nMS$7"
        StrCpy $0 "$1$2$3$4$5$6.$7"
 
    ## Restore the Registers and add Timestamp to the Stack
        ;Pop $8  ; Stack $7 $6 $5 $4 $3 $2 $1 $0
        Pop $7  ; Stack $6 $5 $4 $3 $2 $1 $0
        Pop $6  ; Stack $5 $4 $3 $2 $1 $0
        Pop $5  ; Stack $4 $3 $2 $1 $0
        Pop $4  ; Stack $3 $2 $1 $0
        Pop $3  ; Stack $2 $1 $0
        Pop $2  ; Stack $1 $0
        Pop $1  ; Stack $0
        Exch $0 ; Stack ${TimeStamp}
 
FunctionEnd
!macroend
!insertmacro __TimeStamp ""
!insertmacro __TimeStamp "un."
!endif
###########

!define StrRep "!insertmacro StrRep"
!macro StrRep output string old new
    Push `${string}`
    Push `${old}`
    Push `${new}`
    !ifdef __UNINSTALL__
        Call un.StrRep
    !else
        Call StrRep
    !endif
    Pop ${output}
!macroend
 
!macro Func_StrRep un
    Function ${un}StrRep
        Exch $R2 ;new
        Exch 1
        Exch $R1 ;old
        Exch 2
        Exch $R0 ;string
        Push $R3
        Push $R4
        Push $R5
        Push $R6
        Push $R7
        Push $R8
        Push $R9
 
        StrCpy $R3 0
        StrLen $R4 $R1
        StrLen $R6 $R0
        StrLen $R9 $R2
        loop:
            StrCpy $R5 $R0 $R4 $R3
            StrCmp $R5 $R1 found
            StrCmp $R3 $R6 done
            IntOp $R3 $R3 + 1 ;move offset by 1 to check the next character
            Goto loop
        found:
            StrCpy $R5 $R0 $R3
            IntOp $R8 $R3 + $R4
            StrCpy $R7 $R0 "" $R8
            StrCpy $R0 $R5$R2$R7
            StrLen $R6 $R0
            IntOp $R3 $R3 + $R9 ;move offset by length of the replacement string
            Goto loop
        done:
 
        Pop $R9
        Pop $R8
        Pop $R7
        Pop $R6
        Pop $R5
        Pop $R4
        Pop $R3
        Push $R0
        Push $R1
        Pop $R0
        Pop $R1
        Pop $R0
        Pop $R2
        Exch $R1
    FunctionEnd
!macroend
!insertmacro Func_StrRep ""
!insertmacro Func_StrRep "un."

Name "More Maps ${VERSION}"

  !insertmacro MUI_PAGE_WELCOME
  ;!insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  ;!insertmacro MUI_UNPAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
  !insertmacro MUI_UNPAGE_COMPONENTS
  !insertmacro MUI_UNPAGE_DIRECTORY
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

  !insertmacro MUI_LANGUAGE "English" ; The first language is the default language


#define installer name
OutFile "installer.exe"
InstallDir "$PROGRAMFILES32\Steam\steamapps\common\Deserts of Kharak"

Var backup
Section "Backup Managed" backup_section_id
    # define output path
    SetOutPath $INSTDIR
	${TimeStamp} $0
	StrCpy $backup "Data\Managed-$0"
 
    ${If} ${FileExists} '$INSTDIR\*.*'
		${If} ${FileExists} '$INSTDIR\$backup\*.*'
			RMDir /r "$INSTDIR\Data\Managed"
		${Else}
		    Rename "$INSTDIR\Data\Managed" "$INSTDIR\$backup"
		${EndIf}

    ${Else}
        MessageBox MB_ICONEXCLAMATION "Did not find Deserts of Kharak folders $INSTDIR"
    ${EndIf}

SectionEnd

Section "Install Map Mod" install_section_id
    # define output path
	CreateDirectory "$INSTDIR\Data\Managed"
    SetOutPath "$INSTDIR\Data\Managed"
    
    ${If} ${FileExists} "$INSTDIR\*.*"
        file /r "Managed\"
    ${Else}
        MessageBox MB_ICONEXCLAMATION "Did not find Deserts of Kharak folder $INSTDIR"
    ${EndIf}

SectionEnd

Function .onInit
	# auto detect steam install location
 	ReadRegStr $0 HKCU SOFTWARE\Valve\Steam\ SteamPath
	Push $0
	Call StrUpper
	Pop $0
	${StrRep} '$0' '$0' '/' '\'
	StrCpy $INSTDIR "$0\steamapps\common\Deserts of Kharak"
	
	# make backup section read only
	SectionSetFlags ${backup_section_id} 17 # 16 = RO; 1 = SELECTED
	SectionSetFlags ${install_section_id} 17 # 16 = RO; 1 = SELECTED
FunctionEnd

; Uninstaller disabled for now because of difficulties with backups that could not be vanilla
; Section 'Create Unistaller'

    ; # define output path
    ; SetOutPath $INSTDIR

    ; # define uninstaller name
	; ${If} ${FileExists} '$INSTDIR\*.*'
         ; WriteUninstaller "$INSTDIR\more-maps-uninstaller.exe"
    ; ${Else}
        ; MessageBox MB_ICONEXCLAMATION "Did not find Deserts of Kharak folder $INSTDIR"
    ; ${EndIf}
   

; SectionEnd


# create a section to define what the uninstaller does.
# the section will always be named "Uninstall"
; Section "Uninstall"
 
    ; # Always delete uninstaller first
    ; Delete "$INSTDIR\dok-mod-uninstaller.exe"
	
	; RMDir /r "$INSTDIR\Data\Managed"
    ; Rename "$INSTDIR\${BACKUP}" "$INSTDIR\Data\Managed\"

    ; # now delete installed file
    ; Delete "$INSTDIR\${BACKUP}"
	
	; ExecShell "" "http://nsis.sourceforge.net/Docs/"
	
; SectionEnd