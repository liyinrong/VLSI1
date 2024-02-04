printf("DZ: BEGIN OF USER CUSTOMIZATION LOADING\n")

/* 
   For explanations and examples see the site and user cdsinit templates: 

       site:   <cds_install_dir>/samples/local/cdsinit
       user:   <cds_install_dir>/cdsuser/.cdsinit
   
       <cds_install_dir> is the dfII root, e.g. /usr/pack/cadence_ic446-qsr2-ma/tools/dfII
          

   Configuration files/code can be found here:

      <cds_install_dir>/samples/local/
                                  cdsinit
                                  aaConfig.il
                                  dciConfig.il
                                  metConfig.il
                                  sysConfig.il
                                  uiConfig.il

   Environment variables (defaults) can be found here:
      <cds_install_dir>/etc/tools/
                               layout/.cdsenv
                               schematic/.cdsenv
                               graphic/.cdsenv
                               ... 

   Bindkey definition files can be found here:
      <cds_install_dir>/samples/local
                          leBindKeys.il                - layout editor
                          schBindKeys.il               - schematic editor
                          ... 
 
*/

;################################################
;#
;# SETTINGS FOR SKILL PATH and SKILL PROGRAMMING
;#
;################################################
; 
;sstatus(writeProtect nil)
;
;let((skillPath)
;   skillPath= strcat(
;    ". ~ "                                          ; Current & home directory
;    prependInstallPath("samples/techfile ")         ; sample source technology files
;   )
;   setSkillPath(skillPath)
;)
;
;################################################
;#
;# DEFINE PERSONAL BIND KEYS
;#
;################################################
;
; hiSetBindKey("Schematics"     "None<Btn2Down>(2)"     "schHiDescendRead()")
;
;################################################
;#
;# DEFAULT TEXT EDITOR
;#
;################################################
;
; The variable editor defines the text editor to be used when any of
; the applications invoke an editor. For example technology dump and edit
; operation opens an editor window. 
;
; The editor may also be set by 
;               
;         unix environment variable EDITOR
;
;             setenv EDITOR 'xedit'
;
;
; When Design Framework is invoked the SKILL variable editor is set to the
; value of the unix variable EDITOR.
;  
; If EDITOR is not defined the SKILL variable
; editor is set to "vi"
;
; You may also set the variable to execute a UNIX command
; that invokes an xterm window of given size and location
; and starts an editor program.
; Example:
;
;    editor = "xterm -geometry 80x40 -e emacs"
;
; Size of xterm in the above example is 80 characters by 40 lines.
; With some editors on certain platforms the variable editor must
; be defined as shown above.
;
; Some application which require a text editor may be using the UNIX
; variable EDITOR instead of the SKILL variable editor. It is a good
; idea to set the UNIX variable EDITOR to the text editor of your
; choice which will automatically set the SKILL variable editor.
; 
;
; Other Examples
;
;editor = "xterm -geometry 85x50 -e vi";
;editor = "vi";
;editor = "textedit";
;
;#####################################################################
;#
;# Window size & position 
;#
;#####################################################################
;
; *** CIW (better use the .cdsXresources file, see below)
; hiResizeWindow(hiGetCIWindow() list(5:-20 900:300))      ; Left-hand side
; hiResizeWindow(hiGetCIWindow() list(375:-20 1275:300))   ; Right-hand side
; hiFlush()
;
; *** CIW,LSW, LibManager and more can be set via the .init/cdsXresources
; *** file in your current working directory! This file gets loaded 
; *** automatically!
;
; *** Default size+position for layout, schematic and symbol windows
; envSetVal("layout"    "leWindowBBox"  'string "((128 150) (1180 1000))")
; envSetVal("schematic" "schWindowBBox" 'string "((128 150) (1180 1000))")
; envSetVal("schematic" "symWindowBBox" 'string "((128 150) (1180 1000))")
;
;############################################################################
;#                                           
;# Analog Environment
;#
;#############################################################################

allAvailableTools = envGetAvailableTools()

when(member("asimenv" allAvailableTools)
  strcat(getWorkingDir() "/.cdslocal")
  envSetVal( "asimenv"  "saveDir" 'string  "./.artist_states")
  envSetVal( "asimenv.startup"  "projectDir" 'string  strcat(getWorkingDir() "/simulation"))
  envSetVal( "asimenv.startup"  "remoteDir"  'string  strcat(getWorkingDir() "/simulation"))
  envSetVal( "asimenv.startup"  "host" 'string  "opal")
;  if(!rexMatchp("version 5[.]0" getVersion()) then
;    envSetVal( "asimenv.startup"  "cds_ade_wftool" 'string  "awd")
;  )
) ; when asimenvTool defined

;############################################################################
;#                                           
;# MISC USER PREFERENCES
;#
;#############################################################################
;
; *** You can set your environment values here with envSetVal (preferred)
; *** or create a file ./.init/cdsenv_user and put it there. 
; *** Remark: Some options do only work in the ./.cdsenv or even ~/.cdsenv file! 
;
; envSetVal( "ui"    "winPlaceStyle"       'boolean nil)
; envSetVal( "ui"    "showScrollBars"      'boolean t)
; envSetVal( "ui"    "showFixedMenu"       'cyclic "None")
; envSetVal( "ui"    "showFixedMenuLabels" 'boolean nil)
; envSetVal( "ui"    "dblClkTime           'int  400)
; envSetVal( "ui"    "infix"               'boolean t)
envSetVal( "ui"    "nestLimit"           'int  5)
envSetVal( "ui"    "undoLevel"           'int  10)
envSetVal( "schematic"  "srcSolderOnCrossover" 'cyclic  "ignored")
; envSetVal( "layout"  "xSnapSpacing" 'float  0.005)
; envSetVal( "layout"  "ySnapSpacing" 'float  0.005)
envSetVal( "ddserv.lib" "techChoice"     'cyclic  "bind")
envSetVal( "ddserv" "showWhatsNew" 'string "no")
 

let( (envuser)
     envuser = "./.init/cdsenv_user"
     if( isFile( envuser ) then
         printf( "DZ: Loading user env file %s\n" envuser )
         envLoadFile( envuser )
     )
)

;#####################################################################
;#
;# SET UP PREFERENCES FOR PLOTTER
;#
;#####################################################################
;
; *** schematic and layout
when( isFile( "./.init/cdsSchPlotTemplate" )
      schPlotTemplate = "./.init/cdsSchPlotTemplate")
when( isFile( "./.init/cdsLePlotTemplate" )
      lePlotTemplate = "./.init/cdsLePlotTemplate")
;
; *** waveform window
awvSetOptionValue("hcHeader" nil)
awvSetOptionValue("hcMailLogNames" nil)
;
;############################################################################
;#
;# Launch some useful stuff
;#
;############################################################################
;
; ddsOpenLibManager()
;

printf("DZ: END OF USER CUSTOMIZATION LOADING\n")

