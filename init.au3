#include <MsgBoxConstants.au3>
#include <GuiTreeView.au3>
#include "iniManager.au3";gestion du fichier ini

Local Const $iTIMEOUT_PAR_DEFAUT = 2;
Local $sNomWorkspace = "";

; pour le moment, se concentré sur la création d'un workspace pour une application, adaptera ensuite
main()

Func main()
   Local $hEclipse = ouvreEclipse()
   ;temp()
   ;$sNomWorkspace = demandeNomPourLeWorkspace()
   ;WinActivate($hEclipse)
   ;creationNouveauWorkspace() ; TODO: valider l'écran des stats eclipse
   importDesPreferences()
   ;creationServeurTomcat() ; TODO:gerer tomcat 6, vérifier que tomcat utilise la bonne version java8
   ;checkOutSvnProject() ;TODO: à faire
   ;importProjectSet() ;TODO: à faire
   ;checkOutPourApplis() ;TODO: à faire, checkout les serveurs et config en fonction de l'application (les autres projects seront les branches crees)
   ;mavenUpdate() ;TODO: à faire, avec force update
   ;projectClean() ;TODO: à faire
   ;ignoreFichierCommit() ;TODO: ignorer les fichiers settings pour le commit en mettant dans un te
   ;configurationServeurTomcat() ;TODO :ajouter les serveurs, modifier le timeout
   ;configureLaTargetPlateform() ; TODO decoche "include required software" et coche "include all environments", (tp4.4: tp-dev et updatesite)
   ;configureBDD() ;TODO: pointe les serveurs sur la base de dev
EndFunc   ;==>main

Func ouvreEclipse()
   Local $hEclipse = WinWait("[REGEXPTITLE: - Eclipse]", "", $iTIMEOUT_PAR_DEFAUT)
   verifieEcranPresent($hEclipse, "Eclipse doit être démarré")
   WinActivate($hEclipse)
   Return $hEclipse
EndFunc   ;==>ouvreEclipse

Func demandeNomPourLeWorkspace()
   Local $sValeur = InputBox("Nom du futur Workspace", "Quel est le nom de ton futur Workspace?")
   ;En cas d'annulation due la saisie du nom, on n'arrete le programme
   If ($sValeur = "") Then
	  Exit
   EndIf
   return $sValeur;
EndFunc

Func creationNouveauWorkspace()
   ;Ouvre le switch de workspace depuis le menu File
   Send("!fwo")
   Local $hWorkspace = attendEcran("[TITLE:Workspace Launcher]")
   verifieEcranPresent($hWorkspace, "L'écran de définiton du workspace devrait être ouvert")
   ;On renseigne le workspace
   ControlSend($hWorkspace, "", "Edit1", getDossierWorkspace() & "\" & $sNomWorkspace)
   ;Send("^a{DEL}")
   ;Appuye sur OK
   ControlClick($hWorkspace, "", "Button4")
   WinWaitClose("[REGEXPTITLE: - Eclipse]")
   ;On attend qu'eclipse redemarre
   Local $hEclipseRestart = WinWait("[REGEXPTITLE: - Eclipse]")
   ;On laisse le temps à eclipse de finir de se charger
   Sleep(5000)
   WinActivate($hEclipseRestart)
   ;ferme l'écran de bienvenue
   ControlClick($hEclipseRestart, "", "SWT_Window03", "left", 1, 80, 12)
EndFunc ;==> creationNouveauWorkspace

Func creationServeurTomcat()
   ;Ouvre la config serveur
   Send("!wp")
   Local $hPreferences = attendEcran("[TITLE:Preferences]")
   verifieEcranPresent($hPreferences, "Les préférences devrait être ouvert")

   ;Sélectionne le Runtime Environment
   Send("Server")
   Sleep(500)
   selectionElementDansTreeView("Runtime Environment", $hPreferences)

   ;Ouvre l'écran de création de server
   Send("!a")
   Local $hServeurs = attendEcran("[TITLE:New Server Runtime]")
   ;TODO: conditionné par rapport à la tp, la sélection du Tomcat v6 ou v7
   selectionElementDansTreeView("Apache Tomcat v7.0", $hServeurs)

   ;Appuye sur le bouton Next
   Send("!n")
   Sleep(200)
   Send("{TAB}")
   ;On sélectionne au cas où du texte est présent
   Send("^a")
   ;TODO : conditionne sur la tp
   Send(getEmplacementTomcat7())
   Send("!f")
   WinWaitClose($hServeurs)
   ;Valide l'écran de préférence
   Send("{ESC}")
EndFunc

Func configurationServeurTomcat()
   ;Affiche  la vue des serveurs
   Send("!wvo")
   attendEcran("[TITLE:Show View]")
   Send("Servers")
   Send("{TAB}")
   Send("{ENTER}")
EndFunc

Func tempDebug()
   Local $hEclipse = WinWait("[REGEXPTITLE: - Eclipse]")
   WinActivate($hEclipse)

EndFunc

Func importDesPreferences()
   Send("!fi")
   Local $hImport = attendEcran("[TITLE:Import]")
   verifieEcranPresent($hImport, "L'écran d'import devrait être ouvert")
   Send("Preferences")
   selectionElementDansTreeView("Preferences", $hImport)
   ;Ecran suivant
   Send("!n")
   Send(getEmplacementPreferences())
   ;attend le chargement
   Sleep(500)
   ;Finish
   Send("!fi")
   Local $bIsFerme = WinWaitClose("[TITLE:Import]", "", 2)
   verifieEcranFerme($bIsFerme, "L'écran d'import devrait être fermé")
EndFunc

Func selectionElementDansTreeView($sNomElement, $hParent)
   Sleep(500)
   $treeview=ControlGetHandle($hParent, "", "SysTreeView321") ;1er SysTreeView32, dans la plupart des écrans éclipse 1 seul
   $hItemFound = _GUICtrlTreeView_FindItem($treeview, $sNomElement, True)
   _GUICtrlTreeView_SelectItem($treeview, $hItemFound)
   Sleep(200)
EndFunc

Func attendEcran($sTitle)
   Return WinWaitActive($sTitle, "", $iTIMEOUT_PAR_DEFAUT)
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
	  ;on arrête le programme
      Exit
   EndIf
EndFunc
