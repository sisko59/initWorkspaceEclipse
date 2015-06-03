#include <MsgBoxConstants.au3>

Global Const $sCONFIG_INI = "config.ini"

Func getDossierWorkspace()
   Return IniRead ($sCONFIG_INI, "Workspace", "dossier", "Workspace_dossier_NON_DEFINI" )
EndFunc

Func getEmplacementPreferences()
   Return IniRead ($sCONFIG_INI, "Preferences", "emplacement", "Preferences_emplacement_NON_DEFINI" )
EndFunc