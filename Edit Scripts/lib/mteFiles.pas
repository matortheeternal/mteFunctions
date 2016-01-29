{
  mteFiles
  
  Component of mteFunctions for handling IwbFiles.
  See http://github.com/matortheeternal/mteFunctions
}

unit mteFiles;

uses 'lib\mteElements';

const
  mteBethesdaSkyrimFiles = 'Skyrim.esm'#44'Update.esm'#44'Dawnguard.esm'#44'HearthFires.esm'#44
  'Dragonborn.esm'#44
  'Skyrim.Hardcoded.keep.this.with.the.exe.and.otherwise.ignore.it.I.really.mean.it.dat';
  
  mteBethesdaOblivionFiles = 'Oblivion.esm'#44'DLCShiveringIsles.esp'#44'Knights.esp'#44
  'DLCMehrunesRazor.esp'#44'DLCOrrery.esp'#44'DLCThievesDen.esp'#44'DLCVileLair.esp'#44
  'DLCSpellTomes.esp'#44'DLCBattlehornCastle.esp'#44'DLCFrostcrag.esp'#44'DLCHorseArmor.esp'#44
  'Oblivion.Hardcoded.keep.this.with.the.exe.and.otherwise.ignore.it.I.really.mean.it.dat';
  
  mteBethesdaFallout3Files = 'Fallout3.esm'#44
  'Fallout3.Hardcoded.keep.this.with.the.exe.and.otherwise.ignore.it.I.really.mean.it.dat'#44;
  
  mteBethesdaFNVFiles = 'FalloutNV.esm'#44'CaravanPack.esm'#44'ClassicPack.esm'#44
  'DeadMoney.esm'#44'GunRunnersArsenal.esm'#44'HonestHearts.esm'#44'LonesomeRoad.esm'#44
  'MercenaryPack.esm'#44'OldWorldBlues.esm'#44'TribalPack.esm'#44
  'FalloutNV.Hardcoded.keep.this.with.the.exe.and.otherwise.ignore.it.I.really.mean.it.dat';
  
  mteHardcodedDatFiles = 
  'Skyrim.Hardcoded.keep.this.with.the.exe.and.otherwise.ignore.it.I.really.mean.it.dat'#44
  'Fallout3.Hardcoded.keep.this.with.the.exe.and.otherwise.ignore.it.I.really.mean.it.dat'#44
  'Oblivion.Hardcoded.keep.this.with.the.exe.and.otherwise.ignore.it.I.really.mean.it.dat'#44
  'FalloutNV.Hardcoded.keep.this.with.the.exe.and.otherwise.ignore.it.I.really.mean.it.dat';
  
{****************************************************}
{ GETTERS AND SETTERS
  Methods for getting and setting file properties.
  - GetFileHeader
  - GetNextObjectID
  - SetNextObjectID
  - GetAuthor
  - SetAuthor
  - GetDescription
  - SetDescription
  - OverrideRecordCount
  - GetOverrideRecords
}
{****************************************************}

{
  GetFileHeader:
  Gets the file header of a file.
  
  Example usage:
  f := FileByName('Skyrim.esm');
  header := GetFileHeader(f);
  if not Assigned(ElementByPath(Header, 'Master Files')) then
    AddMessage(GetFileName(f) + ' has no master files!');
}
function GetFileHeader(f: IInterface): IInterface;
begin
  if not Assigned(f) then
    raise Exception.Create('GetFileHeader: Input file is not assigned');
  if ElementType(f) <> etFile then
    raise Exception.Create('GetFileHeader: Input element is not a file');
    
  Result := ElementByIndex(f, 0);
end;

{
  GetNextObjectID:
  Gets the NextObjectID field from a file.
  
  Example usage:
  f := FileByName('Dawnguard.esm');
  AddMessage(IntToStr(GetNextObjectID(f)));
}
function GetNextObjectID(f: IInterface): Integer;
var
  fileHeader: IInterface;
