#include <MsgBoxConstants.au3>

Local Const $iTIMEOUT_PAR_DEFAUT = 2;

main()

Func main()
   Local $hEclipse = ouvreEclipse()

   ;creationNouveauWorkspace()
   ;creationServeurTomcat()
   importDesPreferences()
EndFunc   ;==>main

Func ouvreEclipse()
   Local $hEclipse = attendEcran("[REGEXPTITLE:Eclipse]")
   verifieEcranPresent($hEclipse, "Eclipse doit �tre d�marr�")
   WinActivate($hEclipse)
   return $hEclipse
EndFunc   ;==>ouvreEclipse

Func creationNouveauWorkspace()
   ;Ouvre le switch de workspace depuis le menu File
   Send("!fwo")
EndFunc ;==> creationNouveauWorkspace

Func creationServeurTomcat()
   ;Ouvre la config serveur
   Send("!wp")
   Local $hPreferences = attendEcran("[TITLE:Preferences]")
   verifieEcranPresent($hPreferences, "Les pr�f�rences n'ont pas �t� ouvertes")
   Send("Server")
EndFunc

Func importDesPreferences()
   Send("!fi")
   Local $hImport = attendEcran("[TITLE:Import]")
   verifieEcranPresent($hImport, "L'�cran d'import n'a pas �t� ouvert")
   Send("Preferences")
EndFunc

Func attendEcran($sTitle)
   return WinWait($sTitle, "", $iTIMEOUT_PAR_DEFAUT)
EndFunc

Func verifieEcranPresent($hEcranAffiche, $sMessageErreur)
   If $hEcranAffiche = 0 Then
      MsgBox($MB_SYSTEMMODAL, "Erreur", $sMessageErreur)
	  ;on arr�te le programme
      Exit
   EndIf
EndFunc