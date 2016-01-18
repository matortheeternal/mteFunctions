{
  mteTypes
  
  General helpers for mteFunctions.
  See http://github.com/matortheeternal/mteFunctions
}

unit mteTypes;

uses 'lib\mteBase';

{*****************************************************************************}
{ Boolean Helpers
  Functions for handling and converting booleans.
  
  List of functions:
  - IfThenVar
}
{*****************************************************************************}

{
  IfThenVar:
  Returns one of two variants based on a boolean argument.
  Like IfThen from StrUtils, but returns a variant.
}
function IfThenVar(AValue: boolean; ATrue, AFalse: Variant): Variant;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;


{*****************************************************************************}
{ Integer Helpers
  Functions for handling and converting integers.
  
  List of functions:
  - IntLog
  - FormatFileSize
}
{*****************************************************************************}

{
  IntLog:
  Returns the integer logarithm of @Value using @Base.
  
  Example usage:
  i := IntLog(8, 2);
  AddMessage(IntToStr(i)); // 3
  i := IntLog(257, 2);
  AddMessage(IntToStr(i)); // 8
  i := IntLog(1573741824, 1024);
  AddMessage(IntToStr(i)); // 3
}
function IntLog(Value, Base: Integer): Integer;
begin
  Result := 0;
  
  // a base <= 1 is invalid when performing a logarithm
  if Base <= 1 then
    raise Exception.Create('IntLog: Base cannot be less than or equal to 1');
    
  // compute the logarithm by performing integer division repeatedly
  while Value >= Base do begin
    Value := Value div Base;
    Inc(Result);
  end;
end;

{ 
  FormatFileSize:
  Formats a file size in @bytes to a human readable string.
  
  NOTE:
  Currently xEdit scripting doesn't support an Int64 or Cardinal data
  type, so the maximum value this function can take is +2147483648,
  which comes out to 2.00GB.
  
  Example usage:
  AddMessage(FormatFileSize(5748224)); // '5.48 MB'
  AddMessage(FormatFileSize(-2147483647)); // '-2.00 GB
}
function FormatFileSize(const bytes: Integer): string;
var
  units: array[0..3] of string;
var
  uIndex: Integer;
begin
  // initialize units array
  units[0] := 'bytes'; 
  units[1] := 'KB'; // Kilobyte, 10^3 bytes
  units[2] := 'MB'; // Megabyte, 10^6 bytes
  units[3] := 'GB';  // Gigabyte, 10^9 bytes
  
  // get unit to used based on the size of bytes
  uIndex := IntLog(abs(bytes), 1024);
  
  // return formatted file size string
  if (uIndex > 0) then
    Result := Format('%f %s', [bytes / IntPower(1024, uIndex), units[uIndex]])
  else
    Result := Format('%d %s', [bytes, units[uIndex]]);
end;


{*****************************************************************************}
{ String Helpers
  Functions for handling and converting strings.
  
  List of functions:
  - TitleCase
  - SentenceCase
  - CopyFromTo
  - GetTextIn
  - StrEndsWith
  - AppendIfMissing
  - RemoveFromEnd
  - IsURL
  - Wordwrap
}
{*****************************************************************************}

