{
  mteTypes
  
  General helpers for mteFunctions.
  See http://github.com/matortheeternal/mteFunctions
}

unit mteTypes;

const
  // Times
  aDay = 1.0;
  aHour = aDay / 24.0;
  aMinute = aHour / 60.0;
  
  // Colors
  clAqua = $FFFF00;
  clBlack = $000000;
  clBlue = $FF0000;
  clCream = $F0FBFF;
  clDkGray = $808080;
  clFuchsia = $FF00FF;
  clGray = $808080;
  clGreen = $008000;
  clLime = $00FF00;
  clLtGray = $C0C0C0;
  clMaroon = $000080;
  clMedGray = $A4A0A0;
  clMoneyGreen = $C0DCC0;
  clNavy = $800000;
  clOlive = $008080;
  clPurple = $800080;
  clRed = $0000FF;
  clSilver = $C0C0C0;
  clSkyBlue = $F0CAA6;
  clTeal = $808000;
  clWhite = $FFFFFF;
  clYellow = $00FFFF;
  
  // Web Colors
  clWebSnow = $FAFAFF;
  clWebFloralWhite = $F0FAFF;
  clWebLavenderBlush = $F5F0FF;
  clWebOldLace = $E6F5FD;
  clWebIvory = $F0FFFF;
  clWebCornSilk = $DCF8FF;
  clWebBeige = $DCF5F5;
  clWebAntiqueWhite = $D7EBFA;
  clWebWheat = $B3DEF5;
  clWebAliceBlue = $FFF8F0;
  clWebGhostWhite = $FFF8F8;
  clWebLavender = $FAE6E6;
  clWebSeashell = $EEF5FF;
  clWebLightYellow = $E0FFFF;
  clWebPapayaWhip = $D5EFFF;
  clWebNavajoWhite = $ADDEFF;
  clWebMoccasin = $B5E4FF;
  clWebBurlywood = $87B8DE;
  clWebAzure = $FFFFF0;
  clWebMintcream = $FAFFF5;
  clWebHoneydew = $F0FFF0;
  clWebLinen = $E6F0FA;
  clWebLemonChiffon = $CDFAFF;
  clWebBlanchedAlmond = $CDEBFF;
  clWebBisque = $C4E4FF;
  clWebPeachPuff = $B9DAFF;
  clWebTan = $8CB4D2;
  clWebYellow = $00FFFF;
  clWebDarkOrange = $008CFF;
  clWebRed = $0000FF;
  clWebDarkRed = $00008B;
  clWebMaroon = $000080;
  clWebIndianRed = $5C5CCD;
  clWebSalmon = $7280FA;
  clWebCoral = $507FFF;
  clWebGold = $00D7FF;
  clWebTomato = $4763FF;
  clWebCrimson = $3C14DC;
  clWebBrown = $2A2AA5;
  clWebChocolate = $1E69D2;
  clWebSandyBrown = $60A4F4;
  clWebLightSalmon = $7AA0FF;
  clWebLightCoral = $8080F0;
  clWebOrange = $00A5FF;
  clWebOrangeRed = $0045FF;
  clWebFirebrick = $2222B2;
  clWebSaddleBrown = $13458B;
  clWebSienna = $2D52A0;
  clWebPeru = $3F85CD;
  clWebDarkSalmon = $7A96E9;
  clWebRosyBrown = $8F8FBC;
  clWebPaleGoldenrod = $AAE8EE;
  clWebLightGoldenrodYellow = $D2FAFA;
  clWebOlive = $008080;
  clWebForestGreen = $228B22;
  clWebGreenYellow = $2FFFAD;
  clWebChartreuse = $00FF7F;
  clWebLightGreen = $90EE90;
  clWebAquamarine = $D4FF7F;
  clWebSeaGreen = $578B2E;
  clWebGoldenRod = $20A5DA;
  clWebKhaki = $8CE6F0;
  clWebOliveDrab = $238E6B;
  clWebGreen = $008000;
  clWebYellowGreen = $32CD9A;
  clWebLawnGreen = $00FC7C;
  clWebPaleGreen = $98FB98;
  clWebMediumAquamarine = $AACD66;
  clWebMediumSeaGreen = $71B33C;
  clWebDarkGoldenRod = $0B86B8;
  clWebDarkKhaki = $6BB7BD;
  clWebDarkOliveGreen = $2F6B55;
  clWebDarkgreen = $006400;
  clWebLimeGreen = $32CD32;
  clWebLime = $00FF00;
  clWebSpringGreen = $7FFF00;
  clWebMediumSpringGreen = $9AFA00;
  clWebDarkSeaGreen = $8FBC8F;
  clWebLightSeaGreen = $AAB220;
  clWebPaleTurquoise = $EEEEAF;
  clWebLightCyan = $FFFFE0;
  clWebLightBlue = $E6D8AD;
  clWebLightSkyBlue = $FACE87;
  clWebCornFlowerBlue = $ED9564;
  clWebDarkBlue = $8B0000;
  clWebIndigo = $82004B;
  clWebMediumTurquoise = $CCD148;
  clWebTurquoise = $D0E040;
  clWebCyan = $FFFF00;
  clWebAqua = $FFFF00;
  clWebPowderBlue = $E6E0B0;
  clWebSkyBlue = $EBCE87;
  clWebRoyalBlue = $E16941;
  clWebMediumBlue = $CD0000;
  clWebMidnightBlue = $701919;
  clWebDarkTurquoise = $D1CE00;
  clWebCadetBlue = $A09E5F;
  clWebDarkCyan = $8B8B00;
  clWebTeal = $808000;
  clWebDeepskyBlue = $FFBF00;
  clWebDodgerBlue = $FF901E;
  clWebBlue = $FF0000;
  clWebNavy = $800000;
  clWebDarkViolet = $D30094;
  clWebDarkOrchid = $CC3299;
  clWebMagenta = $FF00FF;
  clWebFuchsia = $FF00FF;
  clWebDarkMagenta = $8B008B;
  clWebMediumVioletRed = $8515C7;
  clWebPaleVioletRed = $9370DB;
  clWebBlueViolet = $E22B8A;
  clWebMediumOrchid = $D355BA;
  clWebMediumPurple = $DB7093;
  clWebPurple = $800080;
  clWebDeepPink = $9314FF;
  clWebLightPink = $C1B6FF;
  clWebViolet = $EE82EE;
  clWebOrchid = $D670DA;
  clWebPlum = $DDA0DD;
  clWebThistle = $D8BFD8;
  clWebHotPink = $B469FF;
  clWebPink = $CBC0FF;
  clWebLightSteelBlue = $DEC4B0;
  clWebMediumSlateBlue = $EE687B;
  clWebLightSlateGray = $998877;
  clWebWhite = $FFFFFF;
  clWebLightgrey = $D3D3D3;
  clWebGray = $808080;
  clWebSteelBlue = $B48246;
  clWebSlateBlue = $CD5A6A;
  clWebSlateGray = $908070;
  clWebWhiteSmoke = $F5F5F5;
  clWebSilver = $C0C0C0;
  clWebDimGray = $696969;
  clWebMistyRose = $E1E4FF;
  clWebDarkSlateBlue = $8B3D48;
  clWebDarkSlategray = $4F4F2F;
  clWebGainsboro = $DCDCDC;
  clWebDarkGray = $A9A9A9;
  clWebBlack = $000000;
  

