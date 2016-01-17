{
  mteBase
  
  Base for mteFunctions.
  See http://github.com/matortheeternal/mteFunctions
}

unit mteBase;

const
  mteVersion = '0.0.0.1';
  vcOlderBroken = 1;
  vcOlder = 2;
  vcEqual = 3;
  vcNewer = 4;
  vcNewerBroken = 5;
  
{
  VersionCompare:
  Takes two version strings and returns an integer
  corresponding to how they are related to each other.
  
  Returns:
    +x: If the second version is newer than the first.
      (so v2 > v1).  x corresponds to the clause that
      differed, numbered from right to left.
    0: If the versions are identical.
    -x: If the second version is older than the first.
      (so v2 < v1)  x corresponds to the clause that
      differed, numbered from right to left.
      
  Example usage:
  AddMessage(IntToStr(VersionCompare('1.2.3.4', '2.2.3.4'))); // 4
  AddMessage(IntToStr(VersionCompare('1.2.3.4', '1.3.3.4'))); // 3
  AddMessage(IntToStr(VersionCompare('1.2.3.4', '1.2.4.4'))); // 2
  AddMessage(IntToStr(VersionCompare('1.2.3.4', '1.2.3.5'))); // 1
  AddMessage(IntToStr(VersionCompare('1.2.3.4', '1.2.3.4'))); // 0
  AddMessage(IntToStr(VersionCompare('1.2.3.4', '1.2.3.3'))); // -1
  AddMessage(IntToStr(VersionCompare('1.2.3.4', '1.2.2.4'))); // -2
  AddMessage(IntToStr(VersionCompare('1.2.3.4', '1.1.3.4'))); // -3
  AddMessage(IntToStr(VersionCompare('1.2.3.4', '0.2.3.4'))); // -4
}
function VersionCompare(v1, v2: string): Integer;
var
  sl1, sl2: TStringList;
  i, c1, c2: integer;
begin
  Result := -99;

  // handle empty string case
  if (v1 = '') or (v2 = '') then
    raise Exception.Create('VersionCompare: Version is empty string');
  
  // parse versions with . as delimiter
  sl1 := TStringList.Create;
  sl2 := TStringList.Create;
  try
    sl1.Delimiter := '.';
    sl1.StrictDelimiter := true;
    sl1.DelimitedText := v1;
    sl2.Delimiter := '.';
    sl2.StrictDelimiter := true;
    sl2.DelimitedText := v2;
    if sl1.Count <> sl2.Count then
      raise Exception.Create('VersionCompare: Versions have a different '+
        'number of version clauses');
    
    // look through each version clause and perform comparisons
    i := 0;
    while (i < sl1.Count) do begin
      c1 := StrToInt(sl1[i]);
      c2 := StrToInt(sl2[i]);
      if (c1 < c2) then begin
        Result := sl1.Count - i;
        exit;
      end
      else if (c1 > c2) then begin
        Result := i - sl1.Count;
        exit;
      end;
      Inc(i);  
    end;
    
    // if equal, set result to 0
    Result := 0;
  finally
    // free ram    
    sl1.Free;
    sl2.Free;
  end;
end;

{
  VersionToString:
  Takes in an Integer version through parameter v, and 
  produces a string representing it as three-clause
  version (Major, minor, release).
  
  Example usage:
  AddMessage(VersionToString($FF804020)); // 255.128.64
}
function VersionToString(v: Integer): string;
begin
  Result := Format('%d.%d.%d', [
    Integer(v shr 24),
    Integer(v shr 16 and $FF),
    Integer(v shr 8 and $FF)
  ]);
end;

{
  ShortenVersion:
  Shortens a version string @vs to a number of clauses 
  @numClauses.
  
  Example usage:
  vs := '1.2.3.4';
  AddMessage(ShortenVersion(vs, 3)); // '1.2.3'
  AddMessage(ShortenVersion(vs, 2)); // '1.2'
  AddMessage(ShortenVersion(vs, 1)); // '1'
}
function ShortenVersion(vs: string; numClauses: Integer): string;
var
  sChar: string;
  i, numDots: Integer;
begin
  Result := '';
  numDots := 0;
  for i := 1 to Length(vs) do begin
    sChar := Copy(vs, i, 1);
    if sChar = '.' then
      Inc(numDots);
    if numDots = numClauses then
      break;
    Result := Result + sChar;
  end;
end;

{
  xEditVersionCheck:
  Takes a minimum version string and a maximum version
  string, and returns true if the user is running a
  version of xEdit between the two versions.  Input
  255.0.0 for maxVersion to effectively have no
  maxVersion.
  
  Example usage:
  if xEditVersionCheck('3.0.32', '3.1.31') then
    AddMessage('Version supported!');
}
function xEditVersionCheck(minVersion: string; maxVersion: string): boolean;
var
  xEditVersion: string;
begin
  xEditVersion := VersionToString(wbVersionNumber);
  Result := (VersionCompare(minVersion, xEditVersion) >= 0) 
    and (VersionCompare(xEditVersion, maxVersion) >= 0);
end;

{
  xEditGameCheck:
  Takes a comma separated list of game acronyms and
  returns true if the user is running xEdit in one
  of the listed game modes.
  
  Game acronyms: 
    TES5: Skyrim
    TES4: Oblivion
    FO3: Fallout 3
    FNV: Fallout New Vegas
    
  Example usage:
  if not xEditGameCheck('TES5,TES4') then begin
    AddMessage('You can only run this script in TES5Edit or TES4Edit!');
    exit;
  end;
}
function xEditGameCheck(supportedGames: string): boolean;
var
  sl: TStringList;
  i: Integer;
begin
  Result := false;
  sl := TStringList.Create;
  try
    sl.CommaText := supportedGames;
    for i := 0 to Pred(sl.Count) do
      if SameText(sl[i], wbAppName) then begin
        Result := true;
        break;
      end;
  finally
    sl.Free;
  end;
end;

{
  VersionCheck:
  Takes a target version and a current verison and 
  returns an  integer identifying the relationship 
  between them.
  
  Returns:
  vcOlderBroken = 1: When the user is running an older
    version that is a full minorVersion or majorVersion 
    different from the target version.
  vcOlder = 2: When the user is running an older version
    than the target version.
  vcEqual = 3: When the user is running the target
    version.
  vcNewer = 4: When the user is running a newer version
    than the target version.
  vcNewerBroken = 5: When the user is running a newer
    version that is a full minorVersion or majorVersion
    different from the target version.
}
function VersionCheck(targetVersion, currentVersion: string): Integer;
var
  vcCurrent, vcReverse: Integer;
begin
  vcCurrent := VersionCompare(targetVersion, currentVersion); // + when mteVersion > targetVersion
  if vcCurrent = 0 then
    // we're on the target version
    Result := vcEqual
  else if (vcCurrent > 0) then begin
    // we're on a newer version
    if vcCurrent > 2 then
      // we're on a new version that isn't reverse-compatible with
      // the target version
      Result := vcNewerBroken
    else
      Result := vcNewer;
  end
  else begin
    // we're on an older version
    if vcCurrent < -2 then
      // we're on an old version that isn't reverse-compatible with
      // the target version
      Result := vcOlderBroken
    else
      Result := vcOlder;
  end;
end;

{
  mteVersionCheck
  Wraps VersionCheck with mteVersion as the
  currentVersion argument.
}
function mteVersionCheck(targetVersion: string): Integer;
begin
  Result := VersionCheck(targetVersion, mteVersion);
end;

end.