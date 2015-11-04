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

//When given a Record and a File, will try and find the override found in the given file
function OverrideByFile(element, file: IInterface): IInterface;
var
  ovCount, i: Integer;
  ovByIndex: IInterface;
begin
  ovCount := OverrideCount(element);
  //check if there is even any overrides to begin with.  If not, notify the user and exit the function.
  if ovCount == 0 then begin
    //AddMessage('OverrideByFile Error: No Overrides for element ' + ShortName(element)');
    Exit;
  end;
  //Parse through all overrides and check if the file of the override matches the given file parameter
  for i := 0 to Pred(ovCount) do begin
    ovByIndex := OverrideByIndex(element, i);
    //If it does, then return the override
    if Equals(GetFile(ovByIndex),file) then begin
      Result := ovByIndex;
      Exit;
    end;
  end;
end;

//When given an Override of a record, will try to get the previous override, otherwise will return the given record
function WinningOverrideBefore(element: IInterface): IInterface;
var
  ovCount, i: Integer;
begin
  ovCount := OverrideCount(element);
  //If the given record is the only override or the master then return the given record,
  if ovCount < 2 then begin
    Result := element;
    //AddMessage('WinningOverride Error: ' + IntToStr(ovCount) + ' overrides found for ' + ShortName(element) + '.  Returning given Element');
    Exit;
  end;
  //Parse through the list until your record is found
  for i := Pred(ovCount) downto 0 do begin
    //If your element is found then return the previous override
    if Equals(OverrideByIndex(element, i), element) then begin
      Result := OverrideByIndex(element, (i-1));
      Exit;
    end;
  end;
end;







end.