{*****************************************************************************}
{ Boolean Helpers
  Functions for handling and converting booleans.
  
  List of functions:
  - IfThenVar
  - BoolToStr
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

{
  BoolToStr:
  Returns 'True' if @b is true, 'False' if @b is false.
}
function BoolToStr(b: Boolean): String;
begin
  Result := IfThenVar(b, 'True', 'False');
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
  - ItPos
  - LastPos
  - CopyFromTo
  - ReverseString
  - GetTextIn
  - StrEndsWith
  - AppendIfMissing
  - RemoveFromEnd
  - StrStartsWith
  - PrependIfMissing
  - RemoveFromStart
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
  cDelimiters = #9#10#13' ,.:;"\/()[]{}';
var
  i: Integer;
  bDelimited: boolean;
  sChar: string;
begin
  // set default result
  Result := '';
  
  // if input isn't empty, loop through the characters in it
  if (sText <> '') then begin
    bDelimited := true;
    for i := 1 to Length(sText) do begin
      sChar := LowerCase(Copy(sText, i, 1));
      if (Pos(sChar, cDelimiters) > 0) then
        bDelimited := true
      else if bDelimited then begin
        sChar := UpCase(sChar);
        bDelimited := false;
      end;
      Result := Result + sChar;
    end;
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
  cTerminators = '!.?';
var
  i: Integer;
  bTerminated: boolean;
  sChar: string;
begin
  // set result
  Result := '';
  
  // if input isn't empty, loop through the characters in it
  if (sText <> '') then begin
    bTerminated := true;
    for i := 1 to Length(sText) do begin
      sChar := LowerCase(Copy(sText, i, 1));
      if (Pos(sChar, cTerminators) > 0) then
        bTerminated := true
      else if bTerminated and (sChar <> ' ') then begin
        sChar := UpCase(sChar);
        bTerminated := false;
      end;
      Result := Result + sChar;
    end;
  end;
end;

{
  ItPos:
  Returns the position of the @target iteration of @substr in @str.
  If the requested iteration isn't found 0 is returned.
  
  Example usage:
  s := '10101';
  k := ItPos('1', s, 3);
  AddMessage(IntToStr(k)); // 5
}
function ItPos(substr, str: String; target: Integer): Integer;
var
  i, found: Integer;
begin
  Result := 0;
  found := 0;
  
  // exit if the target iteration is less than 1
  // because that doesn't make any sense
  if target < 1 then 
    exit;
    
  // exit if substring is empty
  if substr = '' then
    exit;
  
  // loop through the input string
  for i := 1 to Length(str) do begin
    // check if the substring is at the current position
    if Copy(str, i, Length(substr)) = substr then
      Inc(found);
      
    // if this is the target iteration, set Result and break
    if found = target then begin
      Result := i;
      Break;
    end;
  end;
end;

{
  LastPos:
  Gets the last position of @substr in @str.  Returns 0 if the substring 
  isn't found in the input string.
  
  Example usage:
  s := 'C:\Program Files (x86)\steam\SteamApps\common\Skyrim\TES5Edit.exe';
  AddMessage(Copy(s, LastPos('\', s) + 1, Length(s))); // 'TES5Edit.exe'
}
function LastPos(substr, str: String): Integer;
var
  i: integer;
begin
  Result := 0;
  
  // if str and substr are the same length,
  // Result is whether or not they're equal
  if (Length(str) - Length(substr) <= 0) then begin
    if (str = substr) then
      Result := 1;
    exit;
  end;
  
  // loop through the string backwards
  for i := Length(str) - Length(substr) downto 1 do begin
    if (Copy(str, i, Length(substr)) = substr) then begin
      Result := i;
      break;
    end;
  end;
end;

{
  CopyFromTo:
  Returns a substring in a string @str inclusively between two indexes 
  @iStart and @iEnd.
  
  Example usage:
  AddMessage(CopyFromTo('this is an example', 6, 10)); // 'is an'
}
function CopyFromTo(str: string; iStart, iEnd: Integer): string;
begin
  if iStart < 1 then
    raise Exception.Create('CopyFromTo: Start index cannot be less than 1');
  if iEnd < iStart then
    raise Exception.Create('CopyFromTo: End index cannot be less than the start index');
  Result := Copy(str, iStart, (iEnd - iStart) + 1);
end;

{
  ReverseString:
  Reverses the input string @s.
  
  Example usage:
  s := 'backwards';
  s := ReverseString(s);
  AddMessage(s); // 'sdrawkcab'
}
function ReverseString(var s: string): string;
var
  i: integer;
begin
   Result := '';
   for i := Length(s) downto 1 do begin
     Result := Result + Copy(s, i, 1);
   end;
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
  sChar: string;
begin
  Result := '';
  bOpen := false;
  openIndex := 0;
  
  // loop through string looking for the open char
  for i := 1 to Length(str) do begin
    sChar := Copy(str, i, 1);
    // if open char found, set openIndex and bOpen boolean
    // if already opened reset open index if open <> close
    if (sChar = open) and not (bOpen and (open = close)) then begin
      openIndex := i;
      bOpen := true;
    end
    // if opened and we find the close char, set result and break
    else if bOpen and (sChar = close) then begin
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
function StrEndsWith(str, substr: string): boolean;
var
  n1, n2: integer;
begin
  Result := false;

  n1 := Length(str);
  n2 := Length(substr);
  if n1 < n2 then exit;

  Result := (Copy(str, n1 - n2 + 1, n2) = substr);
end;

{
  AppendIfMissing:
  Appends substr to the end of str if it's not already there.

  Example usage:
  s := 'This is a sample string.';
  AddMessage(AppendIfMissing(s, 'string.')); //'This is a sample string.'
  AddMessage(AppendIfMissing(s, '  Hello.')); //'This is a sample string.  Hello.'
}
function AppendIfMissing(str, substr: string): string;
begin
  Result := str;
  if not StrEndsWith(str, substr) then
    Result := str + substr;
end;

{
  RemoveFromEnd:
  Creates a new string with substr removed from the end of s2, if found.

  Example usage:
  s := 'This is a sample string.';
  AddMessage(RemoveFromEnd(s, 'string.')); //'This is a sample '
}
function RemoveFromEnd(str, substr: string): string;
begin
  Result := str;
  if StrEndsWith(str, substr) then
    Result := Copy(str, 1, Length(str) - Length(substr));
end;

{
  StrStartsWith:
  Checks to see if a string starts with an entered substring.

  Example usage:
  s := 'This is a sample string.';
  if StrStartsWith(s, 'This ') then
    AddMessage('It works!');
}
function StrStartsWith(str, substr: string): boolean;
var
  n1, n2: integer;
begin
  Result := false;

  n1 := Length(str);
  n2 := Length(substr);
  if n1 < n2 then exit;

  Result := (Copy(str, 1, n2) = substr);
end;

{
  PrependIfMissing:
  Prepends substr to the beginning of str if it's not already there.

  Example usage:
  s := 'This is a sample string.';
  AddMessage(PrependIfMissing(s, 'This ')); //'This is a sample string.'
  AddMessage(PrependIfMissing(s, 'Hello.  ')); //'Hello.  This is a sample string.'
}
function PrependIfMissing(str, substr: string): string;
begin
  Result := str;
  if not StrStartsWith(str, substr) then
    Result := substr + str;
end;

{
  RemoveFromStart:
  Creates a new string with substr removed from the start of substr, if found.

  Example usage:
  s := 'This is a sample string.';
  AddMessage(RemoveFromStart(s, 'This ')); //'is a sample string.'
}
function RemoveFromStart(str, substr: string): string;
begin
  Result := str;
  if StrStartsWith(str, substr) then
    Result := Copy(str, Length(substr) + 1, Length(str));
end;

{ 
  IsUrl:
  Returns true if the string @s is an http:// or https:// url.
  
  Example usage:
  if IsUrl(s) then
    ShellExecute(0, 'open', PChar(s), nil, nil , SW_SHOWNORMAL); 
}
function IsURL(s: string): boolean;
begin
  s := Lowercase(s);
  Result := (Pos('http://', s) = 1) or (Pos('https://', s) = 1);
end;

{ 
  Wordwrap:
  Inserts line breaks in string @s before @charCount has been exceeded.
  
  Example usage:
  s := 'Some very long string that probably should have line breaks '+
    'in it because it's going to go off of your screen and mess '+
    'up labels or hints or other such things if you don't wrap '+
    'it.';
  AddMessage(WordWrap(s, 60));
  // 'Some very long string that probably should have line breaks '#13 +
     'in it because it's going to go off of your screen and mess '#13 +
     'up labels or hints or other such things if you don't wrap '#13 + 
     'it.'
}
function Wordwrap(s: string; charCount: integer): string;
const
  bDebugThis = false;
var
  i, j, lastSpace, counter: Integer;
  sChar, sNextChar: string;
begin
  // initialize variables
  counter := 0;
  lastSpace := 0;
  i := 1;
  
  // debug message
  if bDebugThis then AddMessage(Format('Called Wordwrap(%s, %d)', [s, charCount]));
  
  // loop for every character except the last one
  while (i < Length(s)) do begin
    // increment the counter for characters on the line and get the character
    // at the current position and the next position
    Inc(counter);
    sChar := Copy(s, i, 1);
    sNextChar := Copy(s, i + 1, 1);
    
    // debug message
    if bDebugThis then AddMessage(Format('  [%d] Counter = %d, Char = %s', [i, counter, sChar]));
    
    // track the position of the last space we've seen
    if (sChar = ' ') or (sChar = ',') then
      lastSpace := i;
      
    // if we encounter a new line, reset the counter for the characters on the line
    // also don't make a new line if the next character is a newline character
    if (sChar = #13) or (sChar = #10)
    or (sNextChar = #13) or (sNextChar = #10) then begin
      lastSpace := 0;
      counter := 0;
    end;
    
    // if we've exceeded the number of characters allowed on the line and we've seen
    // a space on the line, insert a line break at the space and reset the counter
    if (counter > charCount) and (lastSpace > 0) then begin
      Insert(#13#10, s, lastSpace + 1);
      counter := i - lastSpace;
      lastSpace := 0;
      i := i + 2;
    end;
    
    // proceed to next character in the while loop
    Inc(i);
  end;
  
  // return the modified string
  Result := s;
end;


{*****************************************************************************}
{ Date and Time Helpers
  Functions for handling dates and times.
  
  NOTE: I did not implement SecondOf or RateStr down to seconds because 
  limitations in precision in the jvInterpreter.
  
  List of functions:
  - DayOf
  - HourOf
  - MinuteOf
  - RateStr
  - TimeStr
}
{*****************************************************************************}

{ 
  DayOf:
  Returns the day portion of a TDateTime as an integer
}
function DayOf(date: TDateTime): Integer;
begin
  Result := Trunc(date);
end;

{ 
  HourOf:
  Returns the hour portion of a TDateTime as an integer
}
function HourOf(date: TDateTime): Integer;
begin
  Result := Trunc(date / aHour) mod 24;
end;

{ 
  MinuteOf:
  Returns the minute portion of a TDateTime as an integer
}
function MinuteOf(date: TDateTime): Integer;
begin
  Result := Trunc(date / aMinute) mod 60;
end;

{ 
  RateStr:
  Converts a TDateTime to a rate string, e.g. Every 24.0 hours
}
function RateStr(rate: TDateTime): string;
begin
  if rate > aDay then
    Result := Format('Every %0.1f days', [rate])
  else if rate > aHour then
    Result := Format('Every %0.1f hours', [rate * 24.0])
  else
    Result := Format('Every %0.1f minutes', [rate * 24.0 * 60.0])
end;

{ 
  DurationStr:
  Converts a TDateTime to a duratrion string, e.g. 19d 20h 3m
}
function DurationStr(duration: TDateTime; sep: String): string;
begin
  Result := Format('%dd%s%dh%s%dm', 
    [DayOf(duration), sep, HourOf(duration), sep, MinuteOf(duration)]);
end;


{*****************************************************************************}
{ Color Helpers
  Functions for handling Colors.
  
  List of functions:
  - GetRValue
  - GetGValue
  - GetBValue
  - RGB
  - ColorToHex
  - HexToColor
}
{*****************************************************************************}

function GetRValue(rgb: Integer): Byte;
begin
  Result := Byte(rgb);
end;

function GetGValue(rgb: Integer): Byte;
begin
  Result := Byte(rgb shr 8);
end;

function GetBValue(rgb: Integer): Byte;
begin
  Result := Byte(rgb shr 16);
end;

function RGB(r, g, b: Byte): Integer;
begin
  Result := (r or (g shl 8) or (b shl 16));
end;

function ColorToHex(Color: Integer): string;
begin
   Result :=
     IntToHex(GetRValue(Color), 2) +
     IntToHex(GetGValue(Color), 2) +
     IntToHex(GetBValue(Color), 2);
end;

function HexToColor(sColor : string): Integer;
begin
   Result :=
     RGB(
       StrToInt('$'+Copy(sColor, 1, 2)),
       StrToInt('$'+Copy(sColor, 3, 2)),
       StrToInt('$'+Copy(sColor, 5, 2))
     );
end;


{*****************************************************************************}
{ Class Helpers
  Functions for handling common classes like TStringLists and TLists.
  
  List of functions:
  - IntegerListSum
  - SaveStringToFile
  - LoadStringFromFile
  - ApplyTemplate
  - FreeAndNil
  - TryToFree
}
{*****************************************************************************}

{ 
  IntegerListSum:
  Calculates the integer sum of all values in a TStringList to maxIndex
}
function IntegerListSum(sl: TStringList; maxIndex: integer): integer;
var
  i: Integer;
begin
  Result := 0;
  
  // raise exception if input list is not assigned
  if not Assigned(sl) then
    raise Exception.Create('IntegerListSum: Input stringlist is not assigned');
  // raise exception if input max index is out of bounds
  if maxIndex >= sl.Count then
    raise Exception.Create('IntegerListSum: Input maxIndex is out of bounds for the input stringlist');
  
  // perform the sum  
  for i := 0 to maxIndex do
    Result := Result + StrToInt(sl[i]);
end;

{ 
  SaveStringToFile:
  Saves a string @s to a file at @fn
}
procedure SaveStringToFile(s: string; fn: string);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Text := s;
    sl.SaveToFile(fn);
  finally
    sl.Free;
  end;
end;

{ 
  LoadStringFromFile:
  Loads a the file at @fn and returns its contents as a string
}
function LoadStringFromFile(fn: string): String;
var
  sl: TStringList;
begin
  Result := '';
  sl := TStringList.Create;
  try
    sl.LoadFromFile(fn);
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

{ 
  ApplyTemplate:
  Applies the values in the stringlist @map to corresponding names in @template
}
function ApplyTemplate(const template: string; var map: TStringList): string;
const
  openTag = '{{';
  closeTag = '}}';
var
  i: Integer;
  name, value: string;
begin
  Result := template;
  
  // raise exception if input map is not assigned
  if not Assigned(map) then
    raise Exception.Create('ApplyTemplate: Input map stringlist is not assigned');
  
  // apply the map to the template
  for i := 0 to Pred(map.Count) do begin
    name := map.Names[i];
    value := map.ValueFromIndex[i];
    Result := StringReplace(Result, openTag + name + closeTag, value, [rfReplaceAll]);
  end;
end;

{ 
  FreeAndNil:
  Frees @obj then sets it to nil
}
procedure FreeAndNil(var obj: TObject);
begin
  obj.Free;
  obj := nil;
end;

{ 
  TryToFree:
  Attempts to free and nil an object
}
procedure TryToFree(var obj: TObject);
const
  bDebugThis = false;
begin
  try
    if Assigned(obj) then
      obj.Free;
    obj := nil;
  except
    on x: Exception do begin
      if bDebugThis then ShowMessage('TryToFree exception: '+x.Message);
    end;
  end;
end;

end.