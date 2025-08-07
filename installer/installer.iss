#preproc ispp

#define ToolsDirectory "{app}\src\tools\"

[Setup]
AppName="fzf Windows Tools"
AppPublisher="ms-afk"
AppVersion={#ApplicationVersion}
AppId=fzf-windows-tools
LicenseFile="..\LICENSE"
DefaultDirName="{autopf}\fzf-windows-tools"
ChangesEnvironment=yes
DefaultGroupName="fzf Windows Tools"

[Types]
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: "main"; Description: "fzf Windows Tools"; Flags: fixed checkablealone; Types: custom
Name: "main\dependencies"; Description: "Install dependencies (required)"; Flags: disablenouninstallwarning; Types: custom

[Tasks]
Name: desktopicon; Description: "Create a &desktop icon"; Components: main
Name: startmenu; Description: "Create startmenu icons"; Components: main

[Files]
Source: "..\src\*"; DestDir: "{app}\src"; Flags: recursesubdirs; Components: main
Source: "..\README.md"; DestDir: "{app}"; Components: main
Source: "..\LICENSE"; DestDir: "{app}"; Components: main
Source: "scripts\winget-dependencies.bat"; DestDir: "{app}\scripts"; Components: main

[Icons]
; desktop icons
Name: "{autodesktop}\fzfd"; Filename: "{#ToolsDirectory}\fzfd.bat"; WorkingDir: "{%USERPROFILE}"; Components: main; Tasks: desktopicon
; start menu icons
Name: "{group}\fzfd"; Filename: "{#ToolsDirectory}\fzfd.bat"; WorkingDir: "{%USERPROFILE}"; Components: main; Tasks: startmenu
Name: "{group}\Uninstall fzf Windows Tools"; Filename: "{uninstallexe}"; Components: main; Tasks: startmenu

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"

[Run]
Filename: "{app}\README.md"; Description: "View the README file"; Flags: postinstall shellexec skipifsilent; Components: main
Filename: "{app}\scripts\winget-dependencies.bat"; StatusMsg: "Installing dependencies..."; Flags: shellexec waituntilterminated; Components: main\dependencies

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: "string"; ValueName: "Path"; ValueData: "{olddata};{#ToolsDirectory}"; Check: IsDirInPathEnv(ExpandConstant('{#ToolsDirectory}'))

[Code]

{ Return true if the directory is present in the machine's Path environment variable }
function IsDirInPathEnv(Dir: String): Boolean;
var
  // Path contains the system PATH's value
  Path: string;
begin
  // Read PATH value into Path variable
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', Path) then
  begin
    // If read operation fails, raise exception
    RaiseException('Failed to read path!');
  end;
  // True if Dir is in Path
  Result := Pos(';' + Dir + ';', ';' + Path + ';') = 0;
end;

{ Remove directory from the machine's Path environment variable }
function RemoveDirFromPath(Dir: String): Boolean;
var
  Path: String;
  PathArray, FilteredPathArray: tArrayOfString;
  PathArrayIndex, FilteredPathArrayLength: LongInt;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path',
     Path) then
  begin
    Result := False;
    exit;
  end;
  PathArray := StringSplit(Path, [';'], stExcludeEmpty);
  FilteredPathArrayLength := 0;
  for PathArrayIndex := 0 to GetArrayLength(PathArray) - 1 do
  begin
	if PathArray[PathArrayIndex] <> Dir then
    begin
      FilteredPathArrayLength := FilteredPathArrayLength + 1;
      SetArrayLength(FilteredPathArray, FilteredPathArrayLength);
      FilteredPathArray[FilteredPathArrayLength - 1] := PathArray[PathArrayIndex];
    end;
  end;
  Path := StringJoin(';', FilteredPathArray);
  Result := RegWriteStringValue(HKEY_LOCAL_MACHINE,
   'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
   'Path',
   Path);
end;

{ EVENT FUNCTIONS }

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
  begin
    if not RemoveDirFromPath(ExpandConstant('{#ToolsDirectory}')) then
    begin
      MsgBox('Unable to clean Path environment variable.', mbError, MB_OK);
    end;
  end;
end;