begin
  fileHeader := GetFileHeader(f);
  Result := GetElementNativeValues(fileHeader, 'HEDR\Next Object ID');
end;

{
  SetNextObjectID:
  Sets the NextObjectID field on a file.
  
  Example usage:
  f := FileByName('Dawnguard.esm');
  SetNextObjectID(f, 2100);
  AddMessage(IntToStr(GetNextObjectID(f))); // '2100'
}
procedure SetNextObjectID(f: IInterface; n: Integer);
var
  fileHeader: IInterface;
begin
  fileHeader := GetFileHeader(f);
  SetElementNativeValues(fileHeader, 'HEDR\Next Object ID', n);
end;

{
  GetAuthor:
  Gets the author field from a file.
  
  Example usage:
  f := FileByName('Dragonborn.esm');
  AddMessage(GetAuthor(f)); // rsalvatore
}
function GetAuthor(f: IInterface): string;
var
  fileHeader: IInterface;
begin
  fileHeader := GetFileHeader(f);
  Result := GetElementEditValues(fileHeader, 'CNAM - Author');
end;

{
  SetAuthor:
  Sets the author field on a file.
  
  Example usage:
  f := FileByName('Dragonborn.esm');
  SetAuthor(f, 'George');
}
procedure SetAuthor(f: IInterface; author: string);
var
  fileHeader: IInterface;
begin
  fileHeader := GetFileHeader(f);
  SetElementEditValues(fileHeader, 'CNAM - Author', author);
end;

{
  GetDescription:
  Gets the description field from a file.
  
  Example usage:
  f := FileByName('Skyrim.exe');
  AddMessage(GetDescription(f)); 
    // 'Hardcoded Forms for Skyrim not found in Skyrim.ESM.'
}
function GetDescription(f: IInterface): string;
var
  fileHeader: IInterface;
begin
  fileHeader := GetFileHeader(f);
  Result := GetElementEditValues(fileHeader, 'SNAM - Description');
end;

{
  SetDescription:
  Sets the description field on a file.
  
  Example usage:
  f := FileByName('TestFileMTE.esp');
  SetDescription(f, 'This is a test.');
  AddMessage(GetDescription(f)); 
    // 'This is a test.'
}
function SetDescription(f: IInterface; desc: string): string;
var
  fileHeader, element: IInterface;
begin
  fileHeader := GetFileHeader(f);
  element := ElementByPath(fileHeader, 'SNAM - Description');
  if not Assigned(element) then
    Add(fileHeader, 'SNAM', true);
  SetElementEditValues(fileHeader, 'SNAM - Description', desc);
end;

{
  OverrideRecordCount:
  Gets the number of override records in the input
  file.
  
  Example usage:
  f := FileByName('Update.esm');
  AddMessage(IntToStr(OverrideRecordCount(f))); // '1105'
}
function OverrideRecordCount(f: IInterface): Integer;
var
  i: Integer;
  rec: IInterface;
begin
  if not Assigned(f) then
    raise Exception.Create('OverrideRecordCount: Input file not assigned');

  Result := 0;
  for i := 0 to Pred(RecordCount(f)) do begin
    rec := RecordByIndex(f, i);
    if not IsMaster(rec) then
      Inc(Result);
  end;
end;

{
  GetOverrideRecords:
  Gets all of the override records from a specified
  file.
  
  Example usage:
  f := FileByName('Update.esm');
  lst := TList.Create;
  GetOverrideRecords(f, lst);
  AddMessage(Format('%s has %d override records.', [GetFileName(f), lst.Count]));
}
procedure GetOverrideRecords(f: IInterface; var lst: TList);
var
  i: Integer;
  rec: IInterface;
