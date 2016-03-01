{
  mteElements
  
  Component of mteFunctions for handling IwbElements.
  See http://github.com/matortheeternal/mteFunctions
}

unit mteElements;

const
  // VARIANT TYPES
  varInteger = 3;
  varDouble = 5;
  varShortInt = 16;
  varString =  256; { Pascal string }
  varUString = 258; { Unicode string }
  { SEE http://stackoverflow.com/questions/24731098/ for more }


{****************************************************}
{ ELEMENT COMPARISON
  Metohds for comparing or evaluating elements.
  - IsValue
  - ElementMatches
  - StructMatches
}
{****************************************************}

function IsValue(element: IInterface): Boolean;
var
  dt: Integer;
begin
  dt := DefType(element);
  Result := (dt = dtString) 
    or (dt = dtLString) 
    or (dt = dtLenString) 
    or (dt = dtByteArray) 
    or (dt = dtInteger) 
    or (dt = dtFloat);
end;

function ElementMatches(element: IInterface; value: Variant): Boolean;
var
  vt: Integer;
  rec: IInterface;
begin
  Result := False;
  
  // raise exception if input element is not a value element
  if not IsValue(element) then
    raise Exception.Create('ElementMatches: Input element is not a value element');
  
  vt := VarType(value);
  
  case vt of 
    varInteger, varDouble, varShortInt:
      Result := (value = GetNativeValue(element));
    varString, varUString: begin
      Result := (value = GetEditValue(element));
  
      // Check value matches linked EDID - EditorID or NAME - Base
      if not Result then try
        rec := LinksTo(element);
        // exit if element doesn't link to anything
        if not Assigned(rec) then 
          exit;
        // else check EDID and NAME for match
        if ElementExists(rec, 'EDID') then
          Result := GetElementEditValues(rec, 'EDID') = value
        else if ElementExists(rec, 'NAME') then
          Result := GetElementEditValues(rec, 'NAME') = value;
      except
        on x: Exception do begin 
          // nothing
        end;
      end;
    end;
  end;
end;

function StructMatches(container, struct: IInterface; path: String; value: Variant): Boolean;
var
  element: IInterface;
  vt: Integer;
  key: String;
begin
  Result := false;
  
  vt := VarType(value);
  // if path is empty, compare struct directly to value
  if (path = '') then begin
    // if value isn't a string, raise exception because comparison will fail
    if (vt <> vtString) and (vt <> vtUString) then
      raise Exception.Create(Format('StructMatches: Unable to compare value at path '+
        '"%s" against variant of type %d', [Path(struct), vt]);
    
    // get key for struct - use SortKey if container is sorted else use GetAllValues
    if IsSorted(container) then
      key := SortKey(struct)
    else
      key := GetAllValues(struct);
      
    // Result is whether or not the key matches the value
    Result := key = value;
  end
  // else get element at path
  else begin
    element := ElementByPath(struct, path);
    // if the element holds a value, compare using ElementMatches
    if IsValue(element) then 
      Result := ElementMatches(element, value)
    // else compare structs by calling StructMatches again
    else
      Result := StructMatches(GetContainer(element), element, '', value);
  end;
end;
  
  
{****************************************************}
{ TYPE HELPERS
  Methods for converting xEdit types.
  - etToString
  - dtToString
  - ctToString
  - caToString
}
{****************************************************}

{
  etToString:
  Converst a TwbElementType to a string.
  
  Example usage:
  element := ElementByPath(e, 'KWDA');
  AddMessage(etToString(ElementType(element)));
}
function etToString(et: TwbElementType): string;
begin
  case Ord(et) of
    Ord(etFile): Result := 'etFile';
    Ord(etMainRecord): Result := 'etMainRecord';
    Ord(etGroupRecord): Result := 'etGroupRecord';
    Ord(etSubRecord): Result := 'etSubRecord';
    Ord(etSubRecordStruct): Result := 'etSubRecordStruct';
    Ord(etSubRecordArray): Result := 'etSubRecordArray';
    Ord(etSubRecordUnion): Result := 'etSubRecordUnion';
    Ord(etArray): Result := 'etArray';
    Ord(etStruct): Result := 'etStruct';
    Ord(etValue): Result := 'etValue';
    Ord(etFlag): Result := 'etFlag';
    Ord(etStringListTerminator): Result := 'etStringListTerminator';
    Ord(etUnion): Result := 'etUnion';
  end;
end;

{
  dtToString:
  Converts a TwbDefType to a string.
  
  Example usage:
  element := ElementByPath(e, 'KWDA');
  AddMessage(dtToString(DefType(element)));
}
function dtToString(dt: TwbDefType): string;
begin
  case Ord(dt) of
    Ord(dtRecord): Result := 'dtRecord';
    Ord(dtSubRecord): Result := 'dtSubRecord';
    Ord(dtSubRecordArray): Result := 'dtSubRecordArray';
    Ord(dtSubRecordStruct): Result := 'dtSubRecordStruct';
    Ord(dtSubRecordUnion): Result := 'dtSubRecordUnion';
    Ord(dtString): Result := 'dtString';
    Ord(dtLString): Result := 'dtLString';
    Ord(dtLenString): Result := 'dtLenString';
    Ord(dtByteArray): Result := 'dtByteArray';
    Ord(dtInteger): Result := 'dtInteger';
    Ord(dtIntegerFormater): Result := 'dtIntegerFormatter';
    Ord(dtFloat): Result := 'dtFloat';
    Ord(dtArray): Result := 'dtArray';
    Ord(dtStruct): Result := 'dtStruct';
    Ord(dtUnion): Result := 'dtUnion';
    Ord(dtEmpty): Result := 'dtEmpty';
  end;
end;

{
  ctToString:
  Converts a TConflictThis to a string.
  
  Example usage:
  AddMessage(ctToString(ctNotDefined));
}
function ctToString(ct: TConflictThis): string;
begin
  case Ord(ct) of 
    Ord(ctUnknown): Result := 'ctUnknown';
    Ord(ctIgnored): Result := 'ctIgnored';
    Ord(ctNotDefined): Result := 'ctNotDefined';
    Ord(ctIdenticalToMaster): Result := 'ctIdenticalToMaster';
    Ord(ctOnlyOne): Result := 'ctOnlyOne';
    Ord(ctHiddenByModGroup): Result := 'ctHiddenByModGroup';
    Ord(ctMaster): Result := 'ctMaster';
    Ord(ctConflictBenign): Result := 'ctConflictBenign';
    Ord(ctOverride): Result := 'ctOverride';
    Ord(ctIdenticalToMasterWinsConflict): Result := 'ctIdenticalToMasterWinsConflict';
    Ord(ctConflictWins): Result := 'ctConflictWins';
    Ord(ctConflictLoses): Result := 'ctConflictLoses';
  end;
end;

{
  caToString:
  Converts a TConflictAll to a string.
  
  Example usage:
  e := RecordByIndex(FileByIndex(0), 1);
  AddMessage(caToString(ConflictAllForMainRecord(e)));
}
function caToString(ca: TConflictAll): string;
begin
  case Ord(ca) of 
    Ord(caUnknown): Result := 'caUnknown';
    Ord(caOnlyOne): Result := 'caOnlyOne';
    Ord(caConflict): Result := 'caConflict';
    Ord(caNoConflict): Result := 'caNoConflict';
    Ord(caConflictBenign): Result := 'caConflictBenign';
    Ord(caOverride): Result := 'caOverride';
    Ord(caConflictCritical): Result := 'caConflictCritical';
  end;
end;


{****************************************************}
{ ELEMENT HELPERS
  Helper methods for dealing with arbitrary elements.
  - ConflictThis
  - ConflictAll
  - ElementPath
  - IndexedPath
  - MoveElementToIndex
}
{****************************************************}

{
  ConflictThis:
  Gets the ConflictThis of a node or of a main record.
}
function ConflictThis(e: IInterface): TConflictThis;
var
  et: TwbElementType;
begin
  // raise exception if input element is not assigned
  if not Assigned(e) then
    raise Exception.Create('ConflictThis: Input element is not assigned');
  
  et := ElementType(e);
  case Ord(et) of
    Ord(etFile): raise Exception.Create('ConflictThis: etFile does not have a ConflictThis');
    Ord(etMainRecord): Result := ConflictThisForMainRecord(e);
    Ord(etGroupRecord): raise Exception.Create('ConflictThis: etGroupRecord does not have a ConflictThis');
    else Result := ConflictThisForNode(e);
  end;
end;

{
  ConflictAll:
  Gets the ConflictAll of a node or of a main record.
}
function ConflictAll(e: IInterface): TConflictAll;
var
  et: TwbElementType;
begin
  // raise exception if input element is not assigned
  if not Assigned(e) then
    raise Exception.Create('ConflictAll: Input element is not assigned');
    
  et := ElementType(e);
  case Ord(et) of
    Ord(etFile): raise Exception.Create('ConflictAll: etFile does not have a ConflictAll');
    Ord(etMainRecord): Result := ConflictAllForMainRecord(e);
    Ord(etGroupRecord): raise Exception.Create('ConflictAll: etGroupRecord does not have a ConflictAll');
    else Result := ConflictAllForNode(e);
  end;
end;

{
  ElementPath:
  Gets the path of an element.
  
  Example usage:
  element := ElementByPath(e, 'Model\MODL');
  AddMessage(ElementPath(element)); //Model\MODL - Model Filename
}
function ElementPath(e: IInterface): string;
var
  c: IInterface;
  et: TwbElementType;
begin
  // raise exception if user input an etFile, etMainRecord, or etGroupRecord
  et := ElementType(e);
  case Ord(et) of
    Ord(etFile): raise Exception.Create('ElementPath: Cannot call ElementPath on a file');
    Ord(etMainRecord): raise Exception.Create('ElementPath: Cannot call ElementPath on a main record');
    Ord(etGroupRecord): raise Exception.Create('ElementPath: Cannot call ElementPath on a group record');
  end;
  
  // calculate element path
  c := GetContainer(e);
  while (ElementType(e) <> etMainRecord) do begin
    // append to result
    if Result <> '' then 
      Result := Name(e) + '\' + Result
    else 
      Result := Name(e);
    
    // recurse upwards
    e := c;
    c := GetContainer(e);
  end;
end;

{
  IndexedPath:
  Gets the indexed path of an element.
  
  Example usage:
  element := ElementByIP(e, 'Conditions\[3]\CTDA - \Comparison Value');
  AddMessage(IndexedPath(element)); //Conditions\[3]\CTDA - \Comparison Value
}
function IndexedPath(e: IInterface): string;
var
  c: IInterface;
  a: string;
  et: TwbElementType;
begin
  // raise exception if user input an etFile, etMainRecord, or etGroupRecord
  et := ElementType(e);
  case Ord(et) of
    Ord(etFile): raise Exception.Create('IndexedPath: Cannot call IndexedPath on a file');
    Ord(etMainRecord): raise Exception.Create('IndexedPath: Cannot call IndexedPath on a main record');
    Ord(etGroupRecord): raise Exception.Create('IndexedPath: Cannot call IndexedPath on a group record');
  end;
  
  // calculate indexed path
  c := GetContainer(e);
  while (ElementType(e) <> etMainRecord) do begin
    // do index if we're in an array, else do name
    if ElementType(c) = etSubRecordArray then
      a := '['+IntToStr(IndexOf(c, e))+']'
    else
      a := Name(e);
      
    // append to result
    if Result <> '' then 
      Result := a + '\' + Result
    else 
      Result := a;
      
    // recurse upwards
    e := c;
    c := GetContainer(e);
  end;
end;

{ 
  MoveElementToIndex:
  Moves an element in an array to the specified index,
  if possible.
  
  Example usage:
  element := ElementByIP(e, 'Effects\[1]');
  MoveElementToIndex(element, 3); // moves element down twice
}
procedure MoveElementToIndex(e: IInterface; index: Integer);
var
  container: IInterface;
  currentIndex, newIndex: Integer;
  et: TwbElementType;
begin
  // raise exception if user input an etFile, etMainRecord, or etGroupRecord
  et := ElementType(e);
  case Ord(et) of
    Ord(etFile): raise Exception.Create('MoveElementToIndex: Cannot call MoveElementToIndex on a file');
    Ord(etMainRecord): raise Exception.Create('MoveElementToIndex: Cannot call MoveElementToIndex on a main record');
    Ord(etGroupRecord): raise Exception.Create('MoveElementToIndex: Cannot call MoveElementToIndex on a group record');
  end;
  
  // move element
  container := GetContainer(e);
  currentIndex := IndexOf(container, e);
  // move up if currentIndex < index
  while (currentIndex > index) do begin
    MoveUp(e);
    newIndex := IndexOf(container, e);
    if newIndex < currentIndex then
      currentIndex := newIndex
    else
      break;
  end;
  // move down if currentIndex < index
  while (currentIndex < index) do begin
    MoveDown(e);
    newIndex := IndexOf(container, e);
    if newIndex > currentIndex then
      currentIndex := newIndex
    else
      break;
  end;
end;


{****************************************************}
{ ELEMENT GETTERS
  Methods for getting elements.
  - ElementByIP
  - ebip
  - ElementsByMIP
  - ebmip
}
{****************************************************}
  
{
  ElementByIP:
  Element by Indexed Path
  
  This is a function to help with getting at elements that are inside 
  lists.  It allows you to use an "indexed path" to get at these elements
  that would otherwise be inaccessible without multiple lines of code.
  
  Example usage:
  element0 := ElementByIP(e, 'Conditions\[0]\CTDA - \Function');
  element1 := ElementByIP(e, 'Conditions\[1]\CTDA - \Function');
}
function ElementByIP(e: IInterface; ip: string): IInterface;
var
  i, index: integer;
  path: TStringList;
begin
  // raise exception if input element is not assigned
  if not Assigned(e) then
    raise Exception.Create('ElementByIP: Input element not assigned');
  
  // replace forward slashes with backslashes
  ip := StringReplace(ip, '/', '\', [rfReplaceAll]);
  
  // prepare path stringlist delimited by backslashes
  path := TStringList.Create;
  path.Delimiter := '\';
  path.StrictDelimiter := true;
  path.DelimitedText := ip;
  
  // traverse path
  for i := 0 to Pred(path.count) do begin
    if Pos('[', path[i]) > 0 then begin
      index := StrToInt(GetTextIn(path[i], '[', ']'));
      e := ElementByIndex(e, index);
    end
    else
      e := ElementByPath(e, path[i]);
  end;
  
  // set result
  Result := e;
end;

function ebip(e: IInterface; ip: string): IInterface;
begin
  Result := ElementByIP(e, ip);
end;

{
  ElementsByMIP
  This is a function that builds on ElementByIP by allowing the usage of the mult *
  character as a placeholder representing any valid index.  It returns through @lst
  a list of all elements in @e that match the input path @ip.
  
  Example usage:
  lst := TList.Create;
  ElementsByMIP(lst, e, 'Items\[*]\CNTO - Item\Item');
  for i := 0 to Pred(lst.Count) do begin
    AddMessage(GetEditValue(ObjectToElement(lst[i])));
  end; 
  lst.Free;
}
procedure ElementsByMIP(var lst: TList; e: IInterface; ip: string);
var
  xstr: string;
  i, j, index: integer;
  path: TStringList;
  bMult: boolean;
begin
  // replace forward slashes with backslashes
  ip := StringReplace(ip, '/', '\', [rfReplaceAll]);
  
  // prepare path stringlist delimited by backslashes
  path := TStringList.Create;
  path.Delimiter := '\';
  path.StrictDelimiter := true;
  path.DelimitedText := ip;
  
  // traverse path
  bMult := false;
  for i := 0 to Pred(path.count) do begin
    if Pos('[', path[i]) > 0 then begin
      xstr := GetTextIn(path[i], '[', ']');
      if xstr = '*' then begin
        for j := 0 to Pred(ElementCount(e)) do
          ElementsByMIP(lst, ElementByIndex(e, j), DelimitedTextBetween(path, i + 1, Pred(path.count)));
        bMult := true;
        break;
      end
      else
        e := ElementByIndex(e, index);
    end
    else
      e := ElementByPath(e, path[i]);
  end;
  if not bMult then lst.Add(TObject(e));
end;

procedure ebmip(var lst: TList; e: IInterface; ip: string);
begin
  ElementByMIP(lst, e, ip);
end;


{****************************************************}
{ ELEMENT VALUE GETTERS AND SETTERS
  Methods for getting and setting element values.
  - SetListEditValues
  - slev
  - SetListNativeValues
  - slnv
  - GetElementListEditValues
  - gelev
  - GetElementListNativeValues
  - gelnv
  - SetElementListEditValues
  - selev
  - SetElementListNativeValues
  - selnv
  - GetElementEditValuesEx
  - geevx
  - GetElementNativeValuesEx
  - genvx
  - SetElementEditValuesEx
  - seevx
  - SetElementNativeValuesEx
  - senvx
  - GetAllValues
  - gav
}
{****************************************************}

{
  SetListEditValues:
  Sets the values of elements in a list to values stored in a stringlist.
  
  Example usage:
  SetListEditValues(e, 'Additional Races', slAdditionalRaces);
}
procedure SetListEditValues(e: IInterface; ip: string; values: TStringList);
var
  i: integer;
  list, newelement: IInterface;
begin
  // exit if values is empty
  if values.Count = 0 then exit;
  
  list := ElementByIP(e, ip);
  // clear element list except for one element
  While ElementCount(list) > 1 do
    RemoveByIndex(list, 0, true);
  
  // create elements and populate the list
  for i := 0 to values.Count - 1 do begin
    newelement := ElementAssign(list, HighInteger, nil, False);
    try 
      SetEditValue(newelement, values[i]);
    except on Exception do
      Remove(newelement); // remove the invalid/failed element
    end;
  end;
  Remove(ElementByIndex(list, 0));
end;

procedure slev(e: IInterface; ip: string; values: TStringList);
begin
  SetListEditValues(e, ip, values);
end;

{
  SetListNativeValues:
  Sets the native values of elements in a list to the values stored in a Tlist.
  
  Example usage:
  SetListNativeValues(e, 'KWDA', lstKeywords);
}
procedure SetListNativeValues(e: IInterface; ip: string; values: TList);
var
  i: integer;
  list, newelement: IInterface;
begin
  // exit if values is empty
  if values.Count = 0 then exit;
  
  list := ElementByIP(e, ip);
  
  // clear element list except for one element
  While ElementCount(list) > 1 do
    RemoveByIndex(list, 0);
  
  // set element[0] to values[0]
  SetNativeValue(ElementByIndex(list, 0), values[0]);
  // create elements for the rest of the list
  for i := 1 to values.Count - 1 do begin
    newelement := ElementAssign(list, HighInteger, nil, False);
    SetNativeValue(newelement, values[i]);
  end;
end;

procedure slnv(e: IInterface; ip: string; values: TList);
begin
  SetListNativeValues(e, ip, values);
end;

{
  GetElementListEditValues:
  Uses GetEditValues on each element in a list of elements to
  produce a stringlist of element edit values.  Use with ElementsByMIP.
  
  Example usage:
  elements := TList.Create;
  // setup an arrray in elements with ElementsByMIP
  values := TStringList.Create;
  GetElementListEditValues(values, elements);
}
procedure GetElementListEditValues(var values: TStringList; var elements: TList);
var
  i: integer;
  e: IInterface;
begin
  for i := 0 to Pred(elements.Count) do begin
    e := ObjectToElement(elements[i]);
    if Assigned(e) then
      values.Add(GetEditValue(e))
    else
      values.Add('');
  end;
end;

procedure gelev(var values: TStringList; var elements: TList);
begin
  GetElementListEditValues(values, elements);
end;

{
  GetElementListNativeValues:
  Uses GetNativeValues on each element in a list of elements to
  produce a list of element native values.  Use with ElementsByMIP.
  
  Example usage:
  elements := TList.Create;
  // setup an arrray in elements with ElementsByMIP
  values := TList.Create;
  GetElementListNativeValues(values, elements);
}
procedure GetElementListNativeValues(var values: TList; var elements: TList);
var
  i: integer;
  e: IInterface;
begin
  for i := 0 to Pred(elements.Count) do begin
    e := ObjectToElement(elements[i]);
    if Assigned(e) then
      values.Add(TObject(GetNativeValue(e)))
    else
      values.Add(TObject(nil));
  end;
end;

procedure gelnv(var values: TList; var elements: TList);
begin
  GetElementListNativeValues(sl, elements);
end;

{
  SetElementListEditValues:
  Uses SetEditValue on each element in a list of elements to
  Use with ElementsByMIP and GetElementListEditValues.
  
  Example usage:
  elements := TList.Create;
  // setup an arrray in elements with ElementsByMIP
  values := TStringList.Create;
  GetElementListEditValues(values, elements);
  values[0] := 'Test';
  SetElementListEditValues(values, elements);
}
procedure SetElementListEditValues(var values: TStringList; var elements: TList);
var
  i: Integer;
  e: IInterface;
begin
  for i := 0 to Pred(elements.Count) do begin
    e := ObjectToElement(elements[i]);
    if Assigned(e) then
      SetEditValue(e, values[i]);
  end;
end;

procedure selev(var values: TStringList; var elements: TList);
begin
  SetElementListEditValues(values, elements);
end;

{
  SetElementListNativeValues:
  Uses SetNativeValue on each element in a list of elements to
  Use with ElementsByMIP and GetElementListNativeValues.
  
  Example usage:
  elements := TList.Create;
  // setup an arrray in elements with ElementsByMIP
  values := TList.Create;
  GetElementListNativeValues(values, elements);
  values[0] := -20;
  SetElementListNativeValues(values, elements);
}
procedure SetElementListNativeValues(var values: TList; var elements: TList);
var
  i: Integer;
  e: IInterface;
begin
  for i := 0 to Pred(elements.Count) do begin
    e := ObjectToElement(elements[i]);
    if Assigned(e) then
      SetNativeValue(e, values[i]);
  end;
end;

procedure selnv(var values: TList; var elements: TList);
begin
  SetElementListNativeValues(values, elements);
end;

{
  GetElementEditValuesEx:
  GetElementEditValues, extended with ElementByIP.
  
  Example usage:
  s1 := GetElementEditValuesEx(e, 'Conditions\[3]\CTDA - \Function');
  s2 := GetElementEditValuesEx(e, 'KWDA\[2]');
}
function GetElementEditValuesEx(e: IInterface; ip: string): string;
begin
  Result := GetEditValue(ElementByIP(e, ip));
end;

function geevx(e: IInterface; ip: string): string;
begin
  Result := GetElementEditValuesEx(e, ip);
end;

{
  GetElementNativeValuesEx:
  GetElementNativeValues, extended with ElementByIP.
  
  Example usage:
  f1 := genv(e, 'KWDA\[3]');
  f2 := genv(e, 'Armature\[2]');
}
function GetElementNativeValuesEx(e: IInterface; ip: string): variant;
begin
  Result := GetNativeValue(ElementByIP(e, ip));
end;

function genvx(e: IInterface; ip: string): variant;
begin
  Result := GetElementNativeValuesEx(e, ip);
end;

{
  SetElementEditValuesEx:
  SetElementEditValuesEx, extended with ElementByIP.
  
  Example usage:
  SetElementEditValuesEx(e, 'Conditions\[2]\CTDA - \Type', '10000000');
  SetElementEditValuesEx(e, 'KWDA\[0]'),
}
procedure SetElementEditValuesEx(e: IInterface; ip: string; val: string);
begin
  SetEditValue(ElementByIP(e, ip), val);
end;

procedure seevx(e: IInterface; ip: string; val: string);
begin
  SetElementEditValuesEx(e, ip, val);
end;

{
  SetElementNativeValuesEx:
  SetElementNativeValues, extended with ElementByIP.
  
  Example usage:
  SetElementNativeValuesEx(e, 'KWDA\[1]', $0006C0EE); // $0006C0EE is ArmorHelmet keyword
}
procedure SetElementNativeValuesEx(e: IInterface; ip: string; val: Variant);
begin
  SetNativeValue(ElementByIP(e, ip), val);
end;

procedure senvx(e: IInterface; ip: string; val: Variant);
begin
  SetElementNativeValuesEx(e, ip, val);
end;

{
  GetAllValues:
  Returns a semicolon-separated string hash of an element's
  value, and the value of all of its children.
  
  Example usage:
  AddMessage(GetAllValues(e));
}
function GetAllValues(e: IInterface): string;
var
  i: integer;
begin
  Result := GetEditValue(e);
  for i := 0 to ElementCount(e) - 1 do
    if (Result <> '') then Result := Result + ';' + GetAllValues(ElementByIndex(e, i))
    else Result := GetAllValues(ElementByIndex(e, i));
end;

function gav(e: IInterface): string;
begin
  Result := GetAllValues(e);
end;


{****************************************************}
{ VANILLA ALIASES
  Aliases for vanilla xEdit scripting functions.
  - ebn
  - ebp
  - ebi
  - geev
  - genv
  - seev
  - senv
}
{****************************************************}

{
  ebn:
  Alias for ElementByName.
}
function ebn(e: IInterface; n: string): IInterface;
begin
  Result := ElementByName(e, n);
end;

{
  ebp:
  Alias for ElementByPath.
}
function ebp(e: IInterface; p: string): IInterface;
begin
  Result := ElementByPath(e, p);
end;

{
  ebi:
  Alias for ElementByIndex.
}
function ebi(e: IInterface; i: integer): IInterface;
begin
  Result := ElementByIndex(e, i);
end;

{
  geev:
  Alias for GetElementEditValues.
}
function geev(e: IInterface; path: string): string;
begin
  Result := GetElementEditValues(e, path);
end;

{
  genv:
  Alias for GetElementNativeValues.
}
function genv(e: IInterface; path: string): Variant;
begin
  Result := GetElementNativeValues(e, path);
end;

{
  seev:
  Alias for SetElementEditValues.
}
procedure seev(e: IInterface; path: string; value: string);
begin
  SetElementEditValues(e, path, value);
end;

{
  senv:
  Alias for SetElementNativeValues.
}
procedure senv(e: IInterface; path: string; value: Variant);
begin
  SetElementNativeValues(e, path, value);
end;

  
{****************************************************}
{ FLAG METHODS
  Generic methods for handling flags.
  
  List of functions:
  - SetFlag
  - GetFlag
  - GetFlagOrdinal
  - ToggleFlag
  - GetEnabledFlags
}
{****************************************************}

procedure SetFlag(element: IInterface; index: Integer; state: boolean);
var
  mask: Integer;
begin
  mask := 1 shl index;
  if state then
    SetNativeValue(element, GetNativeValue(element) or mask)
  else
    SetNativeValue(element, GetNativeValue(element) and not mask);
end;

function GetFlag(element: IInterface; index: Integer): boolean;
var
  mask: Integer;
begin
  mask := 1 shl index;
  Result := (GetNativeValue(element) and mask) > 0;
end;

function GetFlagOrdinal(element: IInterface; name: string): Integer;
var
  i, iRestore: Integer;
  flag: IInterface;
begin
  Result := -1;
  iRestore := GetNativeValue(element);
  
  // set all flags on so we can find the user-specified flag
  SetNativeValue(element, $FFFFFFFF);
  for i := 0 to Pred(ElementCount(element)) do begin
    flag := ElementByIndex(element, i);
    if Name(flag) = name then begin
      Result := i;
      break;
    end;
  end;
  
  // restore value
  SetNativeValue(element, iRestore);
end;

procedure SetFlagByName(element: IInterface; name: string; state: boolean);
var
  index: Integer;
begin
  index := GetFlagOrdinal(element, name);
  SetFlag(element, index, state);
end;

function GetFlagByName(element: IInterface; name: string): boolean;
var
  index: Integer;
begin
  index := GetFlagOrdinal(element, name);
  Result := GetFlag(element, index);
end;

{****************************************************}
{ ARRAY VALUE METHODS
  Generic methods for handling array value elements.
  
  List of functions:
  - HasArrayValue
  - GetArrayValue
  - AddArrayValue
  - DeleteArrayValue
}
{****************************************************}

function HasArrayValue(a: IInterface; value: Variant): Boolean;
var
  i: Integer;
  element: IInterface;
begin
  Result := false;
  
  // throw exception if array is not given
  if not Assigned(a) then
    raise Exception.Create('HasArrayValue: Input array not assigned');
  // throw exception if value is not given
  if not Assigned(value) then
    raise Exception.Create('HasArrayValue: Input value not assigned');
  
  // loop through array elements
  for i := 0 to Pred(ElementCount(a)) do begin
    element := ElementByIndex(a, i);
    // if element matches value, set result to true and break
    if ElementMatches(element, value) then begin
      Result := true;
      Break;
    end;
  end;
end;

function GetArrayValue(a: IInterface; value: Variant): IInterface;
var
  i: Integer;
  element: IInterface;
begin
  Result := nil;
  
  // loop through array elements
  for i := 0 to Pred(ElementCount(a)) do begin
    element := ElementByIndex(a, i);
    // if element matches value, set it to result and break
    if ElementMatches(element, value) then begin
      Result := element;
      Break;
    end;
  end;
end;

function AddArrayValue(a: IInterface; value: Variant): IInterface;
var
  i, vt: Integer;
begin
  Result := nil;
  
  // add the element to the array
  Result := ElementAssign(a, HighInteger, nil, false);
  
  // set value to new element
  vt := VarType(value);
  case vt of 
    // native value if integer or floating point
    varInteger, varDouble, varShortInt:
      SetNativeValue(Result, value);
    // edit value if string or unicode string
    varString, varUString: 
      SetEditValue(Result, value);
  end;
end;

procedure DeleteArrayValue(a: IInterface; value: Variant);
var
  i: Integer;
  element: IInterface;
begin
  // loop through array elements
  for i := Pred(ElementCount(a)) downto 0 do begin
    element := ElementByIndex(a, i);
    // if element matches value, delete it and break
    if ElementMatches(element, value) then begin
      RemoveElement(a, element);
      Break;
    end;
  end;
end;


{****************************************************}
{ ARRAY STRUCT FUNCTIONS
  Generic methods for handling array structs.
  
  List of functions:
  - HasArrayStruct
  - GetArrayStruct
  - AddArrayStruct
  - DeleteArrayStruct
}
{****************************************************}

function HasArrayStruct(a: IInterface; path: String; value: Variant): Boolean;
var
  i: Integer;
  struct: IInterface;
begin
  Result := false;
  
  // loop through array elements
  for i := 0 to Pred(ElementCount(a)) do begin
    struct := ElementByIndex(a, i);
    // if struct matches value, set result to true and break
    if StructMatches(a, struct, path, value) then begin
      Result := true;
      Break;
    end;
  end;
end;

function GetArrayStruct(a: IInterface; path: String; value: Variant): IInterface;
var
  i: Integer;
  struct: IInterface;
begin
  Result := nil;
  
  // loop through array elements
  for i := 0 to Pred(ElementCount(a)) do begin
    struct := ElementByIndex(a, i);
    // if struct matches value, set result to true and break
    if StructMatches(a, struct, path, value) then begin
      Result := struct;
      Break;
    end;
  end;
end;

// TODO: Support setting value of added array struct
function AddArrayStruct(a: IInterface): IInterface;
begin
  Result := nil;
  
  // add the struct to the array
  Result := ElementAssign(a, HighInteger, nil, false);
end;

procedure DeleteArrayStruct(a: IInterface; path: String; value: Variant);
var
  i: Integer;
  struct: IInterface;
begin
  // loop through array elements
  for i := Pred(ElementCount(a)) downto 0 do begin
    struct := ElementByIndex(a, i);
    // if struct matches value, set result to true and break
    if StructMatches(a, struct, path, value) then begin
      RemoveElement(a, struct);
      Break;
    end;
  end;
end;

end.