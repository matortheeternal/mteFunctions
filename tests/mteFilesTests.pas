{
  mteFiles Tests
  Tests for functions in mteFiles
}


unit mteFilesTests;

uses 'lib\mteFiles', 'lib\jvTest';

const
  mteTestVersion = '0.0.0.1';

{
  mteVersionTest:
  Raises an exception if you're the testing suite 
  is not built to target the version of mteFunctions 
  the user is running.
}
procedure mteVersionTest;
begin
  if mteVersion <> mteTestVersion then
    raise Exception.Create('mteFilesTests - These tests are meant to be '+
      'run on mteFunctions v'+mteTestVersion+', you are running '+
      mteVersion+'.  Testing terminated.');
end;

procedure VerifyEnvironment;
var
  i: Integer;
  f: IInterface;
  bFoundFile: boolean;
begin
  for i := 0 to Pred(FileCount) do begin
    f := FileByIndex(i);
    bFoundFile := GetFileName(f) = 'TestFileMTE.esp';
    if bFoundFile then
      break;
  end;
end;

{ 
  TestMteFiles:
  Tests the functions in mteFiles using the jvTest
  framework.
}
procedure TestMteFiles;
var
  bCaughtException: boolean;
  xEditVersion: string;
  fileHeader, f, rec: IInterface;
  iRestore, iActual: Integer;
  sRestore, sActual: string;
  lst: TList;
