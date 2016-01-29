{
  mteRecords
  
  Component of mteFunctions for handling IwbMainRecords.
  See http://github.com/matortheeternal/mteFunctions
  
  TODO:
  - HasKeyword
  - AddKeyword
  - RemoveKeyword
  - HasFormID
  - AddFormID
  - RemoveFormID
  - HasMusicTrack
  - AddMusicTrack
  - RemoveMusicTrack
  - HasFootstep
  - AddFootstep
  - RemoveFootstep
  - HasItem
  - AddItem
  - GetItem
  - RemoveItem
  - SetItemCount
  - HasLeveledEntry
  - GetLeveledEntry
  - AddLeveledEntry
  - RemoveLeveledEntry
  - HasCondition
  - GetCondition
  - AddCondition
  - RemoveCondition
  - HasPerkCondition
  - GetPerkCondition
  - AddPerkCondition
  - RemovePerkCondition
  - AddScript
  - GetScript
  - HasScript
  - RemoveScript
  - AddScriptProperty
  - GetScriptProperty
  - HasScriptProperty
  - RemoveScriptPropery
  - AddEffect
  - GetEffect  
  - HasEffect
  - RemoveEffect
  - AddAdditionalRace
  - HasAdditionalRace
  - RemoveAdditionalRace
  - GetModel
  - SetModel
  - GetGoldValue
  - SetGoldValue
  - GetDamage
  - SetDamage
  - GetArmorRating
  - SetArmorRating
  - GetWeight
  - SetWeight
  - GetIsFemale
  - SetIsFemale
  - GetIsEssential
  - SetIsEssential
  - GetIsUnique
  - SetIsUnique
  - AddFirstPersonFlag
  - HasFirstPersonFlag
  - RemoveFirstPersonFlag
  - SetObjectBounds
  - GetSignatureFromName
}

unit mteRecords;

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

end.