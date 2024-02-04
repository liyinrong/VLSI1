;
; v0.1 - <kgf@ee.ethz.ch> - Mon Jun  6 16:19:03 CEST 2011
;   - first versio, copied stuff from the smic-65 flow
; 610 settings
envSetVal( "ui"  "webBrowser" 'string  "/usr/bin/firefox")
envSetVal( "graphic" "schematicDefaultApp" 'string  "Schematics XL")
envSetVal( "graphic" "maskLayoutDefaultApp"  'string  "Layout L")

; this prevents annoying pop ups
envSetVal( "designEditor.license"    "appsWhichAlwaysTryHigherTieredLicense",   'string  "ADE L, ADE XL, Schematics L,Layout L, Layout XL")

; after 6.13.515 the following will work
envSetVal( "license" "VLSL_UseNextLicense"   'string "always")
envSetVal( "license" "VLSXL_UseNextLicense"  'string "always")
envSetVal( "license" "VSEL_UseNextLicense"   'string "always")
envSetVal( "license" "ADEL_UseNextLicense"   'string "always")
envSetVal( "license" "ADEXL_UseNextLicense"  'string "always")

; even more funny things
envSetVal( "license" "VLSLicenseCheckoutOrder" 'string "L,XL,GXL")
envSetVal( "license" "VSELicenseCheckoutOrder" 'string "L,XL")
envSetVal( "license" "ADELicenseCheckoutOrder" 'string "L,XL,GXL")

envSetVal( "layout"  "xSnapSpacing" 'float  0.005)
envSetVal( "layout"  "ySnapSpacing" 'float  0.005)

;envSetVal( "graphic" "drfPath" 'string  simplifyFilename(".tech/display.drf"))
envSetVal( "graphic" "drfPath" 'string  ".tech/display.drf")

; new library should be linked to this tech library
tcNewLibAttachTechForm->attachTechLibList->value= '( "umc65ll" )

loadContext(prependInstallPath("etc/context/transUI.cxt"))
streamInKeys->layerTable="/usr/pack/umc-65-kgf/dz/dfii/610/tech/streamIn.map"
;streamInKeys->textFontTable="/usr/pack/umc-90-kgf/faraday.dz/dfii/5141/pipo/txtfont.tab"

; the following is to keep reference libraries
streamInKeys->refLib=t
streamInKeys->refLibOrder="  u065gioll25mvir_b04 uk65lscllmvbbl_b03 "

streamOutKeys->layerTable="/usr/pack/umc-65-kgf/dz/dfii/610/tech/stream.map"
;streamOutKeys->textFontTable="/usr/pack/umc-90-kgf/faraday.dz/dfii/5141/pipo/txtfont.tab"
streamOutKeys->runDirectory="."
streamOutKeys->errorMessageFile="PIPO.LOG"

