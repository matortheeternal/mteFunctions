{
  mteFiles Tests
  Tests for functions in mteFiles
}


unit mteFilesTests;

uses 'lib\mteBase', 'lib\mteFiles', 'lib\jvTest';

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
    raise Exception.Create('mteFilesTests - These tests are meant to be '+
      'run on mteFunctions v'+mteTestVersion+', you are running '+
      mteVersion+'.  Testing terminated.');
end;

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
  RemoveMasters:
  Helper method that removes the Master Files element from
  a file.
}
procedure RemoveMasters(filename: string);
var
  fileHeader, f, masters: IInterface;
begin
  f := FileByName(filename);
  fileHeader := GetFileHeader(f);
  masters := ElementByPath(fileHeader, 'Master Files');
  if Assigned(masters) then
    Remove(masters);
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
  sl, sl2: TStringList;
begin
  (*** GetFileHeader Tests ***)
  Describe('GetFileHeader');
  try
    // Test with file not assigned
    Describe('File not assigned');
    try
      bCaughtException := false;
      try
        f := nil;
        GetFileHeader(f);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'GetFileHeader: Input file is not assigned', 'Should raise the correct exception');
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
    f := FileByName(mteTestFile1);
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
    f := FileByName(mteTestFile1);
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
    f := FileByName(mteTestFile1);
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
    // Test with file not assigned
    Describe('File not assigned');
    try
      bCaughtException := false;
      try
        f := nil;
        OverrideRecordCount(f);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'OverrideRecordCount: Input file not assigned', 'Should raise the correct exception');
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
      f := FileByName(mteTestFile1);
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
    // Test with file not assigned
    Describe('File not assigned');
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
        f := FileByName(mteTestFile1);
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
      f := FileByName(mteTestFile1);
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
  
  (*** AddFileToList Test ***)
  Describe('AddFileToList');
  try
    // Test with file not assigned
    Describe('Input file not assigned');
    try
      bCaughtException := false;
      try
        f := nil;
        AddFileToList(f, sl);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'AddFileToList: Input file is not assigned', 'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with stringlist not assigned
    Describe('Input stringlist not assigned');
    try
      bCaughtException := false;
      sl := nil;
      try
        f := FileByIndex(0);
        AddFileToList(f, sl);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'AddFileToList: Input TStringList is not assigned', 'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with valid inputs
    Describe('Valid inputs');
    sl := TStringList.Create;
    try
      f := FileByIndex(0);
      AddFileToList(f, sl);
      ExpectEqual(sl.Count, 1, 'Files list should have 1 item');
      ExpectEqual(sl[0], GetFileName(f), 'First item should be Skyrim.esm');
      ExpectEqual(Integer(sl.Objects[0]), 0, 'First item should have a load order of 0');
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    // Test with file added twice
    Describe('File added twice');
    sl := TStringList.Create;
    try
      f := FileByIndex(0);
      AddFileToList(f, sl);
      AddFileToList(f, sl);
      ExpectEqual(sl.Count, 1, 'Files list should have 1 item');
      ExpectEqual(sl[0], GetFileName(f), 'First item should be Skyrim.esm');
      ExpectEqual(Integer(sl.Objects[0]), 0, 'First item should have a load order of 0');
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    // Test file with lower load order than existing item added
    Describe('File with lower load order added');
    sl := TStringList.Create;
    try
      f := FileByName(mteTestFile1);
      AddFileToList(f, sl);
      f := FileByIndex(0);
      AddFileToList(f, sl);
      ExpectEqual(sl.Count, 2, 'Files list should have 2 items');
      ExpectEqual(sl[0], GetFileName(f), 'First item should be Skyrim.esm');
      ExpectEqual(sl[1], mteTestFile1, 'Second item should be '+mteTestFile1);
      ExpectEqual(Integer(sl.Objects[0]), 0, 'First item should have a load order of 0');
      ExpectEqual(Integer(sl.Objects[1]), 1, 'Second item should have a load order of 1');
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    // Test file with higher load order than existing item added
    Describe('File with higher load order added');
    sl := TStringList.Create;
    try
      f := FileByIndex(0);
      AddFileToList(f, sl);
      f := FileByName(mteTestFile1);
      AddFileToList(f, sl);
      f := FileByIndex(0);
      ExpectEqual(sl.Count, 2, 'Files list should have 2 items');
      ExpectEqual(sl[0], GetFileName(f), 'First item should be Skyrim.esm');
      ExpectEqual(sl[1], mteTestFile1, 'Second item should be '+mteTestFile1);
      ExpectEqual(Integer(sl.Objects[0]), 0, 'First item should have a load order of 0');
      ExpectEqual(Integer(sl.Objects[1]), 1, 'Second item should have a load order of 1');
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    // Test three files
    Describe('Adding three files');
    sl := TStringList.Create;
    try
      f := FileByName(mteTestFile1);
      AddFileToList(f, sl);
      f := FileByIndex(0);
      AddFileToList(f, sl);
      f := FileByName(mteTestFile2);
      AddFileToList(f, sl);
      f := FileByIndex(0);
      ExpectEqual(sl.Count, 3, 'Files list should have 2 items');
      ExpectEqual(sl[0], GetFileName(f), 'First item should be Skyrim.esm');
      ExpectEqual(sl[1], mteTestFile1, 'Second item should be '+mteTestFile1);
      ExpectEqual(sl[2], mteTestFile2, 'Third item should be '+mteTestFile2);
      ExpectEqual(Integer(sl.Objects[0]), 0, 'First item should have a load order of 0');
      ExpectEqual(Integer(sl.Objects[1]), 1, 'Second item should have a load order of 1');
      ExpectEqual(Integer(sl.Objects[2]), 2, 'Third item should have a load order of 2');
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** AddMastersToList Test ***)
  Describe('AddMastersToList');
  try
    // Test with stringlist not assigned
    Describe('Input stringlist not assigned');
    try
      bCaughtException := false;
      sl := nil;
      try
        f := FileByIndex(0);
        AddMastersToList(f, sl, true);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'AddMastersToList: Input TStringList not assigned', 'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with file that has no masters
    Describe('File has no masters');
    sl := TStringList.Create;
    try
      f := nil;
      f := FileByIndex(0);
      AddMastersToList(f, sl, true);
      ExpectEqual(sl.Count, 0, 'Masters list should have 0 items');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    // Test with file that has one master
    Describe('File has one master');
    sl := TStringList.Create;
    try
      f := FileByName(mteTestFile1);
      AddMastersToList(f, sl, true);
      ExpectEqual(sl.Count, 1, 'Masters list should have 1 item');
      ExpectEqual(sl[0], 'Skyrim.esm', 'First item should be Skyrim.esm');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    // Test with file that has two masters
    Describe('File has two masters');
    sl := TStringList.Create;
    try
      f := FileByName(mteTestFile2);
      AddMastersToList(f, sl, true);
      ExpectEqual(sl.Count, 2, 'Masters list should have 2 items');
      ExpectEqual(sl[0], 'Skyrim.esm', 'First item should be Skyrim.esm');
      ExpectEqual(sl[1], mteTestFile1, 'Second item should be '+mteTestFile1);
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    // Test with masters from two files
    Describe('Masters from two files');
    sl := TStringList.Create;
    try
      f := FileByName(mteTestFile1);
      AddMastersToList(f, sl, true);
      f := FileByName(mteTestFile2);
      AddMastersToList(f, sl, true);
      ExpectEqual(sl.Count, 2, 'Masters list should have 2 items');
      ExpectEqual(sl[0], 'Skyrim.esm', 'First item should be Skyrim.esm');
      ExpectEqual(sl[1], mteTestFile1, 'Second item should be '+mteTestFile1);
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    // Test sorted = false
    Describe('Sorted = false');
    sl := TStringList.Create;
    try
      f := FileByName(mteTestFile4);
      AddFileToList(f, sl);
      f := FileByName(mteTestFile2);
      AddMastersToList(f, sl, false);
      ExpectEqual(sl.Count, 3, 'Masters list should have 3 items');
      ExpectEqual(sl[0], mteTestFile4, 'First item should be '+mteTestFile4);
      ExpectEqual(sl[1], 'Skyrim.esm', 'Second item should be Skyrim.esm');
      ExpectEqual(sl[2], mteTestFile1, 'Third item should be '+mteTestFile1);
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** AddMaster ***)
  Describe('AddMaster');
  try
    // Test Master Files element doesn''t exist
    Describe('Master Files element doesn''t exist');
    sl := TStringList.Create;
    try
      f := FileByName(mteTestFile4);
      AddMaster(f, FileByName(mteTestFile2));
      AddMastersToList(f, sl, true);
      ExpectEqual(sl.Count, 1, 'Masters list should have 1 item');
      ExpectEqual(sl[0], mteTestFile2, 'First item should be '+mteTestFile2);
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    // Test with file that doesn't have the master
    Describe('File doesn''t have the master');
    sl := TStringList.Create;
    try
      f := FileByName(mteTestFile4);
      AddMaster(f, FileByName(mteTestFile3));
      AddMastersToList(f, sl, true);
      ExpectEqual(sl.Count, 2, 'Masters list should have 2 items');
      ExpectEqual(sl[0], mteTestFile2, 'First item should be '+mteTestFile2);
      ExpectEqual(sl[1], mteTestFile3, 'Second item should be '+mteTestFile3);
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    // Test with file that already has the master
    Describe('File already has the master');
    sl := TStringList.Create;
    try
      f := FileByName(mteTestFile4);
      AddMaster(f, FileByName(mteTestFile3));
      AddMastersToList(f, sl, true);
      ExpectEqual(sl.Count, 2, 'Masters list should have 3 items');
      ExpectEqual(sl[0], mteTestFile2, 'First item should be '+mteTestFile2);
      ExpectEqual(sl[1], mteTestFile3, 'Second item should be '+mteTestFile3);
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    // Test with file that has a master at a higher load order
    Describe('File has a master at a higher load order');
    sl := TStringList.Create;
    try
      f := FileByName(mteTestFile4);
      AddMaster(f, FileByIndex(0));
      AddMastersToList(f, sl, true);
      ExpectEqual(sl.Count, 3, 'Masters list should have 4 items');
      ExpectEqual(sl[0], 'Skyrim.esm', 'First item should be Skyrim.esm');
      ExpectEqual(sl[1], mteTestFile2, 'Second item should be '+mteTestFile2);
      ExpectEqual(sl[2], mteTestFile3, 'Third item should be '+mteTestFile3);
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    
    // clean up
    RemoveMasters(mteTestFile4);
    
    // all tests passed
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** AddMastersToFile Test ***)
  Describe('AddMastersToFile');
  try
    // Test with input file not assigned
    Describe('Input file not assigned');
    try
      bCaughtException := false;
      try
        f := nil;
        AddMastersToFile(f, sl);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'AddMastersToFile: Input file not assigned', 'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with stringlist not assigned
    Describe('Input stringlist not assigned');
    try
      bCaughtException := false;
      sl := nil;
      try
        f := FileByIndex(0);
        AddMastersToFile(f, sl);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'AddMastersToFile: Input TStringList not assigned', 'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with file that already had the masters
    Describe('File already has masters');
    sl := TStringList.Create;
    sl2 := TStringList.Create;
    try
      f := FileByName(mteTestFile2);
      AddMastersToList(f, sl, true);
      AddMastersToFile(f, sl);
      AddMastersToList(f, sl2, true);
      ExpectEqual(sl.CommaText, sl2.CommaText, 'Masters should not be changed');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    sl2.Free;
    
    // Test with file that has no masters
    Describe('File has no masters');
    sl := TStringList.Create;
    sl2 := TStringList.Create;
    try
      f := FileByName(mteTestFile2);
      AddMastersToList(f, sl, true);
      f := FileByName(mteTestFile3);
      AddMastersToFile(f, sl);
      AddMastersToList(f, sl2, true);
      ExpectEqual(sl.CommaText, sl2.CommaText, 'Masters should be added correctly');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    sl2.Free;
    
    // Test with file that has had masters added in same session
    Describe('File has had masters added in same session');
    sl := TStringList.Create;
    sl2 := TStringList.Create;
    try
      f := FileByName(mteTestFile2);
      AddMastersToList(f, sl, true);
      f := FileByName(mteTestFile3);
      AddMastersToFile(f, sl);
      AddMastersToList(f, sl2, true);
      ExpectEqual(sl.CommaText, sl2.CommaText, 'Masters should be the same');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    sl2.Free;
    
    // Test with file that has had masters manually removed
    Describe('File has had masters manually removed');
    sl := TStringList.Create;
    sl2 := TStringList.Create;
    f := nil;
    try
      f := FileByName(mteTestFile2);
      AddMastersToList(f, sl, true);
      f := FileByName(mteTestFile3);
      fileHeader := GetFileHeader(f);
      Remove(ElementByPath(fileHeader, 'Master Files'));
      f := FileByName(mteTestFile3);
      AddMastersToFile(f, sl);
      f := FileByName(mteTestFile3);
      AddMastersToList(f, sl2, true);
      ExpectEqual(sl.CommaText, sl2.CommaText, 'Masters should be added correctly');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    sl2.Free;
    
    // Test with file that has had masters manually removed and re-added in the same session
    Describe('File has had masters manually removed and re-added');
    sl := TStringList.Create;
    sl2 := TStringList.Create;
    f := nil;
    try
      f := FileByName(mteTestFile2);
      AddMastersToList(f, sl, true);
      f := FileByName(mteTestFile3);
      fileHeader := GetFileHeader(f);
      AddMastersToFile(f, sl);
      AddMastersToList(f, sl2, true);
      ExpectEqual(sl.CommaText, sl2.CommaText, 'Masters should be the same');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    sl2.Free;
    
    // Test adding masters out of order
    Describe('Adding masters out of order');
    sl := TStringList.Create;
    sl2 := TStringList.Create;
    f := nil;
    try
      // construct initial list of masters
      // * Skyrim.esm
      // * TestMTE-1.esp
      // * TestMTE-3.esp
      f := FileByIndex(0);
      AddFileToList(f, sl);
      f := FileByName(mteTestFile1);
      AddFileToList(f, sl);
      f := FileByName(mteTestFile3);
      AddFileToList(f, sl);
      f := FileByName(mteTestFile4);
      // add initial masters to file
      AddMastersToFile(f, sl);
      
      // add TestMTE-2.esp to masters list
      f := FileByName(mteTestFile2);
      AddFileToList(f, sl);
      ExpectEqual(sl.CommaText, 'Skyrim.esm'#44'TestMTE-1.esp'#44'TestMTE-2.esp'#44
        'TestMTE-3.esp', 'Should have the masters in the list in the correct order');
      
      // add masters to TestMTE-4.esp
      f := FileByName(mteTestFile4);
      AddMastersToFile(f, sl);
      
      // get actual order of masters on TestMTE-4.esp
      AddMastersToList(f, sl2, false);
      ExpectEqual(sl.CommaText, sl2.CommaText, 'Masters on the file should be ordered correctly');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    sl2.Free;
    
    // clean up
    RemoveMasters(mteTestFile3);
    RemoveMasters(mteTestFile4);
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** RemoveMaster Test ***)
  Describe('RemoveMaster');
  try
    // Test Master Files element doesn''t exist
    Describe('Master Files element doesn''t exist');
    try
      f := FileByName(mteTestFile3);
      RemoveMaster(f, mteTestFile2);
      Expect(true, 'Should not throw an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test master not present
    Describe('Master not present');
    sl := TStringList.Create;
    sl2 := TStringList.Create;
    try
      f := FileByName(mteTestFile2);
      AddMastersToList(f, sl, true);
      RemoveMaster(f, mteTestFile2);
      AddMastersToList(f, sl2, true);
      ExpectEqual(sl.CommaText, sl2.CommaText, 'Should not change the file''s masters');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    sl2.Free;
    
    // Test master present
    Describe('Master present');
    sl := TStringList.Create;
    sl2 := TStringList.Create;
    try
      f := FileByName(mteTestFile2);
      AddMastersToList(f, sl, true);
      RemoveMaster(f, mteTestFile1);
      AddMastersToList(f, sl2, true);
      AddMaster(f, FileByName(mteTestFile1));
      ExpectEqual(sl2.Count, 1, 'Should only have one master now');
      ExpectEqual(sl2[0], 'Skyrim.esm', 'First master should be Skyrim.esm');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    sl.Free;
    sl2.Free;
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** RemoveMaster Test ***)
  Describe('AddLoadedFilesAsMasters');
  try
    // Test with input file not assigned
    Describe('Input file not assigned');
    try
      bCaughtException := false;
      try
        f := nil;
        AddLoadedFilesAsMasters(f);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'AddLoadedFilesAsMasters: Input file not assigned', 'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
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
  TestMteFiles;
  
  // finalize jvt
  jvtPrintReport;
  jvtFinalize;
end;

end.