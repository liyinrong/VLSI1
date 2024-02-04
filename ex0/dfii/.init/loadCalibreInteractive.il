printf("DZ: BEGIN OF CALIBRE INTERACTIVE LOADING\n")


; Load the env variables
load("/usr/pack/calibre-2013.3-kgf/DZ_STUFF/skill/calibre_env.il")

;
; check MGC_HOME
;
mgc_home=getShellEnvVar("MGC_HOME")

if( mgc_home!=nil && isDir(mgc_home) && isReadable(mgc_home) then

    ; Load calibre.skl or calibre.4.3.skl, not both!

    ; Load calibre.skl for Cadence versions 4.4 and greater
    ; load(strcat(mgc_home "/lib/calibre.skl"))
    load(strcat(mgc_home "/lib/calibre.OA.skl"))

;;;;Load calibre.4.3.skl for Cadence version 4.3
;;; load(strcat(mgc_home "/lib/calibre.4.3.skl"))

else

    ; MGC_HOME is not set correctly. Report the problem.

    printf("//  Calibre Error: Environment variable ")

    if( mgc_home==nil || mgc_home=="" then
        printf("MGC_HOME is not set.");
    else
        if( !isDir(mgc_home) then
            printf("MGC_HOME does not point to a directory.");
        else
            if( !isReadable(mgc_home) then
                printf("MGC_HOME points to an unreadable directory.");
            )
        )
    )
    printf(" Calibre Skill Interface not loaded.\n")

    ; Display a dialog box message about load failure.

    hiDisplayAppDBox(
        ?name           'MGCHOMEErrorDlg
        ?dboxBanner     "Calibre Error"
        ?dboxText       "Calibre Skill Interface not loaded."
        ?dialogType     hicErrorDialog
        ?dialogStyle    'modal
        ?buttonLayout   'Close
    )
)

;;;  end some variables:
setShellEnvVar("MGC_CALIBRE_DRC_RUNSET_FILE=../calibre/drc/runset.drc")
setShellEnvVar("MGC_CALIBRE_LVS_RUNSET_FILE=../calibre/lvs/runset.lvs")
setShellEnvVar("MGC_CALIBRE_PEX_RUNSET_FILE=../calibre/pex/runset.pex")
mgc_eview_globals->cellMapFile = "../calibre/pex/calview.cellmap"

;;; these are the empty subcircuits
;mgc_rve_init_cdlout_keys()
;cdlOutKeys->incFILE = "/usr/pack/smic-65-kgf/dz/calibre/2010.2/lvs/empty_subckt.sp_cal"

;; alternative trick
;;mgc_calibre_export_netlist_template_file ="/usr/pack/smic-130-kgf/dz/calibre/2010.2/dfii/mgc_export_template.il"
;;mgc_rve_load_export_netlist_template_file()

printf("DZ: END OF CALIBRE INTERACTIVE LOADING\n")

