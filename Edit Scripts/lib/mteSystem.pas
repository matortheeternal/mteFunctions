{
  mteSystem
  
  System helpers for mteFunctions.
  See http://github.com/matortheeternal/mteFunctions
  
  TODO:
  - IsDirectoryEmpty
  - CopyDirectory
  - BatchCopyDirectory
  - DeleteDirectory
  - RecursiveFileSearch
  - SanitizeFileName
  - FileDateTimeStr
}

unit mteSystem;

{ Like ExtractFilePath, but will allow the user to specify how many @levels
  they want to traverse back.  Specifying @levels = 0 is equivalent to
  ExtractFilePath.

  Example usage:
  path := 'C:\Program Files (x86)\Test\Test.exe';
  ShowMessage(ExtractPath(path, 0)); // 'C:\Program Files (x86)\Test\'
  ShowMessage(ExtractPath(path, 1)); // 'C:\Program Files (x86)\'
  ShowMessage(ExtractPath(path, 2)); // 'C:\'
}
function ExtractPath(path: string; levels: integer): string;
var
  i, n: integer;
begin
  n := 0;
  for i := Length(path) downto 1 do
    if IsPathDelimiter(path, i) then begin
      if n = levels then
        break
      else
        Inc(n);
    end;
  Result := Copy(path, 1, i);
end;

{ Returns true if @fn is . or .. }
function IsDotFile(fn: string): boolean;
begin
  Result := (fn = '.') or (fn = '..');
end;

end.