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
   verifieEcranPresent($hEclipse, "Eclipse doit être démarré")
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
   verifieEcranPresent($hPreferences, "Les préférences n'ont pas été ouvertes")
   Send("Server")
EndFunc

Func importDesPreferences()
   Send("!fi")
   Local $hImport = attendEcran("[TITLE:Import]")
   verifieEcranPresent($hImport, "L'écran d'import n'a pas été ouvert")
   Send("Preferences")
EndFunc

Func attendEcran($sTitle)
   return WinWait($sTitle, "", $iTIMEOUT_PAR_DEFAUT)
EndFunc

Func verifieEcranPresent($hEcranAffiche, $sMessageErreur)
   If $hEcranAffiche = 0 Then
      MsgBox($MB_SYSTEMMODAL, "Erreur", $sMessageErreur)
	  ;on arrête le programme
      Exit
   EndIf
EndFunc