begin
  (*** GetFileHeader Tests ***)
  Describe('GetFileHeader');
  try
    // Test with file unassigned
    Describe('File unassigned');
    try
      bCaughtException := false;
      try
        f := nil;
        GetFileHeader(f);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'GetFileHeader: Input file is unassigned', 'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with an element that isn't a file
    Describe('Element is not a file');
    try
      bCaughtException := false;
      try
        f := FileByIndex(0);
        rec := RecordByIndex(f, 0);
        GetFileHeader(rec);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'GetFileHeader: Input element is not a file', 'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with a valid input file
    Describe('Valid input file');
    try
      f := FileByIndex(0);
      Expect(Equals(GetFileHeader(f), ElementByIndex(f, 0)), 'Should return the file header');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** GetNextObjectID Tests ***)
  Describe('GetNextObjectID');
  try
    // Test with valid input file
    f := FileByIndex(0);
    fileHeader := ElementByIndex(f, 0);
    iActual := GetElementNativeValues(fileHeader, 'HEDR\Next Object ID');
    ExpectEqual(GetNextObjectID(f), iActual, 'Should return the Next Object ID');
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** SetNextObjectID Tests ***)
  Describe('SetNextObjectID');
  iRestore := -1;
  try
    // Test with valid input file
    f := FileByName('TestFileMTE.esp');
    fileHeader := ElementByIndex(f, 0);
    
    // store value so it can be resotred
    iRestore := GetElementNativeValues(fileHeader, 'HEDR\Next Object ID');
    
    SetNextObjectID(f, 9999);
    iActual := GetElementNativeValues(fileHeader, 'HEDR\Next Object ID');
    ExpectEqual(iActual, 9999, 'Should set the value of the Next Object ID element');
    
    // restore value
    SetElementNativeValues(fileHeader, 'HEDR\Next Object ID', iRestore);
    Pass;
  except
    on x: Exception do begin
      // restore value if changed
      if Assigned(fileHeader) and (iRestore > -1) then
        SetElementNativeValues(fileHeader, 'HEDR\Next Object ID', iRestore);
      Fail(x);
    end;
  end;
  
  (*** GetAuthor Tests ***)
  Describe('GetAuthor');
  try
    // Test with valid input file
    f := FileByIndex(0);
    fileHeader := ElementByIndex(f, 0);
    sActual := GetElementEditValues(fileHeader, 'CNAM - Author');
    ExpectEqual(GetAuthor(f), sActual, 'Should return the author');
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** SetAuthor Tests ***)
  Describe('SetAuthor');
  sRestore := '-1';
  try
    // Test with valid input file
    f := FileByName('TestFileMTE.esp');
    fileHeader := ElementByIndex(f, 0);
    
    // store value so it can be resotred
    sRestore := GetElementEditValues(fileHeader, 'CNAM - Author');
    
    SetAuthor(f, 'Testing123');
    sActual := GetElementEditValues(fileHeader, 'CNAM - Author');
    ExpectEqual(sActual, 'Testing123', 'Should set the value of the author element');
    
    // restore value
    SetElementEditValues(fileHeader, 'CNAM - Author', sRestore);
    Pass;
  except
    on x: Exception do begin
      // restore value if changed
      if Assigned(fileHeader) and (sRestore <> '-1') then
        SetElementEditValues(fileHeader, 'CNAM - Author', sRestore);
      Fail(x);
    end;
  end;
  
  (*** GetDescription Tests ***)
  Describe('GetDescription');
  try
    // Test with valid input file
    f := FileByIndex(0);
    fileHeader := ElementByIndex(f, 0);
    sActual := GetElementEditValues(fileHeader, 'SNAM - Description');
    ExpectEqual(GetDescription(f), sActual, 'Should return the description');
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** SetDescription Tests ***)
  Describe('SetDescription');
  try
    // Test with valid input file
    f := FileByName('TestFileMTE.esp');
    fileHeader := ElementByIndex(f, 0);
    
    // test description doesn't exist
    SetDescription(f, 'Testing123');
    sActual := GetElementEditValues(fileHeader, 'SNAM - Description');
    ExpectEqual(sActual, 'Testing123', 'Should create the description element with the correct value if it doesn''t exist');
    
    // test description exists
    SetDescription(f, 'abcTesting');
    sActual := GetElementEditValues(fileHeader, 'SNAM - Description');
    ExpectEqual(sActual, 'abcTesting', 'Should set the value of the description element');
    
    // tear down
    Remove(ElementByPath(fileHeader, 'SNAM - Description'));
    Pass;
  except
    on x: Exception do begin
      if Assigned(fileHeader) then
        Remove(ElementByPath(fileHeader, 'SNAM - Description'));
      Fail(x);
    end;
  end;
  
  (*** OverrideRecordCount Tests ***)
  Describe('OverrideRecordCount');
  try
    // Test with file unassigned
    Describe('File unassigned');
    try
      bCaughtException := false;
      try
        f := nil;
        OverrideRecordCount(f);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'OverrideRecordCount: Input file unassigned', 'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with valid input file
    Describe('Valid input file');
    try
      f := FileByName('TestFileMTE.esp');
      ExpectEqual(OverrideRecordCount(f), 6, 'Should return 6 for TestFileMTE.esp');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** GetOverrideRecords Tests ***)
  Describe('GetOverrideRecords');
  try
    // Test with file unassigned
    Describe('File unassigned');
    try
      bCaughtException := false;
      try
        f := nil;
        GetOverrideRecords(f, lst);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'GetOverrideRecords: Input file not assigned', 'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with input list not assigned
    Describe('Input list not assigned');
    try
      bCaughtException := false;
      lst := nil;
      try
        f := FileByName('TestFileMTE.esp');
        GetOverrideRecords(f, lst);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'GetOverrideRecords: Input TList not assigned', 'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with valid inputs
    Describe('Valid inputs');
    lst := TList.Create;
    try
      f := FileByName('TestFileMTE.esp');
      GetOverrideRecords(f, lst);
      ExpectEqual(lst.Count, 6, 'Should have found 6 override records in TestFileMTE.esp');
      rec := ObjectToElement(lst[0]);
      ExpectEqual(Name(rec), 'FirebrandWine "Firebrand Wine" [ALCH:0001895F]' , 'Should have found Firebrand Wine as first override');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    lst.Free;
    
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
  TestMteFiles;
  
  // finalize jvt
  jvtPrintReport;
  jvtFinalize;
end;

end.