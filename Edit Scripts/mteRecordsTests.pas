{
  mteRecords Tests
  Tests for functions in mteRecords
}

unit mteRecordsTests;

uses 'lib\mteRecords', 'lib\jvTest';

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
var
  f, rec, flags: IInterface;
  iRestore, iActual: Integer;
begin
  (*** SetFlag Tests ***)
  Describe('SetFlag');
  try
    Describe('Turning a flag on');
    iRestore := -1;
    try
      f := FileByLoadOrder(1);
      rec := RecordByIndex(f, 0);
      flags := ElementByPath(rec, 'ENIT\Flags');
      iRestore := GetNativeValue(flags);
      
      // try setting flag 2
      SetFlag(flags, 2, true);
      iActual := GetNativeValue(flags);
      ExpectEqual(IntToHex(iActual, 8), '00000006', 'Should have a value of $6');
      SetNativeValue(flags, iRestore);
      
      // try setting flag 5
      SetFlag(flags, 5, true);
      iActual := GetNativeValue(flags);
      ExpectEqual(IntToHex(iActual, 8), '00000022', 'Should have a value of $22');
      SetNativeValue(flags, iRestore);
      
      Pass;
    except
      on x: Exception do begin
        if iRestore > -1 then
          SetNativeValue(flags, iRestore);
        Fail(x);
      end;
    end;
    
    Describe('Turning a flag off');
    try
      f := FileByLoadOrder(1);
      rec := RecordByIndex(f, 0);
      flags := ElementByPath(rec, 'ENIT\Flags');
      iRestore := GetNativeValue(flags);
      
      // try setting flag 1 off
      SetFlag(flags, 1, false);
      iActual := GetNativeValue(flags);
      ExpectEqual(IntToHex(iActual, 8), '00000000', 'Should have a value of $0');
      SetNativeValue(flags, iRestore);
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Turning a flag on when it''s already on');
    try
      f := FileByLoadOrder(1);
      rec := RecordByIndex(f, 0);
      flags := ElementByPath(rec, 'ENIT\Flags');
      iRestore := GetNativeValue(flags);
      
      // try setting flag 1 off
      SetFlag(flags, 1, true);
      iActual := GetNativeValue(flags);
      ExpectEqual(IntToHex(iActual, 8), '00000002', 'Should have a value of $2');
      SetNativeValue(flags, iRestore);
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Turning a flag off when it''s already off');
    try
      f := FileByLoadOrder(1);
      rec := RecordByIndex(f, 0);
      flags := ElementByPath(rec, 'ENIT\Flags');
      iRestore := GetNativeValue(flags);
      
      // try setting flag 0 off
      SetFlag(flags, 0, false);
      iActual := GetNativeValue(flags);
      ExpectEqual(IntToHex(iActual, 8), '00000002', 'Should have a value of $2');
      SetNativeValue(flags, iRestore);
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** GetFlag Tests ***)
  Describe('GetFlag');
  try
    Describe('Getting a flag that''s off');
    try
      f := FileByLoadOrder(1);
      rec := RecordByIndex(f, 0);
      flags := ElementByPath(rec, 'ENIT\Flags');
      Expect(not GetFlag(flags, 0), 'Should return false');
      Pass;
    except
      on x: Exception do begin
        if iRestore > -1 then
          SetNativeValue(flags, iRestore);
        Fail(x);
      end;
    end;
    
    Describe('Getting a flag that''s on');
    try
      f := FileByLoadOrder(1);
      rec := RecordByIndex(f, 0);
      flags := ElementByPath(rec, 'ENIT\Flags');
      Expect(GetFlag(flags, 1), 'Should return true');
      Pass;
    except
      on x: Exception do begin
        if iRestore > -1 then
          SetNativeValue(flags, iRestore);
        Fail(x);
      end;
    end;
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
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