{
  mteRecords
  
  Component of mteFunctions for handling IwbMainRecords.
  See http://github.com/matortheeternal/mteFunctions
}

unit mteRecords;

uses 'lib\mteElements';

{****************************************************}
{ GENERAL METHODS
  General methods for handling IwbMainRecords.
  > Flags methods
    - SetFlag
    - GetFlag
    - GetFlagOrdinal
    - ToggleFlag
    - GetEnabledFlags
  > Overrides methods
  > Record getters
  > Common attribute getting/setting
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

procedure ToggleFlag(element: IInterface; index: Integer);
var
  mask: Integer;
begin
  if GetFlag(element, index) then 
    SetFlag(element, index,false)
  else
    SetFlag(element,index,true);
end;

//When given a Record and a File, will try and find the override found in the given file
function OverrideByFile(aRecord, aFile: IInterface): IInterface;
var
  ovCount, i: Integer;
  ovByIndex: IInterface;
begin
  Result := nil;
  if ElementType(aRecord) <> etMainRecord then
    raise Exception.Create('OverrideByFile: aRecord must be of type etMainRecord.');
  if ElementType(aFile) <> etFile then 
    raise Exception.Create('OverrideByFile: aFile must be of type etFile.');
  ovCount := OverrideCount(aRecord);
  //Parse through all overrides and check if the file of the override matches the given file parameter
  for i := 0 to Pred(ovCount) do begin
    ovByIndex := OverrideByIndex(aRecord, i);
    //If it does, then return the override
    if Equals(GetFile(ovByIndex),aFile) then begin
      Result := ovByIndex;
      Exit;
    end;
  end;
end;

//Will return the override index of a given Record, will return -1 if given a Master Record
function GetOverrideIndex(aRecord: IInterface): Integer;
var
  i, ovCount: Integer;
begin
  Result := -1;
  if ElementType(aRecord) <> etMainRecord then
    raise Exception.Create('GetOverrideIndex: aRecord must be of type etMainRecord.');
  ovCount := OverrideCount(aRecord);
  for i := 0 to Pred(ovCount) do begin
    If Equals(OverrideByIndex(aRecord, i), element) then begin
      Result := i;
    end;
  end;
end;

{
//When given an Override of a record, will try to get the next winning override.
  If the provided record is the only override and bReturnMasterRecords is set true, then it will return the Master record, otherwise it will return itself.
  Ex.  If there are 3 Overrides of a Record--Ov1(loaded 1st), Ov2(loaded 2nd), and Ov3(loaded 3rd).
       WinningOverrideBefore(ov3,true/false) will return Ov2.
       WinningOverrideBefore(ov2,true/false) will return Ov1.
       WinningOverrideBefore(ov1,false) will return ov1.
       WinningOverrideBefore(ov1,true) will return Master(ov1).
}
function WinningOverrideBefore(aRecord: IInterface; bReturnMasterRecords: Boolean): IInterface;
var
  ovIndex: Integer;
begin
  Result := nil;
  if ElementType(aRecord) <> etMainRecord then
    raise Exception.Create('WinningOverrideBefore: aRecord must be of type etMainRecord.');
  ovIndex := GetOverrideIndex(aRecord)
  Case ovIndex of
  (-1): raise Exception.Create('WinningOverrideBefore: Provided aRecord is a Master Record');
     0: begin
          if bReturnMasterRecords then Result := Master(aRecord) 
          else Result := aRecord;
        end;
    else Result := OverrideByIndex(aRecord, Pred(ovIndex));
  end;
end;

function IsOverrideIn(aRecord, aFile: IInterface): Boolean;
begin
  Return := false;
  if ElementType(aRecord) <> etMainRecord then
    raise Exception.Create('IsOverrideIn: aRecord must be of type etMainRecord.');
  if ElementType(aFile) <> etFile then 
    raise Exception.Create('IsOverrideIn: aFile must be of type etFile.');
  If Assigned(OverrideByFile(aRecord, aFile)) then Return := true;
end;

//Possible Different Approach to HexFormID, not sure if it is any faster or not.
function HexFormID(aRecord: IInterface): String;
var
  loFormID: Integer;
begin
  //GetLoadOrderFormID() will return 0 if a non-record/unassigned element is given.
  loFormID := GetLoadOrderFormID(aRecord);
  case Ord(loFormID) of
    0 : Result := '00000000';
  else Result := IntToHex(loFormID, 8);
end;

//Modified Older Version.  Can put in hard-coded values as the HexFormID is always placed at the end of the edit value for all versions.
function HexFormID(aRecord: IInterface): String;
var
  editValue: String;
begin
  Result := -1;
    case Ord(ElementType(aRecord)) for
      Ord(etMainRecord): editValue := geev(aRecord,'Record Header\FormID\');
       Ord(etSubRecord): editValue := geev(LinksTo(aRecord),'Record Header\FormID\');
                   (-1): raise Exception.Create('HexFormID:  Cannot call HexFormID on a nil record');
    else raise Exception.Create('HexFormID: aRecord must be of type etMainRecord or etSubRecord');
    end;
  Result := Copy(editValue, Length(editValue)-8,8);
end;

{
  HasKeyword:
  Checks if an input record has a keyword matching the input EditorID.
  
  Example usage:
  if HasKeyword(e, 'ArmorHeavy') then
    AddMessage(Name(e) + ' is a heavy armor.');
}
function HasKeyword(e: IInterface; edid: string): boolean;
var
  kwda: IInterface;
  n: integer;
begin
  Result := false;
  kwda := ElementByPath(e, 'KWDA');
  for n := 0 to ElementCount(kwda) - 1 do
    if EditorID(LinksTo(ElementByIndex(kwda, n))) = edid then 
      Result := true;
end;

//============================================
{
  HasItem:
  Checks if an input record has an item matching the input EditorID.
  
  Example usage:
  if HasItem(e, 'IngotIron') then
    AddMessage(Name(e) + ' is made using iron!');
}
function HasItem(rec: IInterface; s: string): boolean;
var
  name: string;
  items, li: IInterface;
  i: integer;
begin
  Result := false;
  items := ElementByPath(rec, 'Items');
  if not Assigned(items) then 
    exit;
  
  for i := 0 to ElementCount(items) - 1 do begin
    li := ElementByIndex(items, i);
    name := EditorID(LinksTo(ElementByPath(li, 'CNTO - Item\Item')));
    if name = s then begin
      Result := true;
      Break;
    end;
  end;
end;

{
  HasPerkCondition:
  Checks if an input record has a HasPerk condition requiring a perk
  matching the input EditorID.
  
  Example usage:
  if HasPerkCondition(e, 'AdvancedSmithing') then
    AddMessage(Name(e) + ' is an advanced armor!');
}
function HasPerkCondition(rec: IInterface; s: string): boolean;
var
  name, func: string;
  conditions, ci: IInterface;
  i: integer;
begin
  Result := false;
  conditions := ElementByPath(rec, 'Conditions');
  if not Assigned(conditions) then
    exit;
    
  for i := 0 to ElementCount(conditions) - 1 do begin
    ci := ElementByIndex(conditions, i);
    func := geev(ci, 'CTDA - \Function');
    if func = 'HasPerk' then begin
      name := EditorID(LinksTo(ElementByPath(ci, 'CTDA - \Perk'));
      if name = s then begin
        Result := true;
        Break;
      end;
    end;
  end;
end;

end.
