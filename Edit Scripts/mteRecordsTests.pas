{
  mteRecords Tests
  Tests for functions in mteRecords
}

unit mteRecordsTests;

uses 'lib\mteBase', 'lib\mteRecords', 'lib\jvTest';

const
  mteTestVersion = '0.0.0.1';
  mteTestFile1 = 'TestMTE-1.esp';
  mteTestFile2 = 'TestMTE-2.esp';
  mteTestFile3 = 'TestMTE-3.esp';
  mteTestFile4 = 'TestMTE-4.esp';
  expectedLoadOrder = 'Skyrim.esm'#44'TestMTE-1.esp'#44'TestMTE-2.esp'#44
  'TestMTE-3.esp'#44'TestMTE-4.esp';

{
  mteVersionTest:
  Raises an exception if you're the testing suite 
  is not built to target the version of mteFunctions 
  the user is running.
}
procedure mteVersionTest;
begin
  if mteVersion <> mteTestVersion then
    raise Exception.Create('mteRecordsTests - These tests are meant to be '+
      'run on mteFunctions v'+mteTestVersion+', you are running v'+
      mteVersion+'.  Testing terminated.');
end;

{
  VerifyEnvironment:
  Raises an exception if the user's load order doesn't
  match the expected load order.
}
procedure VerifyEnvironment;
var
  i: Integer;
  f: IInterface;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    for i := 0 to FileCount -2 do begin
      f := FileByLoadOrder(i);
      sl.Add(GetFileName(f));
    end;
    
    if sl.CommaText <> expectedLoadOrder then 
      raise Exception.Create('To run these tests, your load order must be: '+expectedLoadOrder);
  finally
    sl.Free;
  end;
end;

{ 
  TestMteRecords:
  Tests the functions in mteRecords using the jvTest
  framework.
}
procedure TestMteRecords;
  // ?
end;



{******************************************************************************}
{ ENTRY POINTS
  Entry points for when the script is run in xEdit.
    - Initialize
}
{******************************************************************************}

function Initialize: Integer;
begin
  // don't perform tests if mteVersionTest fails
  mteVersionTest;
  VerifyEnvironment;
  
  jvtInitialize;
  // perform tests
  TestMteRecords;
  
  // finalize jvt
  jvtPrintReport;
  jvtFinalize;
end;

end.