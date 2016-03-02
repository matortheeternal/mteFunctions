{
  mteRecords
  
  Component of mteFunctions for handling IwbMainRecords.
  See http://github.com/matortheeternal/mteFunctions
  
  TODO:
  > Override methods
  
  > Common attribute getting/setting
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

uses 'lib\mteElements';

{****************************************************}
{ RECORD HELPERS
  Methods for getting or creating records. 
  - NewRecord
  - LoadRecordsTo
  - LoadChildRecordsTo
}
{****************************************************}

function NewRecord(f: IInterface; sig: String): IInterface;
var
  group: IInterface;
begin
  Result := nil;
  
  // raise exception if input file is not assigned
  if not Assigned(f) then 
    raise Exception.Create('NewRecord: Input file not assigned');
  // raise exception if input signature is not assigned
  if not Assigned(sig) then 
    raise Exception.Create('NewRecord: Input record signature not assigned');
  
  // create group if missing.
  if HasGroup(f, sig) then
    group := GroupBySignature(f, sig)
  else
    group := Add(f, sig);
    
  // raise an exception if the group isn't assigned
  if not Assigned(group) then
    raise Exception.Create(Format('NewRecord: Failed to create group %s in %s', 
      [sig, GetFileName(f)]));
  
  // create and return a new record in the group
  Result := Add(group, sig);
end;

end.