begin
  if not Assigned(f) then
    raise Exception.Create('GetOverrideRecords: Input file not assigned');
  if not Assigned(lst) then
    raise Exception.Create('GetOverrideRecords: Input TList not assigned');

  for i := 0 to Pred(RecordCount(f)) do begin
    rec := RecordByIndex(f, i);
    if not IsMaster(rec) then
      lst.Add(rec);
  end;
end;


{****************************************************}
{ MASTERS METHODS
  Methods for getting or setting masters on files.
  - AddFilesToList
  - AddMastersToList
  - AddMaster
  - AddMastersToFile
  - RemoveMaster
  - AddLoadedFilesAsMasters
}
{****************************************************}

{
  AddFileToList:
  Adds the filename of an IwbFile to a stringlist, and its
  load order as an object paired with the filename.
  
  Example usage:
  slMasters := TStringList.Create;
  f := FileByName('Update.esm');
  AddPluginToList(f, slMasters);
  AddMessage(Format('[%s] %s', 
    [IntToHex(slMasters.Objects[0], 2), slMasters[0]])); // [01] Update.esm
}
procedure AddFileToList(f: IInterface; var sl: TStringList);
var
  filename: string;
  i, iNewLoadOrder, iLoadOrder: Integer;
begin
  // raise exception if input file is not assigned
  if not Assigned(f) then
    raise Exception.Create('AddFileToList: Input file is not assigned');
  // raise exception if input stringlist is not assigned
  if not Assigned(sl) then
    raise Exception.Create('AddFileToList: Input TStringList is not assigned');
    
  // don't add file to list if it is already present
  filename := GetFileName(f);
  if sl.IndexOf(filename) > -1 then 
    exit;
  
  // loop through list to determine correct place to
  // insert the file into it
  iNewLoadOrder := GetLoadOrder(f);
  for i := 0 to Pred(sl.Count) do begin
    iLoadOrder := Integer(sl.Objects[i]);
    // insert the file at the current position if we 
    // reach the a file with a lower load order than it
    if iLoadOrder > iNewLoadOrder then begin
      sl.InsertObject(i, filename, TObject(iNewLoadOrder));
      exit;
    end;
  end;
  
  // if the list is empty, or if all files in the list
  // are at lower load orders than the file we're adding,
  // we add the file to the end of the list
  sl.AddObject(filename, TObject(iNewLoadOrder));
end;

{
  AddMastersToList:
  Adds the masters from a specific file to a specified 
  stringlist.
  
  Example usage:
  slMasters := TStringList.Create;
  AddMastersToList(FileByName('Dragonborn.esm'), slMasters);
}
procedure AddMastersToList(f: IInterface; var sl: TStringList; sorted: boolean);
var
  fileHeader, masters, master, masterFile: IInterface;
  i: integer;
  filename: string;
begin
  // raise exception if input stringlist is not assigned
  if not Assigned(sl) then
    raise Exception.Create('AddMastersToList: Input TStringList not assigned');

  // add file's masters
  fileHeader := GetFileHeader(f);
  masters := ElementByPath(fileHeader, 'Master Files');
  if Assigned(masters) then
    for i := 0 to ElementCount(masters) - 1 do begin
      master := ElementByIndex(masters, i);
      filename := GetElementEditValues(master, 'MAST');
      masterFile := FileByName(filename);
      if Assigned(masterFile) and sorted then 
        AddFileToList(masterFile, sl)
      else if sl.IndexOf(filename) = -1 then
        sl.AddObject(filename, TObject(GetLoadOrder(masterFile)));
    end;
end;

{
  AddMaster:
  Adds a master to a file manually.  If the master is already
  present, it will not be duplicated.
  
  Example usage:
  f := FileByName('TestFile.esp');
  AddMaster(f, 'Skyrim.esm');
}
procedure AddMaster(f, masterFile: IInterface);
var
  fileHeader, masters, master, temp: IInterface;
  masterFilename: string;
  i, iNewLoadOrder, iLoadOrder: Integer;
  sl: TStringList;
