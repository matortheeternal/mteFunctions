{
  mteElements
  
  Component of mteFunctions for handling IwbElements.
  See http://github.com/matortheeternal/mteFunctions
}

unit mteElements;

uses 'lib\mteBase';


{****************************************************}
{
}
{****************************************************}

procedure MoveElementToIndex(e: IInterface; index: Integer);
var
  container: IInterface;
  currentIndex, newIndex: Integer;
begin
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

end.