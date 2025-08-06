#preproc ispp

#define SourceDirectory "{app}\src\"

[Setup]
AppName="fzf Windows Tools"
AppPublisher="ms-afk"
AppVersion={#ApplicationVersion}
AppId=fzf-windows-tools
LicenseFile="..\LICENSE"
DefaultDirName="{autopf}\fzf-windows-tools"

[Files]
Source: "..\src\fzfd.bat"; DestDir: "{app}\src"
Source: "..\README.md"; DestDir: "{app}"
Source: "..\LICENSE"; DestDir: "{app}"
Source: "winget-dependencies.bat"; DestDir: "{app}"

[Icons]
Name: "{autodesktop}\fzfd"; Filename: "{app}\src\fzfd.bat"; WorkingDir: "{%USERPROFILE}"

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"

[Run]
Filename: "{app}\README.md"; Description: "View the README file"; Flags: postinstall shellexec skipifsilent
Filename: "{app}\winget-dependencies.bat"; Description: "Automatically install dependencies"; Flags: postinstall nowait skipifsilent unchecked shellexec

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: "string"; ValueName: "Path"; ValueData: "{olddata};{#SourceDirectory}"; Check: DirInPathEnv(ExpandConstant('{#SourceDirectory}'))

[Code]
function DirInPathEnv(Dir: String): Boolean;
var
  // Path contains system PATH's value
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
