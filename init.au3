#include <MsgBoxConstants.au3>
#include <GuiTreeView.au3>

Local Const $iTIMEOUT_PAR_DEFAUT = 2;
Local $sNomWorkspace = "";

main()

Func main()
   Local $hEclipse = ouvreEclipse()
   $sNomWorkspace = InputBox("Nom du futur Workspace", "Quel est le nom de ton futur Workspace?")

   ;creationNouveauWorkspace() ;Reste fichier ini
   ;creationServeurTomcat() ;Fini pour tomcat 7.0
   ;importDesPreferences() ;Reste fichier ini
   ;configureLaTargetPlateform()
EndFunc   ;==>main

Func ouvreEclipse()
   Local $hEclipse = WinWait("[REGEXPTITLE: - Eclipse]", "", $iTIMEOUT_PAR_DEFAUT)
   verifieEcranPresent($hEclipse, "Eclipse doit �tre d�marr�")
   WinActivate($hEclipse)
   return $hEclipse
EndFunc   ;==>ouvreEclipse

Func creationNouveauWorkspace()
   ;Ouvre le switch de workspace depuis le menu File
   Send("!fwo")
   Send("^a{DEL}")
   ;TODO : externaliser dans fichier ini
   Send("DossierWorkspace\" & $sNomWorkspace)
EndFunc ;==> creationNouveauWorkspace

Func creationServeurTomcat()
   ;Ouvre la config serveur
   Send("!wp")
   Local $hPreferences = attendEcran("[TITLE:Preferences]")
   verifieEcranPresent($hPreferences, "Les pr�f�rences devrait �tre ouvert")

   ;S�lectionne le Runtime Environment
   Send("Server")
   Sleep(500)
   selectionElementDansTreeView("Runtime Environment", $hPreferences)

   ;Ouvre l'�cran de cr�ation de server
   Send("!a")
   Local $hServeurs = attendEcran("[TITLE:New Server Runtime]")
   ;TODO: conditionn� par rapport � la tp, la s�lection du Tomcat v6 ou v7
   selectionElementDansTreeView("Apache Tomcat v7.0", $hServeurs)

   ;Appuye sur le bouton Next
   Send("!n")
   Sleep(200)
   Send("{TAB}")
   ;On s�lectionne au cas o� du texte est pr�sent
   Send("^a")
   Send("C:\francis\dev\eclipse-jee\serverTomcat")
   Send("!f")
   WinWaitClose($hServeurs)
   ;Valide l'�cran de pr�f�rence
   Send("{ESC}")
EndFunc

Func temp()

EndFunc

Func importDesPreferences()
   Send("!fi")
   Local $hImport = attendEcran("[TITLE:Import]")
   verifieEcranPresent($hImport, "L'�cran d'import devrait �tre ouvert")
   Send("Preferences")
   selectionElementDansTreeView("Preferences", $hImport)
   ;Ecran suivant
   Send("{ENTER}")
   ;TODO�:�mettre dans un fichier ini
   Send("C:\pref.epf")
   ;Finish
   Send("!fi")
   Local $bIsFerme = WinWaitClose("[TITLE:Import]", "", 2)
   verifieEcranFerme($bIsFerme, "L'�cran d'import devrait �tre ferm�")
EndFunc

Func selectionElementDansTreeView($sNomElement, $hParent)
   Sleep(200)
   $treeview=ControlGetHandle($hParent, "", "SysTreeView321") ;1er SysTreeView32, dans la plupart des �crans �clipse 1 seul
   $hItemFound = _GUICtrlTreeView_FindItem($treeview, $sNomElement, True)
   _GUICtrlTreeView_SelectItem($treeview, $hItemFound)
   Sleep(200)
EndFunc

Func attendEcran($sTitle)
   return WinWaitActive($sTitle, "", $iTIMEOUT_PAR_DEFAUT)
EndFunc

Func verifieEcranPresent($hEcranAffiche, $sMessageErreur)
   util_messageSiZero($hEcranAffiche, $sMessageErreur)
EndFunc

Func verifieEcranFerme($hEcranFerme, $sMessageErreur)
   util_messageSiZero($hEcranFerme, $sMessageErreur)
EndFunc

Func util_messageSiZero($hValeur, $sMessageErreur)
   If $hValeur = 0 Then
      MsgBox($MB_SYSTEMMODAL, "Erreur", $sMessageErreur)
	  ;on arr�te le programme
      Exit
   EndIf
EndFunc