begin
  // raise exception if input masterFile is not assigned
  if not Assigned(masterFile) then
    raise Exception.Create('AddMaster: Input master file not assigned');
    
  fileHeader := GetFileHeader(f);
  masters := ElementByPath(fileHeader, 'Master Files');
  masterFilename := GetFileName(masterFile);
  
  // create masters element if it doesn't exist
  if not Assigned(masters) then begin
    Add(fileHeader, 'Master Files', true);
    masters := ElementByPath(fileHeader, 'Master Files');
    master := ElementByIndex(masters, 0);
    // set master filename
    SetElementEditValues(master, 'MAST', masterFilename);
  end
  // else add a new master to the masters list
  else begin
    sl := TStringList.Create;
    try
      AddMastersToList(f, sl, true);
      iNewLoadOrder := GetLoadOrder(masterFile);
      for i := 0 to Pred(sl.Count) do begin
        iLoadOrder := Integer(sl.Objects[i]);
        if iLoadOrder > iNewLoadOrder then begin
          master := ElementAssign(masters, HighInteger, nil, false);
          MoveElementToIndex(master, i);
          exit;
        end;
      end;
      master := ElementAssign(masters, HighInteger, nil, false);
    finally
      // set master filename
      SetElementEditValues(master, 'MAST', masterFilename);
      sl.Free;
    end;
  end;
end;


// **** TODO: REVIEW THIS FUNCTION ****
{
  AddMastersToFile:
  Adds masters from a stringlist to the specified file.
  
  Example usage:
  slMasters := TStringList.Create;
  slMasters.Add('Skyrim.esm');
  slMasters.Add('Update.esm');
  UserFile := FileSelect('Select the file you wish to use below: ');
  AddMastersToFile(UserFile, slMasters);
}
procedure AddMastersToFile(f: IInterface; var sl: TStringList);
var
  fileHeader, masters, master: IInterface;
  i: integer;
  filename: string;
  slCurrentMasters: TStringList;
begin
  // raise exception if input file is not assigned
  if not Assigned(f) then
    raise Exception.Create('AddMastersToFile: Input file not assigned');
  // raise exception if input stringlist is not assigned
  if not Assigned(sl) then
    raise Exception.Create('AddMastersToFile: Input TStringList not assigned');

  // create stringlist
  slCurrentMasters := TStringList.Create;
  
  try
    // AddMasterIfMissing will attempt to add the masters to the file.
    try
      for i := 0 to Pred(sl.Count) do begin
        if (Lowercase(sl[i]) <> Lowercase(GetFileName(f))) then
          AddMasterIfMissing(f, sl[i]);
      end;
    except
      // nothing we can really do...
    end;
    
    // AddMasterIfMissing won't add the masters if they have been removed
    // in the current TES5Edit session, so a manual re-adding process is
    // used.  This process can't fully replace AddMasterIfMissing without
    // causing problems.  It only works for masters that have been removed
    // in the current TES5Edit session.
    fileHeader := GetFileHeader(f);
    masters := ElementByPath(fileHeader, 'Master Files');
    // if masters is assigned, add the current masters to slCurrentMasters
    if Assigned(masters) then
      for i := 0 to Pred(ElementCount(masters)) do begin
        master := ElementByIndex(masters, i);
        filename := GetElementEditValues(master, 'MAST');
        slCurrentMasters.Add(filename);
      end;
    
    // add masters to the file
    for i := 0 to Pred(sl.Count) do begin
      // TODO: Do this with native code instead of calling AddMaster
      // because AddMaster rebuilds a stringlist of the file's masters 
      // each time it is called.
      if (Lowercase(sl[i]) <> Lowercase(GetFileName(f))) 
      and (slCurrentMasters.IndexOf(sl[i]) = -1) then
        AddMaster(f, FileByName(sl[i]));
    end;
  finally
    slCurrentMasters.Free;
  end;
end;

