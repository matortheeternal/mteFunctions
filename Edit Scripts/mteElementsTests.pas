{
  mteElements Tests
  Tests for functions in mteElements
}

unit mteElementsTests;

uses 'lib\mteBase', 'lib\mteFiles', 'lib\mteTypes', 'lib\jvTest';

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
    raise Exception.Create('mteElementsTests - These tests are meant to be '+
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

procedure TestFlagHelpers;
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

procedure TestTypeHelpers;
begin
  (*** etToString Tests ***)
  Describe('etToString');
  try
    ExpectEqual(etToString(etFile), 'etFile', 'etFile should return "etFile"');
    ExpectEqual(etToString(etSubRecordUnion), 'etSubRecordUnion', 
      'etSubRecordUnion should return "etSubRecordUnion"');
    ExpectEqual(etToString(etUnion), 'etUnion', 'etUnion should return "etUnion"');
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** dtToString Tests ***)
  Describe('dtToString');
  try
    ExpectEqual(dtToString(dtRecord), 'dtRecord', 'dtRecord should return "dtRecord"');
    ExpectEqual(dtToString(dtByteArray), 'dtByteArray', 'dtByteArray should return "dtByteArray"');
    ExpectEqual(dtToString(dtEmpty), 'dtEmpty', 'dtEmpty should return "dtEmpty"');
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** ctToString Tests ***)
  Describe('ctToString');
  try
    ExpectEqual(ctToString(ctUnknown), 'ctUnknown', 'ctUnknown should return "ctUnknown"');
    ExpectEqual(ctToString(ctMaster), 'ctMaster', 'ctMaster should return "ctMaster"');
    ExpectEqual(ctToString(ctConflictLoses), 'ctConflictLoses', 
      'ctConflictLoses should return "ctConflictLoses"');
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** caToString Tests ***)
  Describe('caToString');
  try
    ExpectEqual(caToString(caUnknown), 'caUnknown', 'caUnknown should return "caUnknown"');
    ExpectEqual(caToString(caNoConflict), 'caNoConflict', 'caNoConflict should return "caNoConflict"');
    ExpectEqual(caToString(caConflictCritical), 'caConflictCritical', 'caConflictCritical should return "caConflictCritical"');
    Pass;
  except
    on x: Exception do Fail(x);
  end;
end;

procedure TestElementHelpers;
var
  bCaughtException: boolean;
  fileHeader, f, rec, rec2, element: IInterface;
  iRestore, iActual, iMaxIndex: Integer;
  sRestore, sActual: string;
  lst: TList;
  sl, sl2: TStringList;
