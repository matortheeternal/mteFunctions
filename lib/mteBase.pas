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
  Result := -10;

  // parse versions with . as delimiter
  sl1 := TStringList.Create;
  sl2 := TStringList.Create;
  try
    sl1.LineBreak := '.';
    sl1.Text := v1;
    sl2.LineBreak := '.';
    sl2.Text := v2;
    if sl1.Count <> sl2.Count then
      raise Exception.Create('Versions have different number of clauses');

    // look through each version clause and perform comparisons
    i := 0;
    while (i < sl1.Count) and (i < sl2.Count) do begin
      c1 := StrToInt(sl1[i]);
      c2 := StrToInt(sl2[i]);
      if (c1 < c2) then begin
        Result := sl1.Count - i;
        break;
      end
      else if (c1 > c2) then begin
        Result := i - sl1.Count;
        break;
      end;
      Inc(i);
    end;
  finally
    // free ram    
    sl1.Free;
    sl2.Free;
  end;
end;

function xEditVersionString(v: Integer): string;
begin
  Result := Format('%d.%d.%d', [
    v shr 24,
    v shr 16 and $FF,
    v shr 8 and $FF
  ]);
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
  xEditVersion := xEditVersionString(wbVersionNumber);
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
  mteVersionCheck:
  Takes a target version of mteFunctions and returns an 
  integer identifying the relationship between that 
  version and the version the user is running. 
  
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
function mteVersionCheck(targetVersion: string): Integer;
var
  vcCurrent, vcReverse: Integer;
begin
  vcCurrent := VersionCompare(targetVersion, mteVersion); // + when mteVersion > targetVersion
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

end.