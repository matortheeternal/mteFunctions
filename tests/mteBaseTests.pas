{
  mteBase Tests
  Tests for functions in mteBase
}

unit mteBaseTests;

uses 'lib\mteBase', 'lib\jvTest';

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
    raise Exception.Create('mteBaseTests - These tests are meant to be '+
      'run on mteFunctions v'+mteTestVersion+', you are running '+
      mteVersion+'.  Testing terminated.');
end;

{ 
  TestMteBase:
  Tests the functions in mteBase using the jvTest
  framework.
}
procedure TestMteBase;
var
  bCaughtException: boolean;
  xEditVersion: string;
begin
  (*** VersionCompare Tests ***)
  Describe('VersionCompare');
  try
    // Test with an empty string
    Describe('Empty string input for version');
    try
      bCaughtException := false;
      try
        VersionCompare('0', '');
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'VersionCompare: Version is empty string',
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except 
      on x: Exception do Fail(x);
    end;
    
    // Test with non-numeric characters
    Describe('Non-numeric version');
    try
      bCaughtException := false;
      try
        VersionCompare('0.1a', '0.2');
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, '''''1a'''' is not a valid integer value',
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except 
      on x: Exception do Fail(x);
    end;
  
    // Test with equal versions
    Describe('Equal versions');
    try
      bCaughtException := false;
      ExpectEqual(VersionCompare('62', '62'), 0, '1 clause version: Should return 0');
      ExpectEqual(VersionCompare('0.1.2.3', '0.1.2.3'), 0, '4 clause version: Should return 0');
      ExpectEqual(VersionCompare('0.1.2.3.4.5.6.7.8.9', '0.1.2.3.4.5.6.7.8.9'), 0, '10 clause version: Should return 0');
      Pass;
    except 
      on x: Exception do Fail(x);
    end;
    
    // Test with second version newer than first
    Describe('Second version newer than first');
    try
      bCaughtException := false;
      ExpectEqual(VersionCompare('0.1.2.3', '0.1.2.4'), 1, 'Difference in first clause from right should return 1');
      ExpectEqual(VersionCompare('0.1.2.3', '0.1.3.3'), 2, 'Difference in second clause from right should return 2');
      ExpectEqual(VersionCompare('0.1.2.3', '0.2.2.3'), 3, 'Difference in third clause from right should return 3');
      ExpectEqual(VersionCompare('0.1.2.3', '1.1.2.3'), 4, 'Difference in fourth clause from right should return 4');
      Pass;
    except 
      on x: Exception do Fail(x);
    end;
    
    // Test with second version older than first
    Describe('Second version older than first');
    try
      bCaughtException := false;
      ExpectEqual(VersionCompare('0.1.2.4', '0.1.2.3'), -1, 'Difference in first clause from right should return -1');
      ExpectEqual(VersionCompare('0.1.3.3', '0.1.2.3'), -2, 'Difference in second clause from right should return -2');
      ExpectEqual(VersionCompare('0.2.2.3', '0.1.2.3'), -3, 'Difference in third clause from right should return -3');
      ExpectEqual(VersionCompare('1.1.2.3', '0.1.2.3'), -4, 'Difference in fourth clause from right should return -4');
      Pass;
    except 
      on x: Exception do Fail(x);
    end;
    
    // All tests passed?
    Pass;
  except 
    on x: Exception do Fail(x);
  end;

  (*** VersionToString Tests ***)
  Describe('VersionToString');
  try
    // Test with version = 0
    Describe('Version = 0');
    try
      ExpectEqual(VersionToString(0), '0.0.0', 'Should return 0.0.0');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with build = 255
    Describe('Version = 255');
    try
      ExpectEqual(VersionToString(255), '0.0.0', 'Should return 0.0.0');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with version = $FFFFFFFF
    Describe('Version = $FFFFFFFF');
    try
      ExpectEqual(VersionToString($FFFFFFFF), '255.255.255', 'Should return 255.255.255');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with version = $FF804020
    Describe('Version = $FF804020');
    try
      ExpectEqual(VersionToString($FF804020), '255.128.64', 'Should return 255.128.64');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
  
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** VersionToString Tests ***)
  Describe('xEditVersionCheck');
  try
    // Test with empty version
    Describe('Empty string input for version');
    try
      bCaughtException := false;
      try
        xEditVersionCheck('', '255.0.0');
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'VersionCompare: Version is empty string',
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except 
      on x: Exception do Fail(x);
    end;
    
    // Test with version with invalid number of clauses
    Describe('Invalid number of clauses');
    try
      bCaughtException := false;
      try
        xEditVersionCheck('3.0.1.1', '255.255.255.0');
      except
        on x: Exception do begin
          bCaughtException := true;
          ExpectEqual(x.Message, 'VersionCompare: Versions have a different number of version clauses',
            'Should raise the correct exception');
        end;
      end;
      Expect(bCaughtException, 'Should have raised an exception');
      Pass;
    except 
      on x: Exception do Fail(x);
    end;
    
    // Test with minVersion = xEditVersion = maxVersion
    Describe('minVersion = xEditVersion = maxVersion');
    try
      xEditVersion := VersionToString(wbVersionNumber);
      ExpectEqual(xEditVersionCheck(xEditVersion, xEditVersion), true, 'Should return true');
      Pass;
    except 
      on x: Exception do Fail(x);
    end;
    
    // Test with minVersion > xEditVersion
    Describe('minVersion > xEditVersion');
    try
      xEditVersion := VersionToString(wbVersionNumber);
      ExpectEqual(xEditVersionCheck(VersionToString(wbVersionNumber + $100), xEditVersion), false, 'Should return false');
      Pass;
    except 
      on x: Exception do Fail(x);
    end;
    
    // Test with maxVersion < xEditVersion
    Describe('maxVersion < xEditVersion');
    try
      xEditVersion := VersionToString(wbVersionNumber);
      ExpectEqual(xEditVersionCheck(xEditVersion, VersionToString(wbVersionNumber - $100)), false, 'Should return false');
      Pass;
    except 
      on x: Exception do Fail(x);
    end;
    
    // Test with maxVersion < xEditVersion
    Describe('minVersion > xEditVersion > maxVersion');
    try
      ExpectEqual(xEditVersionCheck(VersionToString(wbVersionNumber - $200), 
        VersionToString(wbVersionNumber + $200)), true, 'Should return true');
      Pass;
    except 
      on x: Exception do Fail(x);
    end;
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** xEditGameCheck ***)
  Describe('xEditGameCheck');
  try
    // No supported games
    Describe('No supported games');
    try
      Expect(not xEditGameCheck(''), 'Should return false');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Only current game mode supported
    Describe('Only current game mode supported');
    try
      Expect(xEditGameCheck(wbAppName), 'Should return true');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Other game modes supported
    Describe('Other game modes supported');
    try
      Expect(xEditGameCheck('Example,'+wbAppName), 'Should return true');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Other game modes supported
    Describe('Game modes supported, but not current game mode');
    try
      Expect(not xEditGameCheck(wbAppName+'1,2'+wbAppName), 'Should return false');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** VersionCheck ***)
  Describe('VersionCheck');
  try
    // same versions
    Describe('Equal versions');
    try
      ExpectEqual(VersionCheck('2', '2'), vcEqual, '1 clause version: Should return vcEqual');
      ExpectEqual(VersionCheck('0.1.2.3', '0.1.2.3'), vcEqual, '4 clause version: Should return vcEqual');
      ExpectEqual(VersionCheck('0.1.2.3.4.5.6.7.8.9', '0.1.2.3.4.5.6.7.8.9'), vcEqual, '10 clause version: Should return vcEqual');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with second version newer than first
    Describe('Second version newer than first');
    try
      ExpectEqual(VersionCheck('2', '3'), vcNewer, '1 clause version: Should return vcNewer');
      ExpectEqual(VersionCheck('0.1.2.3', '0.1.2.4'), vcNewer, '4 clause version: Difference in first clause should return vcNewer');
      ExpectEqual(VersionCheck('0.1.2.3', '0.1.3.3'), vcNewer, '4 clause version: Difference in second clause should return vcNewer');
      ExpectEqual(VersionCheck('0.1.2.3', '0.2.2.3'), vcNewerBroken, '4 clause version: Difference in third clause should return vcNewerBroke');
      ExpectEqual(VersionCheck('0.1.2.3', '1.1.2.3'), vcNewerBroken, '4 clause version: Difference in fourth clause should return vcNewerBroke');
      ExpectEqual(VersionCheck('0.1.2.3.4.5.6.7.8.9', '0.1.2.3.4.5.6.7.8.10'), vcNewer, 
        '10 clause version: Difference in first clause should return vcNewer');
      ExpectEqual(VersionCheck('0.1.2.3.4.5.6.7.8.9', '0.1.2.3.4.5.6.8.8.9'), vcNewerBroken, 
        '10 clause version: Difference in third clause should return vcNewerBroke');
      ExpectEqual(VersionCheck('0.1.2.3.4.5.6.7.8.9', '1.1.2.3.4.5.6.7.8.9'), vcNewerBroken, 
        '10 clause version: Difference in tenth clause should return vcNewerBroke');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with second version newer than first
    Describe('Second version older than first');
    try
      ExpectEqual(VersionCheck('3', '2'), vcOlder, '1 clause version: Should return vcOlder');
      ExpectEqual(VersionCheck('0.1.2.4', '0.1.2.3'), vcOlder, '4 clause version: Difference in first clause should return vcOlder');
      ExpectEqual(VersionCheck('0.1.3.3', '0.1.2.3'), vcOlder, '4 clause version: Difference in second clause should return vcOlder');
      ExpectEqual(VersionCheck('0.2.2.3', '0.1.2.3'), vcOlderBroken, '4 clause version: Difference in third clause should return vcOlderBroke');
      ExpectEqual(VersionCheck('1.1.2.3', '0.1.2.3'), vcOlderBroken, '4 clause version: Difference in fourth clause should return vcOlderBroke');
      ExpectEqual(VersionCheck('0.1.2.3.4.5.6.7.8.10', '0.1.2.3.4.5.6.7.8.9'), vcOlder, 
        '10 clause version: Difference in first clause should return vcOlder');
      ExpectEqual(VersionCheck('0.1.2.3.4.5.6.8.8.9', '0.1.2.3.4.5.6.7.8.9'), vcOlderBroken, 
        '10 clause version: Difference in third clause should return vcOlderBroke');
      ExpectEqual(VersionCheck('1.1.2.3.4.5.6.7.8.9', '0.1.2.3.4.5.6.7.8.9'), vcOlderBroken, 
        '10 clause version: Difference in tenth clause should return vcOlderBroke');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // all tests passed?
    Pass;
  except
    on x: Exception do Fail(x);
  end;
  
  (*** mteVersionCheck ***)
  Describe('mteVersionCheck');
  try
    // Test with mteVersion
    Describe('Target version = mteVersion');
    try
      ExpectEqual(mteVersionCheck(mteVersion), vcEqual, 'Should return vcEqual');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with 0.0.0.0
    Describe('Target version = -255.-255.-255.-255');
    try
      ExpectEqual(mteVersionCheck('-255.-255.-255.-255'), vcNewerBroken, 'Should return vcNewerBroken');
      Pass;
    except
      on x: Exception do Fail(x);
    end;
    
    // Test with 255.255.255.255
    Describe('Target version = 255.255.255.255');
    try
      ExpectEqual(mteVersionCheck('255.255.255.255'), vcOlderBroken, 'Should return vcOlderBroken');
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
  // initialize jvt
  jvtInitialize;
  
  // perform tests
  TestMteBase;
  
  // finalize jvt
  jvtPrintReport;
  jvtFinalize;
end;

end.