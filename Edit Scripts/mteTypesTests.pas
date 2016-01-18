{
  mteTypes Tests
  Tests for functions in mteTypes
}

unit mteTypesTests;

uses 'lib\mteTypes', 'lib\jvTest';

const
  mteTestVersion = '0.0.0.1';

{
  mteVersionTest:
  Raises an exception if the testing suite is not built to target the 
  version of mteFunctions the user is running.
}
procedure mteVersionTest;
begin
  if mteVersion <> mteTestVersion then
    raise Exception.Create('mteTypesTests - These tests are meant to be '+
      'run on mteFunctions v'+mteTestVersion+', you are running '+
      mteVersion+'.  Testing terminated.');
end;

{
  TestBooleanHelpers:
  Tests the boolean helper functions in mteTypes.
}
procedure TestBooleanHelpers;
begin
  (*** IfThenVar Tests ***)
  Describe('IfThenVar');
  try
    Describe('nil values');
    try
      ExpectEqual(IfThenVar(true, nil, nil), nil, 'ATrue: Should return properly');
      ExpectEqual(IfThenVar(false, nil, nil), nil, 'AFalse: Should return properly');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Integer values');
    try
      ExpectEqual(IfThenVar(true, 1, 0), 1, 'ATrue: Should return properly');
      ExpectEqual(IfThenVar(false, 1, 0), 0, 'AFalse: Should return properly');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Floating point values');
    try
      ExpectEqual(IfThenVar(true, 1.0, 0.5), 1.0, 'ATrue: Should return properly');
      ExpectEqual(IfThenVar(false, 1.0, 0.5), 0.5, 'AFalse: Should return properly');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('String values');
    try
      ExpectEqual(IfThenVar(true, 'True', 'False'), 'True', 'ATrue: Should return properly');
      ExpectEqual(IfThenVar(false, 'True', 'False'), 'False', 'AFalse: Should return properly');
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
  TestIntegerHelpers:
  Tests the integer helper functions in mteTypes.
}
procedure TestIntegerHelpers;
var
  bCaughtException: boolean;
begin
  (*** IntLog Tests ***)
  Describe('IntLog');
  try
    Describe('Base 0');
    try
      bCaughtException := false;
      try
        IntLog(2, 0);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'IntLog: Base cannot be less than or equal to 1',
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Value 0');
    try
      ExpectEqual(IntLog(0, 2), 0, 'Should return 0');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Base 1');
    try
      bCaughtException := false;
      try
        IntLog(4, 1);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'IntLog: Base cannot be less than or equal to 1',
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Negative Base');
    try
      bCaughtException := false;
      try
        IntLog(4, -2);
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'IntLog: Base cannot be less than or equal to 1',
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Positive Base');
    try
      ExpectEqual(IntLog(2, 2), 1, 'Should handle equality');
      ExpectEqual(IntLog(4, 2), 2, 'Should handle perfect logarithms correctly');
      ExpectEqual(IntLog(257, 2), 8, 'Should ignore small remainders correctly');
      ExpectEqual(IntLog(255, 2), 7, 'Should ignore large remainders correctly');
      ExpectEqual(IntLog(IntPower(1024, 3), 1024), 3, 'Should handle large values correctly');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  
  (*** FormatFileSize Tests ***)
  Describe('FormatFileSize');
  try
    Describe('Zero');
    try
      ExpectEqual(FormatFileSize(0), '0 bytes', 'Should return "0 bytes"');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Bytes');
    try
      ExpectEqual(FormatFileSize(-1), '-1 bytes', 'Lowest negative value should be -1 bytes');
      ExpectEqual(FormatFileSize(1), '1 bytes', 'Lowest positive value should be 1 bytes');
      ExpectEqual(FormatFileSize(1023), '1023 bytes', 'Upper limit should be 1023 bytes');
      ExpectEqual(FormatFileSize(-1023), '-1023 bytes', 'Lower limit should be -1023 bytes');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Kilobytes');
    try
      ExpectEqual(FormatFileSize(-1024), '-1.00 KB', '-1024 bytes should equal -1.00 KB');
      ExpectEqual(FormatFileSize(1024), '1.00 KB', '1024 bytes should equal 1.00 KB');
      ExpectEqual(FormatFileSize(1024 * 1024 - 1), '1024.00 KB', 'Upper limit should be 1024.00 KB');
      ExpectEqual(FormatFileSize(-1024 * 1024 + 1), '-1024.00 KB', 'Lower limit should be -1024.00 KB');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Megabytes');
    try
      ExpectEqual(FormatFileSize(-1048576), '-1.00 MB', '-1048576 bytes should equal -1.00 MB');
      ExpectEqual(FormatFileSize(1048576), '1.00 MB', '1048576 bytes should equal 1.00 MB');
      ExpectEqual(FormatFileSize(1024 * 1048576 - 1), '1024.00 MB', 'Upper limit should be 1024.00 MB');
      ExpectEqual(FormatFileSize(-1024 * 1048576 + 1), '-1024.00 MB', 'Lower limit should be -1024.00 MB');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    Describe('Gigabytes');
    try
      ExpectEqual(FormatFileSize(-1073741824), '-1.00 GB', '-1073741824 bytes should equal -1.00 GB');
      ExpectEqual(FormatFileSize(1073741824), '1.00 GB', '1073741824 bytes should equal 1.00 GB');
      ExpectEqual(FormatFileSize(2147483647), '2.00 GB', 'Upper limit should be 2.00 GB');
      ExpectEqual(FormatFileSize(-2147483647), '-2.00 GB', 'Lower limit should be -2.00 GB');
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
  TestMteTypes:
  Tests the functions in mteTypes using the jvTest framework.
}
procedure TestMteTypes;
begin
  Describe('Boolean Helpers');
  try
    TestBooleanHelpers;
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  Describe('Integer Helpers');
  try
    TestIntegerHelpers;
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
  // don't perform tests if on wrong version
  mteVersionTest;
  
  jvtInitialize;
  // perform tests
  TestMteTypes;
  
  // finalize jvt
  jvtPrintReport;
  jvtFinalize;
end;

end.