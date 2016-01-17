{
  mteTypes
  
  General helpers for mteFunctions.
  See http://github.com/matortheeternal/mteFunctions
}

unit mteTypes;

uses 'lib\mteBase';

{*****************************************************************************}
{ Boolean Functions
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
{ Integer Functions
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
function IntLog(Value, Base: Int64): Int64;
begin
  Result := 0;
  while Value > Base do begin
    Value = Value div Base;
    Inc(Result);
  end;
end;

{ 
  FormatFileSize:
  Formats a file size in @bytes to a human readable string.
  
  Example usage:
  AddMessage(FormatFileSize(5748224)); // '5.48 MB'
  AddMessage(FormatFileSize(-41306451305613)); // '-37.56 TB
}
function FormatFileSize(const bytes: Int64): string;
const
  units: array of string[0..6] = (
    'bytes', 
    'KB', // Kilobyte, 10^3 bytes
    'MB', // Megabyte, 10^6 bytes
    'GB', // Gigabyte, 10^9 bytes
    'TB', // Terabyte, 10^12 bytes
    'PB', // Petabyte, 10^15 bytes
    'EB'  // Exabyte, 10^18 bytes
  );
var
  uIndex: Integer;
begin
  uIndex := IntLog(abs(bytes), 1024);
  if (uIndex > 0) then
    Result := Format('%f %s', [bytes / power(1024, uIndex), units[uIndex]])
  else
    Result := Format('%f %s', [bytes, units[uIndex]]);
end;

end.