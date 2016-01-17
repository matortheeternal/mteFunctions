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
var
  bCaughtException: boolean;
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