begin
  (*** ConflictThis Tests ***)
  Describe('ConflictThis');
  try
    Describe('Input element not assigned');
    try
      bCaughtException := false;
      try
        f := nil;
        ConflictThis(f);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'ConflictThis: Input element is not assigned', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('etFile');
    try
      bCaughtException := false;
      try
        f := FileByIndex(0);
        ConflictThis(f);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'ConflictThis: etFile does not have a ConflictThis', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('etMainRecord');
    try
      f := FileByName(mteTestFile1);
      // test with a losing override record
      rec := RecordByIndex(f, 0);
      sActual := ctToString(ConflictThis(rec));
      ExpectEqual(sActual, 'ctConflictLoses', 'Should return ctConflictLoses for a losing override record');
      
      // test with an ITM record
      rec := RecordByIndex(f, 1);
      sActual := ctToString(ConflictThis(rec));
      ExpectEqual(sActual, 'ctIdenticalToMaster', 'Should return ctIdenticalToMaster for an ITM record');
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('etGroupRecord');
    try
      bCaughtException := false;
      try
        f := FileByIndex(0);
        ConflictThis(GroupBySignature(f, 'ARMO'));
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'ConflictThis: etGroupRecord does not have a ConflictThis', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('etSubrecord');
    try
      f := FileByName(mteTestFile1);
      // test with a losing element
      rec := RecordByIndex(f, 0);
      JumpTo(rec, false);
      element := ElementByPath(rec, 'DATA');
      sActual := ctToString(ConflictThis(element));
      ExpectEqual(sActual, 'ctConflictLoses', 
        'Should return ctConflictLoses for an element in a losing override record');
      
      // test with an itm element
      rec := RecordByIndex(f, 1);
      JumpTo(rec, false);
      element := ElementByPath(rec, 'ZNAM');
      sActual := ctToString(ConflictThis(element));
      ExpectEqual(sActual, 'ctIdenticalToMaster', 
        'Should return ctIdenticalToMaster for an element in an ITM record');
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** ConflictAll Tests ***)
  Describe('ConflictAll');
  try
    Describe('Input element not assigned');
    try
      bCaughtException := false;
      try
        f := nil;
        ConflictAll(f);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'ConflictAll: Input element is not assigned', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('etFile');
    try
      bCaughtException := false;
      try
        f := FileByIndex(0);
        ConflictAll(f);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'ConflictAll: etFile does not have a ConflictAll', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('etMainRecord');
    try
      f := FileByName(mteTestFile1);
      // test with a losing override record
      rec := RecordByIndex(f, 0);
      sActual := caToString(ConflictAll(rec));
      ExpectEqual(sActual, 'caConflict', 'Should return caConflict for a losing override record');
      
      // test with an ITM record
      rec := RecordByIndex(f, 1);
      sActual := caToString(ConflictAll(rec));
      ExpectEqual(sActual, 'caNoConflict', 'Should return caNoConflict for an ITM record');
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('etGroupRecord');
    try
      bCaughtException := false;
      try
        f := FileByIndex(0);
        ConflictAll(GroupBySignature(f, 'ARMO'));
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'ConflictAll: etGroupRecord does not have a ConflictAll', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('etSubrecord');
    try
      f := FileByName(mteTestFile1);
      // test with a losing element
      rec := RecordByIndex(f, 0);
      JumpTo(rec, true);
      element := ElementByName(rec, 'DATA - Weight');
      sActual := caToString(ConflictAll(element));
      ExpectEqual(sActual, 'caConflict', 'Should return caConflict for an element in a losing override record');
      
      // test with an itm element
      rec := RecordByIndex(f, 1);
      JumpTo(rec, false);
      element := ElementByName(rec, 'ZNAM - Sound - Drop');
      sActual := caToString(ConflictAll(element));
      ExpectEqual(sActual, 'caNoConflict', 'Should return caNoConflict for an element in an ITM record');
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** ElementPath Tests ***)
  Describe('ElementPath');
  try
    // Test with etFile
    Describe('etFile');
    try
      bCaughtException := false;
      try
        f := FileByIndex(0);
        ElementPath(f);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'ElementPath: Cannot call ElementPath on a file', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with etMainRecord
    Describe('etMainRecord');
    try
      bCaughtException := false;
      try
        f := FileByName(mteTestFile1);
        rec := RecordByIndex(f, 0);
        ElementPath(rec);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'ElementPath: Cannot call ElementPath on a main record', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with etGroupRecord
    Describe('etGroupRecord');
    try
      bCaughtException := false;
      try
        f := FileByIndex(0);
        ElementPath(GroupBySignature(f, 'ARMO'));
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'ElementPath: Cannot call ElementPath on a group record', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with etSubrecord
    Describe('etSubrecord');
    try
      f := FileByName(mteTestFile1);
      // test with a top level element
      rec := RecordByIndex(f, 0);
      element := ElementByName(rec, 'DATA - Weight');
      sActual := ElementPath(element);
      ExpectEqual(sActual, 'DATA - Weight', 'Should return the correct path for a top level element');
      
      // test with a second level element
      element := ElementByPath(rec, 'ENIT\Value');
      sActual := ElementPath(element);
      ExpectEqual(sActual, 'ENIT - Effect Data\Value', 
        'Should return the correct path for a second level element');
      
      // test with a array element
      element := ElementByPath(rec, 'Effects');
      element := ElementByIndex(element, 2);
      sActual := ElementPath(element);
      ExpectEqual(sActual, 'Effects\Effect', 'Should return the correct path for an array element');
      
      // test with an element in an array element
      element := ElementByPath(rec, 'Effects');
      element := ElementByIndex(element, 1);
      element := ElementByPath(element, 'EFIT - \Magnitude');
      sActual := ElementPath(element);
      ExpectEqual(sActual, 'Effects\Effect\EFIT - \Magnitude', 
        'Should return the correct path for an element in an array element');
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
  
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** IndexedPath Tests ***)
  Describe('IndexedPath');
  try
    // Test with etFile
    Describe('etFile');
    try
      bCaughtException := false;
      try
        f := FileByIndex(0);
        IndexedPath(f);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'IndexedPath: Cannot call IndexedPath on a file', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with etMainRecord
    Describe('etMainRecord');
    try
      bCaughtException := false;
      try
        f := FileByName(mteTestFile1);
        rec := RecordByIndex(f, 0);
        IndexedPath(rec);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'IndexedPath: Cannot call IndexedPath on a main record', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with etGroupRecord
    Describe('etGroupRecord');
    try
      bCaughtException := false;
      try
        f := FileByIndex(0);
        IndexedPath(GroupBySignature(f, 'ARMO'));
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'IndexedPath: Cannot call IndexedPath on a group record', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with etSubrecord
    Describe('etSubrecord');
    try
      f := FileByName(mteTestFile1);
      // test with a top level element
      rec := RecordByIndex(f, 0);
      element := ElementByName(rec, 'DATA - Weight');
      sActual := IndexedPath(element);
      ExpectEqual(sActual, 'DATA - Weight', 'Should return the correct path for a top level element');
      
      // test with a second level element
      element := ElementByPath(rec, 'ENIT\Value');
      sActual := IndexedPath(element);
      ExpectEqual(sActual, 'ENIT - Effect Data\Value', 
        'Should return the correct path for a second level element');
      
      // test with an array element
      element := ElementByPath(rec, 'Effects');
      element := ElementByIndex(element, 0);
      sActual := IndexedPath(element);
      ExpectEqual(sActual, 'Effects\[0]', 'Should return the correct path for an array element');
      
      // test with an element in an array element
      element := ElementByPath(rec, 'Effects');
      element := ElementByIndex(element, 1);
      element := ElementByPath(element, 'EFIT - \Magnitude');
      sActual := IndexedPath(element);
      ExpectEqual(sActual, 'Effects\[1]\EFIT - \Magnitude', 
        'Should return the correct path for an element in an array element');
      
      Pass;
    except
      on x: Exception do Fail(x);
    end;
  
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** MoveElementToIndex Tests ***)
  Describe('MoveElementToIndex');
  try
    // Test with etFile
    Describe('etFile');
    try
      bCaughtException := false;
      try
        f := FileByIndex(0);
        MoveElementToIndex(f, 2);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'MoveElementToIndex: Cannot call MoveElementToIndex on a file', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with etMainRecord
    Describe('etMainRecord');
    try
      bCaughtException := false;
      try
        f := FileByName(mteTestFile1);
        rec := RecordByIndex(f, 0);
        MoveElementToIndex(rec, 6);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'MoveElementToIndex: Cannot call MoveElementToIndex on a main record', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with etGroupRecord
    Describe('etGroupRecord');
    try
      bCaughtException := false;
      try
        f := FileByIndex(0);
        MoveElementToIndex(GroupBySignature(f, 'ARMO'), 10);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'MoveElementToIndex: Cannot call MoveElementToIndex on a group record', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // setup for etSubrecord
    rec := RecordByFormID(FileByIndex(0), $0010FDE9, false);
    rec := wbCopyElementToFile(rec, FileByName(mteTestFile1), false, true);
    rec2 := RecordByFormID(FileByIndex(0), $000167D9, false);
    rec2 := wbCopyElementToFile(rec2, FileByName(mteTestFile1), false, true);
    
    // Test with a subrecord that cannot be moved
    Describe('etSubrecord that cannot be moved');
    try
      element := ElementByPath(rec, 'EDID');
      MoveElementToIndex(element, 2);
      Expect(true, 'Should not throw an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with a subrecord in a sorted array
    Describe('etSubrecord in a sorted array');
    try
      element := ElementByPath(rec, 'Leveled List Entries');
      element := ElementByIndex(element, 1);
      MoveElementToIndex(element, 2);
      ExpectEqual(IndexOf(GetContainer(element), element), 1, 'Should not move the element');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with a subrecord in an unsorted array
    Describe('etSubrecord in an unsorted array');
    try
      element := ElementByPath(rec2, 'FormIDs');
      iMaxIndex := ElementCount(element) - 1;
      element := ElementByIndex(element, 2);
      MoveElementToIndex(element, 6);
      ExpectEqual(IndexOf(GetContainer(element), element), 6, 'Should move the element to index 6');
      MoveElementToIndex(element, 0);
      ExpectEqual(IndexOf(GetContainer(element), element), 0, 'Should move the element to index 0');
      MoveElementToIndex(element, iMaxIndex);
      ExpectEqual(IndexOf(GetContainer(element), element), iMaxIndex, 
        'Should move the element to index '+IntToStr(iMaxIndex));
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with an index out of bounds
    Describe('Index out of bounds');
    try
      element := ElementByPath(rec2, 'FormIDs');
      iMaxIndex := ElementCount(element) - 1;
      element := ElementByIndex(element, 2);
      MoveElementToIndex(element, -20);
      ExpectEqual(IndexOf(GetContainer(element), element), 0, 
        'Index < MinIndex: Should move the element to index MinIndex');
      MoveElementToIndex(element, iMaxIndex + 20);
      ExpectEqual(IndexOf(GetContainer(element), element), iMaxIndex, 
        'Index > MaxIndex: Should move the element to index MaxIndex');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // clean up
    f := FileByName(mteTestFile1);
    Remove(GroupBySignature(f, 'LVLI'));
    Remove(GroupBySignature(f, 'FLST'));
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
end;

procedure TestElementGetters;
var
  f, rec, e: IInterface;
  bCaughtException: Boolean;
begin
  (*** ElementByIP Tests ***)
  Describe('ElementByIP');
  try
    Describe('Input element not assigned');
    try
      bCaughtException := false;
      try
        ElementByIP(e, 'Fake/Path');
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'ElementByIP: Input element not assigned', 
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // assign some variables
    f := FileByName(mteTestFile1);
    rec := RecordByIndex(f, 1);
    
    Describe('Input path blank');
    try
      e := ElementByIP(rec, '');
      Expect(Equals(rec, e), 'Should return the input element');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Invalid path');
    try
      e := ElementByIP(rec, 'Nonexisting\Path');
      Expect(not Assigned(e), 'No indexes: Should return nil');
      e := ElementByIP(rec, '[99]');
      Expect(not Assigned(e), 'With indexes: Should return nil');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Valid path');
    try
      e := ElementByIP(rec, 'EDID');
      ExpectEqual(GetEditValue(e), 'FoodBlackBriarMead', 'No indexes: Should return the correct element');
      e := ElementByIP(rec, '[1]');
      ExpectEqual(GetEditValue(e), 'FoodBlackBriarMead', 'With indexes: Should return the correct element');
      e := ElementByIP(rec, 'Effects\[1]\[1]\Magnitude');
      ExpectEqual(GetEditValue(e), '40.000000', 'Multi-part path: Should return the correct element');
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

{ 
  TestMteElements:
  Tests the functions in mteElements using the jvTest framework.
}
procedure TestMteElements;
begin
  Describe('Type Helpers');
  try
    TestTypeHelpers;
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  Describe('Element Helpers');
  try
    TestElementHelpers;
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  Describe('Element Getters');
  try
    TestElementGetters;
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  Describe('Flag Helpers');
  try
    TestFlagHelpers;
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
  TestMteElements;
  
  // finalize jvt
  jvtPrintReport;
  jvtFinalize;
end;

end.