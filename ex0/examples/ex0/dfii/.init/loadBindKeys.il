printf("DZ: BEGIN OF BINDKEY LOADING\n")

let( (bindKeyFileList file path saveSkillPath)
    bindKeyFileList = '(
                   "leBindKeys.il" 
                   "schBindKeys.il"
                    )
    path = strcat(
;              ".  ~  "
              prependInstallPath("local ")
              prependInstallPath("samples/local")
             )
    saveSkillPath=getSkillPath()
    setSkillPath(path)

    foreach(file bindKeyFileList
       if(isFile(file ) then
          loadi(file)
         )
    )
    setSkillPath(saveSkillPath)
)

printf("DZ: END OF BINDKEY LOADING\n")