{
  RemoveMaster:
  Removes a master matching the specified string from 
  the specified file.
  
  Example usage:
  f := FileByIndex(i);
  RemoveMaster(f, 'Update.esm');
}
procedure RemoveMaster(f: IInterface; masterFilename: String);
var
  fileHeader, master, masters: IInterface;
  i: integer;
  sMaster: string;
begin
  fileHeader := GetFileHeader(f);
  masters := ElementByPath(fileHeader, 'Master Files');
  // loop through the masteres in reverse
  for i := Pred(ElementCount(masters)) downto 0 do begin
    master := ElementByIndex(masters, i);
    sMaster := GetElementEditValues(master, 'MAST');
    if sMaster = masterFilename then begin
      Remove(master);
      break;
    end;
  end;
end;

{
  AddLoadedFilesAsMasters:
  Adds all loaded files at load orders lower than
  the specified file as masters for the specified
  file.
}
procedure AddLoadedFilesAsMasters(targetFile: IInterface);
var
  i: Integer;
  f: IInterface;
  slMasters: TStringList;
  filename, targetFilename: string;
begin
  // raise exception if input file is not assigned
  if not Assigned(targetFile) then
    raise Exception.Create('AddLoadedFilesAsMasters: Input file not assigned');

  // create stringlist
  slMasters := TStringList.Create;
  try
    targetFilename := GetFileName(targetFile);
    
    // loop through load order
    for i := 0 to FileCount - 2 do begin
      f := FileByLoadOrder(i);
      // break at target file
      filename := GetFileName(f);
      if filename = targetFilename then
        break;
      slMasters.Add(filename);
    end;
    
    // add masters to target file
    AddMastersToFile(targetFile, slMasters);
  finally
    slMasters.Free;
  end;
end;


{****************************************************}
{ FILE GETTERS
  Methods that can be used to get a file from a load
  order based on a property.
  - FileByName
  - FileByAuthor
  - FilesThatRequire
}
{****************************************************}

{
  FileByName:
  Gets a file from a filename.
  
  Example usage:
  f := FileByName('Skyrim.esm');
}
function FileByName(s: string): IInterface;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FileCount - 1 do begin
    if GetFileName(FileByIndex(i)) = s then begin
      Result := FileByIndex(i);
      break;
    end;
  end;
end;

{
  FileByAuthor:
  Gets a file by an author.
  
  Example usage:
  f := FileByAuthor('rsalvatore'); 
}
function FileByAuthor(s: string): IInterface;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FileCount - 1 do begin
    if GetAuthor(FileByIndex(i)) = s then begin
      Result := FileByIndex(i);
      break;
    end;
  end;
end;

{
  FilesThatRequire:
  Gets a list of all files that require the input
  file as a master.
  
  Example usage:
  f := FileByName('Skyrim.esm');
  lst := TList.Create;
  FilesThatRequire(f, lst);
  AddMessage('Files that require Skyrim.esm');
  for i := 0 to Pred(lst.Count) do
    AddMessage(GetFileName(ObjectToElement(lst[i])));
}
procedure FilesThatRequire(masterFile: IInterface; var lst: TList);
var
  i: Integer;
  f: IInterface;
  masterFilename: string;
begin
  // raise exception if input file is not assigned
  if not Assigned(masterFile) then
    raise Exception.Create('FilesThatRequire: Input file not assigned');
  // raise exception if input TList is not assigned
  if not Assigned(lst) then
    raise Exception.Create('FilesThatRequire: Input TList not assigned');

  // get master file's filename
  masterFilename := GetFileName(masterFile);
  // loop through files at load order lower than 
  // the specified file
  for i := GetLoadOrder(masterFile) to FileCount - 2 do begin
    f := FileByLoadOrder(i);
    // if file has the specified file as a master,
    // add it to the list
    if HasMaster(f, masterFilename) then
      lst.Add(f);
  end;
end;

end.