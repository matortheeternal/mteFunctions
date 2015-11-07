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
  Result := nil;
  ovCount := OverrideCount(element);
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

{
Alternative OverrideByFile Function
  Unlike the other functions I have gone ahead and tested this one and it does work.
  Pros:
  -Doesn't require parsing
  -Most of the calculations are done in native TES5Edit code
  
  Cons:
  -Requires the function to be cast in a try statement as LoaddOrderFormIDToFileFormID() wil throw an error
   if the file you give as a parameter does not have the appropriate file as a master. 
   Not sure how much that may affect speeds.
   
  Not quite sure which is faster so I will leave it up to you.
}
function OverrideByFile2(element, file: IInterface): IInterface;
var
  fFormID: Integer;
begin
  Result := nil;
  try
    //Checks if the file is capable of having "element" as an override record and, if so, it wil give the appropriate FileFormID.
    fFormID := LoadOrderFormIDToFileFormID(file, GetLoadOrderFormID(element));
    Result := RecordByFormID(file, fFormID, false);
  except
    on e:exception do begin
      //AddMessage('OverrideByFile2: Override ' + IntToHex(loFormID,8) + ' not found in file ' + GetFileName(file));
    end;
  end;
end;
{
 An extension of TES5Edit's native function RecordByFormID().  
 Allows you to input LoadOrderFormIDs rather than FileFormIDs
 Derived this function using the code above.  Should be a useful function.
 Note: Havent integrated this into the function above yet just in case we decide not to use it.
}
function RecordByLoadOrderFormID(file: IInterface; loFormID: cardinal; allowOverrides: Boolean): IInterface;
var
  fFormID: Integer;
begin
  Result := nil;
  try
    fFormID := LoadOrderFormIDToFileFormID(file, loFormID);
    Result := RecordByFormID(file,fFormID,allowOverrides);
  except
    on e:Exception do begin
      //AddMessage('RecordByLoadOrderFormID Warning: Record ' + IntToHex(loFormID,8) + ' not found in ' + GetFileName(file));
    end;
  end;
  //RecordByFormID() will return nil if the record cannot be found.
end;

//Will return the override index of a given Record, will return -1 if given a Master Recrod
function GetOverrideIndex(element: IInterface): Integer;
var
  i, ovCount: Integer;
begin
  ovCount := OverrideCount(element);
  Result := -1;
  for i := 0 to Pred(ovCount) do begin
    If Equals(OverrideByIndex(element, i), element) then begin
      Result := i;
    end;
  end;
end;

//When given an Override of a record, will try to get the next winning override.  
//If the provided record is the only override and allowMasters is true, then it will return the Master record, otherwise it will return itself.
function WinningOverrideBefore(element: IInterface; allowMasters: Boolean): IInterface;
var
  ovIndex, i: Integer;
begin
  ovIndex := GetOverrideIndex(element)
  Case ovIndex of
    -1 : raise Exception.Create('WinningOverrideBefore: Provided Record is a Master Record');
     0 : begin
          if AllowMasters then Result := Master(element) 
          else Result := element;
         end;
    else Result := OverrideByIndex(element, Pred(ovIndex));
  end;
end;
end.