{ 
  TitleCase:
  Capitalizes the first letter of each word in @sText.
  
  Example usage:
  AddMessage(TitleCase('the title of a book')); 
  // 'The Title Of A Book'
  AddMessage(TitleCase('a text,with.punctuation!yay')); 
  // 'A Text,With.Punctuation!Yay'
  AddMessage(TitleCase('[this(is/going);to,be'#13'great!')); 
  // 'This(Is/Going);To,Be'#13'Great!'
}
function TitleCase(sText: String): String;
const
  cDelimiters = [#9, #10, #13, ' ', ',', '.', ':', ';', '"',
                 '\', '/', '(', ')', '[', ']', '{', '}'];
var
  iLoop: Integer;
begin
  Result := sText;
  if (Result <> '') then begin
    Result := LowerCase(Result);

    Result[1] := UpCase(Result[1]);
    for iLoop := 2 to Length(Result) do
      if (Result[iLoop - 1] in cDelimiters) then
        Result[iLoop] := UpCase(Result[iLoop]);
  end;
end;

{ 
  SentenceCase:
  Capitalizes the first character of each sentence in @sText.

  Example usage:
  AddMessage(SentenceCase('this is a sentence.  so is this.')); 
  // 'This is a sentence.  So is this.'
  AddMessage(SentenceCase('lets Try something!  different?!?this time.,a'));
  // 'Lets Try something!  Different?!?This time.,a'
}
function SentenceCase(sText: string): string;
const
  cTerminators = ['!', '.', '?'];
var
  iLoop: Integer;
  bTerminated: boolean;
begin
  Result := sText;
  if (Result <> '') then begin
    Result := LowerCase(Result);

    Result[1] := UpCase(Result[1]);
    bTerminated := false;
    for iLoop := 2 to Length(Result) do begin
      if (Result[iLoop - 1] in cTerminators) then
        bTerminated := true;
      if bTerminated and (Result[iLoop] <> ' ') then
        Result[iLoop] := UpCase(Result[iLoop]);
    end;
  end;
end;

{
  CopyFromTo:
  Returns a substring in a string @str inclusively between two indexes 
  @first and @last.
  
  Example usage:
  AddMessage(CopyFromTo('this is an example', 6, 10)); // 'is an'
}
function CopyFromTo(str: string; first, last: Integer): string;
begin
  Result := Copy(str, first, (last - first) + 1);
end;

{ 
  GetTextIn:
  Returns a substring of @str between characters @open and @close.
  
  Example usage:
  AddMessage(GetTextIn('example of [some text] in brackets', '[', ']'));
  // 'some text'
}
function GetTextIn(str: string; open, close: char): string;
var
  i, openIndex: integer;
  bOpen: boolean;
begin
  Result := '';
  bOpen := false;
  openIndex := 0;
  for i := 0 to Length(str) do begin
    if not bOpen and (str[i] = open) then begin
      openIndex := i;
      bOpen := true;
    end
    else if bOpen and (str[i] = close) then begin
      Result := CopyFromTo(str, openIndex + 1, i - 1);
      break;
    end;
  end;
end;

{
  StrEndsWith:
  Checks to see if a string ends with an entered substring.

  Example usage:
  s := 'This is a sample string.';
  if StrEndsWith(s, 'string.') then
    AddMessage('It works!');
}
function StrEndsWith(s1, s2: string): boolean;
var
  n1, n2: integer;
begin
  Result := false;

  n1 := Length(s1);
  n2 := Length(s2);
  if n1 < n2 then exit;

  Result := (Copy(s1, n1 - n2 + 1, n2) = s2);
end;

{
  AppendIfMissing:
  Appends substr to the end of str if it's not already there.

  Example usage:
  s := 'This is a sample string.';
  Logger.Write(AppendIfMissing(s, 'string.')); //'This is a sample string.'
  Logger.Write(AppendIfMissing(s, '  Hello.')); //'This is a sample string.  Hello.'
}
function AppendIfMissing(str, substr: string): string;
begin
  Result := str;
  if not StrEndsWith(str, substr) then
    Result := str + substr;
end;

{
  RemoveFromEnd:
  Creates a new string with s1 removed from the end of s2, if found.

  Example usage:
  s := 'This is a sample string.';
  AddMessage(RemoveFromEnd(s, 'string.')); //'This is a sample '
}
function RemoveFromEnd(s1, s2: string): string;
begin
  Result := s1;
  if StrEndsWith(s1, s2) then
    Result := Copy(s1, 1, Length(s1) - Length(s2));
end;

{ Returns true if the string is an http:// or https:// url }
function IsURL(s: string): boolean;
begin
  Result := (Pos('http://', s) = 1) or (Pos('https://', s) = 1);
end;

{ Inserts line breaks in string @s before @charCount has been exceeded }
function Wordwrap(s: string; charCount: integer): string;
var
  i, lastSpace, counter: Integer;
begin
  counter := 0;
  lastSpace := 0;
  for i := 1 to Length(s) - 1 do begin
    Inc(counter);
    if (s[i] = ' ') or (s[i] = ',') then
      lastSpace := i;
    if (s[i] = #13) or (s[i] = #10)
    or (s[i + 1] = #13) or (s[i + 1] = #10) then begin
      lastSpace := 0;
      counter := 0;
    end;
    if (counter = charCount) and (lastSpace > 0) then begin
      Insert(#13#10, s, lastSpace + 1);
      lastSpace := 0;
      counter := 0;
    end;
  end;
  Result := s;
end;


{*****************************************************************************}
{ Date and Time Helpers
  Functions for handling dates and times.
  
  List of functions:
  - RateStr
  - TimeStr
}
{*****************************************************************************}

{ Converts a TDateTime to a rate string, e.g. Every 24.0 hours }
function RateStr(date: TDateTime): string;
begin
  if date > 1.0 then
    Result := Format('Every %0.2f days', [date])
  else if date * 24.0 > 1.0 then
    Result := Format('Every %0.1f hours', [date * 24.0])
  else if date * 24.0 * 60.0 > 1.0 then
    Result := Format('Every %0.1f minutes', [date * 24.0 * 60.0])
  else
    Result := Format('Every %0.1f seconds', [date * 24.0 * 60.0 * 60.0]);
end;

{ Converts a TDateTime to a time string, e.g. 19d 20h 3m 30s }
function TimeStr(date: TDateTime): string;
begin
  Result := Format('%dd %dh %dm', [Trunc(date), HourOf(date), MinuteOf(date)]);
end;


{*****************************************************************************}
{ Class Helpers
  Functions for handling common classes like TStringLists and TLists.
  
  List of functions:
  - IntegerListSum
  - ContainsMatch
  - SaveStringToFile
  - ApplyTemplate
  - TryToFree
  - FreeList
}
{*****************************************************************************}

{ Calculates the integer sum of all values in a TStringList to maxIndex }
function IntegerListSum(list: TStringList; maxIndex: integer): integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to maxIndex do
    Inc(result, StrToInt(list[i]));
end;

{ Checks to see if any mask in @sl matches the string @s }
function ContainsMatch(var sl: TStringList; const s: string): boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to Pred(sl.Count) do
    if MatchesMask(s, sl[i]) then begin
      Result := true;
      break;
    end;
end;

{ Saves a string @s to a file at @fn }
procedure SaveStringToFile(s: string; fn: string);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  sl.Text := s;
  sl.SaveToFile(fn);
  sl.Free;
end;

function ApplyTemplate(const template: string; var map: TStringList): string;
const
  openTag = '{{';
  closeTag = '}}';
var
  i: Integer;
  name, value: string;
begin
  Result := template;
  for i := 0 to Pred(map.Count) do begin
    name := map.Names[i];
    value := map.ValueFromIndex[i];
    Result := StringReplace(Result, openTag + name + closeTag, value, [rfReplaceAll]);
  end;
end;

procedure TryToFree(obj: TObject);
begin
  if Assigned(obj) then try
    obj.Free;
  except
    on x: Exception do // nothing
  end;
end;

procedure FreeList(var lst: TList);
var
  i: Integer;
  obj: TObject;
begin
  for i := Pred(lst.Count) downto 0 do begin
    obj := TObject(lst[i]);
    TryToFree(obj);
  end;
  lst.Free;
end;

end.