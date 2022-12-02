/**
 * Copyright (c) 2014-2016, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 @isTest
public class fflib_MatcherDefinitionsTest
{
	private static final List<fflib_IMatcher> INTERNAL_MATCHERS = new List<fflib_IMatcher>{
																new fflib_MatcherDefinitions.StringContains('bob'),
																new fflib_MatcherDefinitions.StringContains('tom'),
																new fflib_MatcherDefinitions.StringContains('fred')
															};

	private static final Date TODAY = System.today();
	private static final Datetime NOW = System.now();

	private static final SObject ACCOUNT_RECORD;
	private static final Schema.SObjectType ACCOUNT_OBJECT_TYPE;
	private static final Schema.SObjectType OPPORTUNITY_OBJECT_TYPE;
	private static final Schema.SobjectType GROUP_OBJECT_TYPE;
	private static final Sobject[] GROUP_RECORDS;
	
	static
	{
		Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

		ACCOUNT_OBJECT_TYPE = globalDescribe.get('Account');
		OPPORTUNITY_OBJECT_TYPE = globalDescribe.get('Opportunity');
		GROUP_OBJECT_TYPE = globalDescribe.get('Group');
		
		SObject accountRecord = ACCOUNT_OBJECT_TYPE.newSObject();
		accountRecord.put('Name', 'MatcherDefinitionTestAccount' + System.now());
		accountRecord.Id = fflib_IDGenerator.generate(Account.SObjectType);
		ACCOUNT_RECORD = accountRecord;
        
		GROUP_RECORDS = new list<Group> {
			new Group(Name = 'MatcherDefnTestGroup0'+System.now(), DeveloperName='MatcherDefnTestGroup0'+System.now().getTime(),Type='Queue'),
			new Group(Name = 'MatcherDefnTestGroup1'+System.now(), DeveloperName='MatcherDefnTestGroup1'+System.now().getTime(),Type='Queue')
		};
		insert GROUP_RECORDS;    
        
	}

	@isTest
	private static void whenConstructingCombinedWithNullConnectiveExpressionShouldThrowException()
	{
		try
		{
			fflib_IMatcher matcher = new fflib_MatcherDefinitions.Combined(null, INTERNAL_MATCHERS);
			System.Assert.fail('Expecting exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Invalid connective expression: null', e.getMessage());
		}
	}

	@isTest
	private static void whenConstructingCombinedWithNullInternalMatchersShouldThrowException()
	{
		try
		{
			fflib_IMatcher matcher = new fflib_MatcherDefinitions.Combined(fflib_MatcherDefinitions.Connective.ALL, null);
			System.Assert.fail('Expecting exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Invalid inner matchers: null', e.getMessage());
		}
	}

	@isTest
	private static void whenConstructingCombinedWithEmptyInternalMatchersShouldThrowException()
	{
		try
		{
			fflib_IMatcher matcher = new fflib_MatcherDefinitions.Combined(fflib_MatcherDefinitions.Connective.ALL, new List<fflib_IMatcher>());
			System.Assert.fail('Expecting exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Invalid inner matchers: ()', e.getMessage());
		}
	}

	@isTest
	private static void whenCombinedMatchesWithAllExpressionShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.Combined(fflib_MatcherDefinitions.Connective.ALL, INTERNAL_MATCHERS);
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('ted'));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isFalse(matcher.matches('tomfred'));
		System.Assert.isTrue(matcher.matches('bobtomfred'));
	}

	@isTest
	private static void whenCombinedMatchesWithAtLeastOneExpressionShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.Combined(fflib_MatcherDefinitions.Connective.AT_LEAST_ONE, INTERNAL_MATCHERS);
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('ted'));
		System.Assert.isTrue(matcher.matches('bob'));
		System.Assert.isTrue(matcher.matches('tomfred'));
		System.Assert.isTrue(matcher.matches('bobtomfred'));
	}

	@isTest
	private static void whenCombinedMatchesWithNoneExpressionShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.Combined(fflib_MatcherDefinitions.Connective.NONE, INTERNAL_MATCHERS);
		System.Assert.isTrue(matcher.matches(null));
		System.Assert.isTrue(matcher.matches('ted'));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isFalse(matcher.matches('tomfred'));
		System.Assert.isFalse(matcher.matches('bobtomfred'));
	}

	@isTest
	private static void whenCombinedMatcherToStringReturnsExpectedString()
	{
		List<fflib_IMatcher> innerMatchers = new List<fflib_IMatcher>{
			new StringMatcher('one'),
			new StringMatcher('two'),
			new StringMatcher('three')
		};

		System.Assert.areEqual(
			'[any of: "one", "two", "three"]',
			'' + new fflib_MatcherDefinitions.Combined(fflib_MatcherDefinitions.Connective.AT_LEAST_ONE, innerMatchers)
		);
		System.Assert.areEqual(
			'[all of: "one", "two", "three"]',
			'' + new fflib_MatcherDefinitions.Combined(fflib_MatcherDefinitions.Connective.ALL, innerMatchers)
		);
		System.Assert.areEqual(
			'[none of: "one", "two", "three"]',
			'' + new fflib_MatcherDefinitions.Combined(fflib_MatcherDefinitions.Connective.NONE, innerMatchers)
		);
	}

	@isTest
	private static void constructEq_WithNullArg_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.Eq(null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenEqMatchesShouldReturnCorrectResults()
	{
		List<String> s1 = new List<String> {'bob', 'tom'};
		List<String> s2 = new List<String> {'bob', 'tom'};
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.Eq(s1);
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(new List<String> {'bob'}));
		System.Assert.isTrue(matcher.matches(s2));
		System.Assert.isTrue(matcher.matches(s1));
	}

	@isTest
	private static void whenEqToStringShouldReturnExpectedString()
	{
		System.Assert.areEqual('[equals 1]', '' + new fflib_MatcherDefinitions.Eq(1));
	}

	@isTest
	private static void constructRefEq_WithNullArg_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.RefEq(null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenRefEqMatchesShouldReturnCorrectResults()
	{
		List<String> s1 = new List<String> {'bob', 'tom'};
		List<String> s2 = new List<String> {'bob', 'tom'};
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.RefEq(s1);
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(s2));
		System.Assert.isTrue(matcher.matches(s1));
	}

	@isTest
	private static void whenRefEqToStringReturnsExpectedString()
	{
        List<String> s1 = new List<String> {'bob', 'tom'};
		System.Assert.areEqual('[reference equals ' + JSON.serialize(s1, false) + ']', '' + new fflib_MatcherDefinitions.RefEq(s1));
	}

	@isTest
	private static void whenAnyBooleanMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnyBoolean();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(9));
		System.Assert.isTrue(matcher.matches(true));
		System.Assert.isTrue(matcher.matches(false));
	}

	@isTest
	private static void whenAnyBooleanToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any Boolean]', '' + new fflib_MatcherDefinitions.AnyBoolean());
	}

	@isTest
	private static void whenAnyDateMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnyDate();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(NOW));
		System.Assert.isTrue(matcher.matches(TODAY));
	}

	@isTest
	private static void whenAnyDateToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any Date]', '' + new fflib_MatcherDefinitions.AnyDate());
	}

	@isTest
	private static void whenAnyDatetimeMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnyDatetime();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isTrue(matcher.matches(NOW));
		System.Assert.isTrue(matcher.matches(TODAY));
	}

	@isTest
	private static void whenAnyDatetimeToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any DateTime]', '' + new fflib_MatcherDefinitions.AnyDatetime());
	}

	@isTest
	private static void whenAnyDecimalMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnyDecimal();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isTrue(matcher.matches(9));
		System.Assert.isTrue(matcher.matches(9L));
		System.Assert.isTrue(matcher.matches(9.99));
	}

	@isTest
	private static void whenAnyDecimalToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any Decimal]', '' + new fflib_MatcherDefinitions.AnyDecimal());
	}

	@isTest
	private static void whenAnyDoubleMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnyDouble();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isTrue(matcher.matches(9));
		System.Assert.isTrue(matcher.matches(9L));
		System.Assert.isTrue(matcher.matches(9.99));
	}

	@isTest
	private static void whenAnyDoubleToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any Double]', '' + new fflib_MatcherDefinitions.AnyDouble());
	}

	@isTest
	private static void whenAnyFieldSetMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnyFieldSet();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));

		Schema.FieldSet anyFieldSet = fflib_ApexMocksUtilsTest.findAnyFieldSet();
		if (anyFieldSet != null)
		{
			System.Assert.isTrue(matcher.matches(anyFieldSet));
		}
	}

	@isTest
	private static void whenAnyFieldSetToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any FieldSet]', '' + new fflib_MatcherDefinitions.AnyFieldSet());
	}

	@isTest
	private static void whenAnyIdMatchesShouldReturnCorrectResults()
	{
		String idString = fflib_IDGenerator.generate(Account.SObjectType);
		Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnyId();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isTrue(matcher.matches(idString));
		System.Assert.isTrue(matcher.matches(accountId));
	}

	@isTest
	private static void whenAnyIdToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any Id]', '' + new fflib_MatcherDefinitions.AnyId());
	}

	@isTest
	private static void whenAnyIntegerMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnyInteger();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isFalse(matcher.matches(9L));
		System.Assert.isFalse(matcher.matches(9.99));
		System.Assert.isTrue(matcher.matches(9));
	}

	@isTest
	private static void whenAnyIntegerToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any Integer]', '' + new fflib_MatcherDefinitions.AnyInteger());
	}

	@isTest
	private static void whenAnyListMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnyList();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isTrue(matcher.matches(new List<String>()));
		System.Assert.isTrue(matcher.matches(new List<Integer>()));
		System.Assert.isTrue(matcher.matches(new List<Object>()));
	}

	@isTest
	private static void whenAnyListToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any list]', '' + new fflib_MatcherDefinitions.AnyList());
	}

	@isTest
	private static void whenAnyLongMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnyLong();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isFalse(matcher.matches(9.99));
		System.Assert.isTrue(matcher.matches(9));
		System.Assert.isTrue(matcher.matches(9L));
	}

	@isTest
	private static void whenAnyLongToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any Long]', '' + new fflib_MatcherDefinitions.AnyLong());
	}

	@isTest
	private static void whenAnyObjectMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnyObject();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isTrue(matcher.matches('bob'));
		System.Assert.isTrue(matcher.matches(9));
		System.Assert.isTrue(matcher.matches(new List<String>()));
	}

	@isTest
	private static void whenAnyObjectToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any Object]', '' + new fflib_MatcherDefinitions.AnyObject());
	}

	@isTest
	private static void whenAnyStringMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnyString();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(9));
		System.Assert.isTrue(matcher.matches('bob'));
	}

	@isTest
	private static void whenAnyStringToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any String]', '' + new fflib_MatcherDefinitions.AnyString());
	}

	@isTest
	private static void whenAnySObjectMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnySObject();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isTrue(matcher.matches(new Account()));
	}

	@isTest
	private static void whenAnySObjectToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any SObject]', '' + new fflib_MatcherDefinitions.AnySObject());
	}

	@isTest
	private static void whenAnySObjectFieldMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnySObjectField();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(new Account()));
		System.Assert.isTrue(matcher.matches(Account.Id));
	}

	@isTest
	private static void whenAnySObjectFieldToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any SObjectField]', '' + new fflib_MatcherDefinitions.AnySObjectField());
	}

	@isTest
	private static void whenAnySObjectTypeMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.AnySObjectType();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(new Account()));
		System.Assert.isTrue(matcher.matches(Account.SObjectType));
	}

	@isTest
	private static void whenAnySObjectTypeToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[any SObjectType]', '' + new fflib_MatcherDefinitions.AnySObjectType());
	}

	@isTest
	private static void constructDatetimeAfter_WithNullFromDatetime_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DatetimeAfter(null, true);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void constructDatetimeAfter_WithNullInclusive_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DatetimeAfter(System.now(), null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenDatetimeAfterMatchesWithoutInclusiveShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.DatetimeAfter(NOW, false);
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isFalse(matcher.matches(NOW.addSeconds(-1)));
		System.Assert.isFalse(matcher.matches(NOW));
		System.Assert.isTrue(matcher.matches(NOW.addSeconds(1)));
	}

	@isTest
	private static void whenDatetimeAfterMatchesWithInclusiveShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.DatetimeAfter(NOW, true);
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isFalse(matcher.matches(NOW.addSeconds(-1)));
		System.Assert.isTrue(matcher.matches(NOW));
		System.Assert.isTrue(matcher.matches(NOW.addSeconds(1)));
	}

	@isTest
	private static void whenDatetimeAfterWithInclusiveToStringReturnsExpectedString()
	{
		// Given
		DateTime fromDate = DateTime.newInstanceGmt(2019, 1, 1, 12, 0, 0);
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.DatetimeAfter(fromDate, true);

		// When
		String actual = '' + matcher;

		// Then
		System.Assert.areEqual('[on or after "2019-01-01T12:00:00.000Z"]', actual);
	}

	@isTest
	private static void whenDatetimeAfterWithNotInclusiveToStringReturnsExpectedString()
	{
		// Given
		DateTime fromDate = DateTime.newInstanceGmt(2019, 1, 1, 12, 0, 0);
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.DatetimeAfter(fromDate, false);

		// When
		String actual = '' + matcher;

		// Then
		System.Assert.areEqual('[after "2019-01-01T12:00:00.000Z"]', actual);
	}

	@isTest
	private static void constructDatetimeBefore_WithNullToDatetime_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DatetimeBefore(null, true);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void constructDatetimeBefore_WithNullInclusive_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DatetimeBefore(System.now(), null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenDatetimeBeforeMatchesWithoutInclusiveShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.DatetimeBefore(NOW, false);
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isFalse(matcher.matches(NOW.addSeconds(1)));
		System.Assert.isFalse(matcher.matches(NOW));
		System.Assert.isTrue(matcher.matches(NOW.addSeconds(-1)));
	}

	@isTest
	private static void whenDatetimeBeforeMatchesWithInclusiveShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.DatetimeBefore(NOW, true);
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isFalse(matcher.matches(NOW.addSeconds(1)));
		System.Assert.isTrue(matcher.matches(NOW));
		System.Assert.isTrue(matcher.matches(NOW.addSeconds(-1)));
	}

	@isTest
	private static void whenDatetimeBeforeWithInclusiveToStringReturnsExpectedString()
	{
		// Given
		DateTime toDate = DateTime.newInstanceGmt(2019, 1, 1, 12, 0, 0);
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.DatetimeBefore(toDate, true);

		// When
		String actual = '' + matcher;

		// Then
		System.Assert.areEqual('[on or before "2019-01-01T12:00:00.000Z"]', actual);
	}

	@isTest
	private static void whenDatetimeBeforeWithNotInclusiveToStringReturnsExpectedString()
	{
		// Given
		DateTime toDate = DateTime.newInstanceGmt(2019, 1, 1, 12, 0, 0);
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.DatetimeBefore(toDate, false);

		// When
		String actual = '' + matcher;

		// Then
		System.Assert.areEqual('[before "2019-01-01T12:00:00.000Z"]', actual);
	}

	@isTest
	private static void constructDatetimeBetween_WithNullFromDatetime_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DatetimeBetween(null, true, System.now(), true);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void constructDatetimeBetween_WithNullToDatetime_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DatetimeBetween(System.now(), true, null, true);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void constructDatetimeBetween_WithNullInclusiveFrom_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DatetimeBetween(System.now(), null, System.now(), true);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void constructDatetimeBetween_WithNullInclusiveTo_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DatetimeBetween(System.now(), true, System.now(), null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenDatetimeBetweenMatchesWithInclusiveFromWithoutInclusiveToShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.DatetimeBetween(NOW.addSeconds(-1), true, NOW.addSeconds(1), false);
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isFalse(matcher.matches(NOW.addSeconds(-2)));
		System.Assert.isFalse(matcher.matches(NOW.addSeconds(1)));
		System.Assert.isTrue(matcher.matches(NOW.addSeconds(-1)));
		System.Assert.isTrue(matcher.matches(NOW));
	}

	@isTest
	private static void whenDatetimeBetweenMatchesWithInclusiveToWithoutInclusiveFromShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.DatetimeBetween(NOW.addSeconds(-1), false, NOW.addSeconds(1), true);
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isFalse(matcher.matches(NOW.addSeconds(2)));
		System.Assert.isFalse(matcher.matches(NOW.addSeconds(-1)));
		System.Assert.isTrue(matcher.matches(NOW));
		System.Assert.isTrue(matcher.matches(NOW.addSeconds(1)));
	}

	@isTest
	private static void whenDatetimeBetweenWithInclusiveToStringReturnsExpectedString()
	{
		// Given
		DateTime fromDate = DateTime.newInstanceGmt(2019, 1, 1, 12, 0, 0);
		DateTime toDate = DateTime.newInstanceGmt(2019, 1, 3, 12, 0, 0);
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.DatetimeBetween(fromDate, true, toDate, true);

		// When
		String actual = '' + matcher;

		// Then
		System.Assert.areEqual('[on or after "2019-01-01T12:00:00.000Z" and on or before "2019-01-03T12:00:00.000Z"]', actual);
	}

	@isTest
	private static void whenDatetimeBetweenWithNotInclusiveToStringReturnsExpectedString()
	{
		// Given
		DateTime fromDate = DateTime.newInstanceGmt(2019, 1, 1, 12, 0, 0);
		DateTime toDate = DateTime.newInstanceGmt(2019, 1, 3, 12, 0, 0);
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.DatetimeBetween(fromDate, false, toDate, false);

		// When
		String actual = '' + matcher;

		// Then
		System.Assert.areEqual('[after "2019-01-01T12:00:00.000Z" and before "2019-01-03T12:00:00.000Z"]', actual);
	}

	@isTest
	private static void constructDecimalBetween_WithNullLower_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DecimalBetween(null, true, 123, true);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void constructDecimalBetween_WithNullInclusiveLower_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DecimalBetween(123, null, 123, true);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void constructDecimalBetween_WithNullUpper_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DecimalBetween(123, true, null, true);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void constructDecimalBetween_WithNullInclusiveUpper_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DecimalBetween(123, true, 123, null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenDecimalBetweenMatchesShouldReturnCorrectResults()
	{
		Integer lower = 5;
		Integer upper = 10;

		fflib_IMatcher exLowerExUpper = new fflib_MatcherDefinitions.DecimalBetween(lower, false, upper, false);
		fflib_IMatcher exLowerInUpper = new fflib_MatcherDefinitions.DecimalBetween(lower, false, upper, true);
		fflib_IMatcher inLowerExUpper = new fflib_MatcherDefinitions.DecimalBetween(lower, true, upper, false);
		fflib_IMatcher inLowerInUpper = new fflib_MatcherDefinitions.DecimalBetween(lower, true, upper, true);

		//Exclusive lower, exclusive upper
		System.Assert.isFalse(exLowerExUpper.matches(lower - 1));
		System.Assert.isFalse(exLowerExUpper.matches(lower));
		System.Assert.isTrue(exLowerExUpper.matches(lower + 1));
		System.Assert.isTrue(exLowerExUpper.matches(upper - 1));
		System.Assert.isFalse(exLowerExUpper.matches(upper));
		System.Assert.isFalse(exLowerExUpper.matches(upper + 1));
		System.Assert.isFalse(exLowerExUpper.matches(null));
		System.Assert.isFalse(exLowerExUpper.matches('NotADecimal'));

		//Exclusive lower, inclusive upper
		System.Assert.isFalse(exLowerInUpper.matches(lower - 1));
		System.Assert.isFalse(exLowerInUpper.matches(lower));
		System.Assert.isTrue(exLowerInUpper.matches(lower + 1));
		System.Assert.isTrue(exLowerInUpper.matches(upper - 1));
		System.Assert.isTrue(exLowerInUpper.matches(upper));
		System.Assert.isFalse(exLowerInUpper.matches(upper + 1));
		System.Assert.isFalse(exLowerInUpper.matches(null));
		System.Assert.isFalse(exLowerInUpper.matches('NotADecimal'));
		
		//Inclusive lower, exclusive upper
		System.Assert.isFalse(inLowerExUpper.matches(lower - 1));
		System.Assert.isTrue(inLowerExUpper.matches(lower));
		System.Assert.isTrue(inLowerExUpper.matches(lower + 1));
		System.Assert.isTrue(inLowerExUpper.matches(upper - 1));
		System.Assert.isFalse(inLowerExUpper.matches(upper));
		System.Assert.isFalse(inLowerExUpper.matches(upper + 1));
		System.Assert.isFalse(inLowerExUpper.matches(null));
		System.Assert.isFalse(inLowerExUpper.matches('NotADecimal'));
		
		//Inclusive lower, inclusive upper
		System.Assert.isFalse(inLowerInUpper.matches(lower - 1));
		System.Assert.isTrue(inLowerInUpper.matches(lower));
		System.Assert.isTrue(inLowerInUpper.matches(lower + 1));
		System.Assert.isTrue(inLowerInUpper.matches(upper - 1));
		System.Assert.isTrue(inLowerInUpper.matches(upper));
		System.Assert.isFalse(inLowerInUpper.matches(upper + 1));
		System.Assert.isFalse(inLowerInUpper.matches(null));
		System.Assert.isFalse(inLowerInUpper.matches('NotADecimal'));
	}

	@isTest
	private static void whenDecimalBetweenToStringReturnsExpectedString()
	{
		Integer lower = 5;
		Integer upper = 10;

		List<Integer> formatList = new List<Integer>{lower, upper};

		System.Assert.areEqual(String.format('greater than {0} and less than {1}', formatList),
			'' + new fflib_MatcherDefinitions.DecimalBetween(lower, false, upper, false));
		System.Assert.areEqual(String.format('greater than {0} and less than or equal to {1}', formatList),
			'' + new fflib_MatcherDefinitions.DecimalBetween(lower, false, upper, true));
		System.Assert.areEqual(String.format('greater than or equal to {0} and less than {1}', formatList),
			'' + new fflib_MatcherDefinitions.DecimalBetween(lower, true, upper, false));
		System.Assert.areEqual(String.format('greater than or equal to {0} and less than or equal to {1}', formatList),
			'' + new fflib_MatcherDefinitions.DecimalBetween(lower, true, upper, true));
	}

	@isTest
	private static void constructDecimalLessThan_WithNullToMatch_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DecimalLessThan(null, true);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void constructDecimalLessThan_WithNullInclusive_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DecimalLessThan(123, null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenDecimalLessThanMatchesShouldReturnCorrectResults()
	{
		Integer toMatch = 5;

		fflib_IMatcher exclusive = new fflib_MatcherDefinitions.DecimalLessThan(toMatch, false);
		fflib_IMatcher inclusive = new fflib_MatcherDefinitions.DecimalLessThan(toMatch, true);
		
		//Exclusive
		System.Assert.isTrue(exclusive.matches(toMatch - 1));
		System.Assert.isFalse(exclusive.matches(toMatch));
		System.Assert.isFalse(exclusive.matches(toMatch + 1));
		System.Assert.isFalse(exclusive.matches(null));
		System.Assert.isFalse(exclusive.matches('NotADecimal'));

		//Inclusive
		System.Assert.isTrue(inclusive.matches(toMatch - 1));
		System.Assert.isTrue(inclusive.matches(toMatch));
		System.Assert.isFalse(inclusive.matches(toMatch + 1));
		System.Assert.isFalse(inclusive.matches(null));
		System.Assert.isFalse(inclusive.matches('NotADecimal'));
	}

	@isTest
	private static void whenDecimalLessThanToStringReturnsExpectedString()
	{
		Integer toMatch = 5;

		System.Assert.areEqual('[less than or equal to ' + toMatch + ']',
			'' + new fflib_MatcherDefinitions.DecimalLessThan(toMatch, true));
		System.Assert.areEqual('[less than ' + toMatch + ']',
			'' + new fflib_MatcherDefinitions.DecimalLessThan(toMatch, false));
	}

	@isTest
	private static void constructDecimalMoreThan_WithNullToMatch_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DecimalMoreThan(null, true);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}
		
	@isTest
	private static void constructDecimalMoreThan_WithNullInclusive_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.DecimalMoreThan(123, null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}
		
	@isTest
	private static void whenDecimalMoreThanMatchesShouldReturnCorrectResults()
	{
		Integer toMatch = 5;

		fflib_IMatcher exclusive = new fflib_MatcherDefinitions.DecimalMoreThan(toMatch, false);
		fflib_IMatcher inclusive = new fflib_MatcherDefinitions.DecimalMoreThan(toMatch, true);
		
		//Exclusive
		System.Assert.isFalse(exclusive.matches(toMatch - 1));
		System.Assert.isFalse(exclusive.matches(toMatch));
		System.Assert.isTrue(exclusive.matches(toMatch + 1));
		System.Assert.isFalse(exclusive.matches(null));
		System.Assert.isFalse(exclusive.matches('NotADecimal'));

		//Inclusive
		System.Assert.isFalse(inclusive.matches(toMatch - 1));
		System.Assert.isTrue(inclusive.matches(toMatch));
		System.Assert.isTrue(inclusive.matches(toMatch + 1));
		System.Assert.isFalse(inclusive.matches(null));
		System.Assert.isFalse(inclusive.matches('NotADecimal'));
	}

	@isTest
	private static void whenDecimalMoreThanToStringReturnsExpectedString()
	{
		Integer toMatch = 5;

		System.Assert.areEqual('[greater than or equal to ' + toMatch + ']',
			'' + new fflib_MatcherDefinitions.DecimalMoreThan(toMatch, true));
		System.Assert.areEqual('[greater than ' + toMatch + ']',
			'' + new fflib_MatcherDefinitions.DecimalMoreThan(toMatch, false));
	}

	@isTest
	private static void constructFieldSetEquivalentTo_WithNullFieldSet_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.FieldSetEquivalentTo(null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenFieldSetEquivalentToWithoutFieldSetShouldNeverMatch()
	{
		//Cheap test to maintain 100% code coverage, even in orgs without field sets defined.
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.FieldSetEquivalentTo();
		System.Assert.isFalse(matcher.matches(null));
	}

	@isTest
	private static void whenFieldSetEquivalentToMatchesShouldReturnCorrectResults()
	{
		Schema.FieldSet anyFieldSet = fflib_ApexMocksUtilsTest.findAnyFieldSet();
		if (anyFieldSet == null)
		{
			return;
		}

		fflib_IMatcher matcher = new fflib_MatcherDefinitions.FieldSetEquivalentTo(anyFieldSet);
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('hello'));
		System.Assert.isTrue(matcher.matches(anyFieldSet));
	}

	@isTest
	private static void whenFieldSetEquivalentToToStringReturnsExpectedString()
	{
		Schema.FieldSet anyFieldSet = fflib_ApexMocksUtilsTest.findAnyFieldSet();
		if (anyFieldSet == null)
		{
			return;
		}
		Set<Schema.FieldSetMember> fieldSetMembers = new Set<Schema.FieldSetMember>((anyFieldSet).getFields());

		System.Assert.areEqual('[FieldSet with fields ' + JSON.serialize(fieldSetMembers, false) + ']',
			'' + new fflib_MatcherDefinitions.FieldSetEquivalentTo(anyFieldSet));
	}

	@isTest
	private static void whenIsNullMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.IsNull();
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isTrue(matcher.matches(null));
	}

	@isTest
	private static void whenIsNullToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[is null]', '' + new fflib_MatcherDefinitions.IsNull());
	}

	@isTest
	private static void whenIsNotNullMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.IsNotNull();
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isTrue(matcher.matches('bob'));
	}

	@isTest
	private static void whenIsNotNullToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[is not null]', '' + new fflib_MatcherDefinitions.IsNotNull());
	}

	@isTest
	private static void whenListContainsMatchesShouldReturnCorrectResults()
	{
		List<String> names = new List<String>{ 'bob', 'tom', 'fred' };
		List<String> empty = new List<String>();
		
		System.Assert.isFalse(new fflib_MatcherDefinitions.ListContains('fred').matches(null));
		System.Assert.isFalse(new fflib_MatcherDefinitions.ListContains('fred').matches(empty));
		System.Assert.isFalse(new fflib_MatcherDefinitions.ListContains('jack').matches(names));
		System.Assert.isTrue(new fflib_MatcherDefinitions.ListContains('fred').matches(names));
		System.Assert.isFalse(new fflib_MatcherDefinitions.ListContains('fred').matches('NotAList'));
	}

	@isTest
	private static void whenListContainsToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[list containing "hello"]', '' + new fflib_MatcherDefinitions.ListContains('hello'));
	}

	@isTest
	private static void whenListIsEmptyMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.ListIsEmpty();
		
		List<String> names = new List<String>{ 'bob', 'tom', 'fred' };
		List<String> empty = new List<String>();
		
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(names));
		System.Assert.isTrue(matcher.matches(empty));
		System.Assert.isFalse(matcher.matches('NotAList'));
	}

	@isTest
	private static void whenListIsEmptyToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[empty list]', '' + new fflib_MatcherDefinitions.ListIsEmpty());
	}

	@isTest
	private static void constructSObjectOfType_WithNullArg_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.SObjectOfType(null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenSObjectOfTypeMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.SObjectOfType(ACCOUNT_OBJECT_TYPE);

		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(OPPORTUNITY_OBJECT_TYPE.newSObject()));
		System.Assert.isFalse(matcher.matches('NotASObject'));

		System.Assert.isTrue(matcher.matches(ACCOUNT_OBJECT_TYPE.newSObject()));
		System.Assert.isTrue(matcher.matches(ACCOUNT_RECORD));
	}

	@isTest
	private static void whenSObjectOfTypeToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[SObject of type Account]', '' + new fflib_MatcherDefinitions.SObjectOfType(ACCOUNT_OBJECT_TYPE));
	}

	@isTest
	private static void constructSObjectWith_WithNullArg_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.SObjectWith(null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null/empty: null', e.getMessage());
		}
	}

	@isTest
	private static void constructSObjectWith_WithEmptyArg_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.SObjectWith(new Map<Schema.SObjectField, Object>());	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null/empty: {}', e.getMessage());
		}
	}

	@isTest
	private static void whenSObjectWithMatchesShouldReturnCorrectResults()
	{
		Map<String, Schema.SObjectField> fields = ACCOUNT_OBJECT_TYPE.getDescribe().fields.getMap();
		Schema.SObjectField idField = fields.get('Id');
		Schema.SObjectField nameField = fields.get('Name');
		Schema.SObjectField createdDateField = fields.get('CreatedDate');
		
		Map<Schema.SObjectField, Object> queriedFieldValues = new Map<Schema.SObjectField, Object>
		{
			idField => ACCOUNT_RECORD.Id,
			nameField => ACCOUNT_RECORD.get('Name')
		};

		Map<Schema.SObjectField, Object> notQueriedFieldValues = new Map<Schema.SObjectField, Object>
		{
			createdDateField => System.now()
		};

		fflib_IMatcher matcher = new fflib_MatcherDefinitions.SObjectWith(queriedFieldValues);
		
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(OPPORTUNITY_OBJECT_TYPE.newSObject()));
		System.Assert.isFalse(matcher.matches(ACCOUNT_OBJECT_TYPE.newSObject()));
		System.Assert.isFalse(matcher.matches('NotASObject'));

		System.Assert.isTrue(matcher.matches(ACCOUNT_RECORD));

		System.Assert.isFalse(new fflib_MatcherDefinitions.SObjectWith(notQueriedFieldValues).matches(ACCOUNT_RECORD));
	}

	@isTest
	private static void whenSObjectWithToStringReturnsExpectedString()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.SObjectWith(new Map<Schema.SObjectField, Object>{
			Account.Name => 'Test'
		});
		System.Assert.areEqual('[SObject with fields {"Name":"Test"}]', '' + matcher);
	}

	@isTest
	private static void whenSObjectsWithInOrderMatchesShouldReturnCorrectResults()
	{
		Map<String, Schema.SObjectField> fields = GROUP_OBJECT_TYPE.getDescribe().fields.getMap();
		Schema.SObjectField idField = fields.get('Id');
		Schema.SObjectField nameField = fields.get('Name');
		Schema.SObjectField createdDateField = fields.get('CreatedDate');
		
		list<Map<Schema.SObjectField, Object>> queriedFieldValues = new list<Map<Schema.SObjectField, Object>>
		{
            new map<Schema.SObjectField,Object> 
            {
                idField => GROUP_RECORDS[0].Id,
				nameField => GROUP_RECORDS[0].get('Name')
            },
            new map<Schema.SObjectField,Object> 
            {
                idField => GROUP_RECORDS[1].Id,
				nameField => GROUP_RECORDS[1].get('Name')
            }               
		};

		list<Map<Schema.SObjectField, Object>> failingFieldValues = new list<Map<Schema.SObjectField, Object>>
		{
			new map<Schema.SObjectField,Object>
			{
				idField => GROUP_RECORDS[0].Id,
				nameField => GROUP_RECORDS[0].get('Name')
			},
			new map<Schema.SObjectField,Object>
			{
				idField => GROUP_RECORDS[1].Id,
				nameField => GROUP_RECORDS[1].get('Name') + 'test'
			}
		};

		list<Map<Schema.SObjectField, Object>> notQueriedFieldValues = new list<Map<Schema.SObjectField, Object>>
		{
			new map<Schema.SObjectField,Object> 
            {
                createdDateField => System.now()
            },
            new map<Schema.SObjectField,Object> 
            {
                createdDateField => System.now()
            }    
		};

		fflib_IMatcher matcher = new fflib_MatcherDefinitions.SObjectsWith(queriedFieldValues);
		
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(new list<SObject>
                                       {
                                           OPPORTUNITY_OBJECT_TYPE.newSObject(),
                                           OPPORTUNITY_OBJECT_TYPE.newSObject()    
                                       }
                                      ));
		System.Assert.isFalse(matcher.matches(new list<SObject>
                                       {
                                           GROUP_OBJECT_TYPE.newSObject(),
                                           GROUP_OBJECT_TYPE.newSObject()
                                       }
                                      ),'sObjectsWith arity agrees but arg doesn\'t');
		System.Assert.isFalse(matcher.matches('NotAListofSObject'));

		System.Assert.isTrue(matcher.matches(GROUP_RECORDS),'toMatch and args have same arity and in same order');
        System.Assert.isTrue (!matcher.matches(new list<SObject> {GROUP_RECORDS[1],GROUP_RECORDS[0]}),
                                     'sObjectsWith toMatch and args have same arity but args are in different order than toMatch') ;            
                      

		System.Assert.isFalse(new fflib_MatcherDefinitions.SObjectsWith(notQueriedFieldValues).matches(GROUP_RECORDS));
		System.Assert.isFalse(new fflib_MatcherDefinitions.SObjectsWith(failingFieldValues).matches(GROUP_RECORDS));
	}

    @isTest
	private static void whenSObjectsInAnyOrderWithMatchesShouldReturnCorrectResults()
	{
		Map<String, Schema.SObjectField> fields = GROUP_OBJECT_TYPE.getDescribe().fields.getMap();
		Schema.SObjectField idField = fields.get('Id');
		Schema.SObjectField nameField = fields.get('Name');
		Schema.SObjectField createdDateField = fields.get('CreatedDate');
		
		list<Map<Schema.SObjectField, Object>> queriedFieldValues = new list<Map<Schema.SObjectField, Object>>
		{
            new map<Schema.SObjectField,Object> 
            {
                idField => GROUP_RECORDS[0].Id,
				nameField => GROUP_RECORDS[0].get('Name')
            },
            new map<Schema.SObjectField,Object> 
            {
                idField => GROUP_RECORDS[1].Id,
				nameField => GROUP_RECORDS[1].get('Name')
            }               
		};

		list<Map<Schema.SObjectField, Object>> notQueriedFieldValues = new list<Map<Schema.SObjectField, Object>>
		{
			new map<Schema.SObjectField,Object> 
            {
                createdDateField => System.now()
            },
            new map<Schema.SObjectField,Object> 
            {
                createdDateField => System.now()
            }    
		};

		fflib_IMatcher matcher = new fflib_MatcherDefinitions.SObjectsWith(queriedFieldValues,false); // any order
		
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(new list<SObject>
                                       {
                                           OPPORTUNITY_OBJECT_TYPE.newSObject(),
                                           OPPORTUNITY_OBJECT_TYPE.newSObject()    
                                       }
                                      ));
		System.Assert.isFalse(matcher.matches(new list<SObject>
                                       {
                                           GROUP_OBJECT_TYPE.newSObject(),
                                           GROUP_OBJECT_TYPE.newSObject()
                                       }
                                      ),'sObjectsWith arity agrees but arg doesn\'t match matcher');
		System.Assert.isFalse(matcher.matches('NotAListofSObject'));

		System.Assert.isTrue(matcher.matches(GROUP_RECORDS),'toMatch and args have same arity and in same order. Match should be OK');
        System.Assert.isTrue (matcher.matches(new list<SObject> {GROUP_RECORDS[1],GROUP_RECORDS[0]}),
                                     'sObjectsWith toMatch and args have same arity but args are in diff order than matcher. Should be OK') ;            
                      

		System.Assert.isFalse(new fflib_MatcherDefinitions.SObjectsWith(notQueriedFieldValues,false).matches(GROUP_RECORDS));
	}

	@isTest
	private static void whenSObjectsWithToStringReturnsExpectedString()
	{
		List<Map<Schema.SObjectField, Object>> toMatch = new List<Map<Schema.SObjectField, Object>>{
			new Map<Schema.SObjectField, Object> {
				Account.Name => 'Test'
			}
		};

		System.Assert.areEqual('[ordered SObjects with [{"Name":"Test"}]]', '' + new fflib_MatcherDefinitions.SObjectsWith(toMatch, true));
		System.Assert.areEqual('[unordered SObjects with [{"Name":"Test"}]]', '' + new fflib_MatcherDefinitions.SObjectsWith(toMatch, false));
	}

	@isTest
	private static void whenSObjectsWithDifferentArityMatchesShouldReturnFalse()
	{
		List<Map<Schema.SObjectField, Object>> toMatch = new List<Map<Schema.SObjectField, Object>>{
			new Map<Schema.SObjectField, Object> {
				Account.Name => 'Test'
			}
		};
		Boolean matchResult = new fflib_MatcherDefinitions.SObjectsWith(toMatch).matches(new List<SObject>{});
		System.Assert.areEqual(matchResult, false);
	}

	@isTest
	private static void constructSObjectsWith_WithNullArg_ThrowsException()
	{
		try {
			new fflib_MatcherDefinitions.SObjectsWith(null);
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null/empty/other than list of map<Schema.SobjectField,Object>: null', e.getMessage());
		}
	}

	@isTest
	private static void constructSObjectWithId_WithNullArg_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.SObjectWithId(null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenSObjectWithIdMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.SObjectWithId(ACCOUNT_RECORD.Id);

		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(OPPORTUNITY_OBJECT_TYPE.newSObject()));
		System.Assert.isFalse(matcher.matches(ACCOUNT_OBJECT_TYPE.newSObject()));
		System.Assert.isFalse(matcher.matches('NotASObject'));

		System.Assert.isTrue(matcher.matches(ACCOUNT_RECORD));
	}

	@isTest
	private static void whenSObjectWithIdToStringReturnsExpectedString()
	{
		Id recordId = '001000000000001AAA';
		System.Assert.areEqual('[SObject with Id "001000000000001AAA"]', '' + new fflib_MatcherDefinitions.SObjectWithId(recordId));
	}

	@isTest
	private static void constructSObjectWithName_WithNullArg_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.SObjectWithName(null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenSObjectWithNameMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.SObjectWithName((String)ACCOUNT_RECORD.get('Name'));

		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(OPPORTUNITY_OBJECT_TYPE.newSObject()));
		System.Assert.isFalse(matcher.matches(ACCOUNT_OBJECT_TYPE.newSObject()));
		System.Assert.isFalse(matcher.matches('NotASObject'));

		System.Assert.isTrue(matcher.matches(ACCOUNT_RECORD));
	}

	@isTest
	private static void whenSObjectWithNameToStringReturnsExpectedString()
	{
		System.Assert.areEqual('[SObject with Name "Test"]', '' + new fflib_MatcherDefinitions.SObjectWithName('Test'));
	}

	@isTest
	private static void whenStringContainsMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.StringContains('bob');
		System.Assert.isFalse(matcher.matches(7));
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(''));
		System.Assert.isFalse(matcher.matches('blob'));
		System.Assert.isTrue(matcher.matches('bob'));
		System.Assert.isTrue(matcher.matches('bobby'));
	}

	@isTest
	private static void constructStringContains_WithNullArg_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.StringContains(null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenStringContainsToStringReturnsExpectedStrings()
	{
		System.Assert.areEqual('[contains "hello"]', '' + new fflib_MatcherDefinitions.StringContains('hello'));
	}

	@isTest
	private static void whenStringEndsWithMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.StringEndsWith('bob');
		System.Assert.isFalse(matcher.matches(7));
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(''));
		System.Assert.isFalse(matcher.matches('bobby'));
		System.Assert.isTrue(matcher.matches('bob'));
		System.Assert.isTrue(matcher.matches('jimbob'));
	}

	@isTest
	private static void constructStringEndsWith_WithNullArg_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.StringEndsWith(null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenStringEndsWithToStringReturnsExpectedStrings()
	{
		System.Assert.areEqual('[ends with "hello"]', '' + new fflib_MatcherDefinitions.StringEndsWith('hello'));
	}

	@isTest
	private static void whenIsBlankWithMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.StringIsBlank();
		System.Assert.isFalse(matcher.matches(7));
		System.Assert.isFalse(matcher.matches('bob'));
		System.Assert.isTrue(matcher.matches(null));
		System.Assert.isTrue(matcher.matches(''));
	}

	@isTest
	private static void whenStringIsBlankToStringReturnsExpectedStrings()
	{
		System.Assert.areEqual('[blank String]', '' + new fflib_MatcherDefinitions.StringIsBlank());
	}

	@isTest
	private static void whenIsNotBlankWithMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.StringIsNotBlank();
		System.Assert.isFalse(matcher.matches(7));
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(''));
		System.Assert.isTrue(matcher.matches('bob'));
	}

	@isTest
	private static void whenStringIsNotBlankToStringReturnsExpectedStrings()
	{
		System.Assert.areEqual('[non-blank String]', '' + new fflib_MatcherDefinitions.StringIsNotBlank());
	}

	@isTest
	private static void whenStringMatchesMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.StringMatches('(b|m)o[a-z]*');
		System.Assert.isFalse(matcher.matches(7));
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches('bib'));
		System.Assert.isFalse(matcher.matches('jimbob'));
		System.Assert.isFalse(matcher.matches('tom'));
		System.Assert.isFalse(matcher.matches('bob1'));
		System.Assert.isTrue(matcher.matches('bobby'));
		System.Assert.isTrue(matcher.matches('mo'));
	}

	@isTest
	private static void whenStringMatchesToStringReturnsExpectedStrings()
	{
		System.Assert.areEqual('[matches regex "hello"]', '' + new fflib_MatcherDefinitions.StringMatches('hello'));
	}

	@isTest
	private static void constructStringMatches_WithNullArg_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.StringMatches(null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenStringStartsWithMatchesShouldReturnCorrectResults()
	{
		fflib_IMatcher matcher = new fflib_MatcherDefinitions.StringStartsWith('bob');
		System.Assert.isFalse(matcher.matches(7));
		System.Assert.isFalse(matcher.matches(null));
		System.Assert.isFalse(matcher.matches(''));
		System.Assert.isFalse(matcher.matches('jimbob'));
		System.Assert.isTrue(matcher.matches('bob'));
		System.Assert.isTrue(matcher.matches('bobby'));
	}

	@isTest
	private static void whenStringStartsWithToStringReturnsExpectedStrings()
	{
		System.Assert.areEqual('[starts with "hello"]', '' + new fflib_MatcherDefinitions.StringStartsWith('hello'));
	}

	@isTest
	private static void constructStringStartsWith_WithNullArg_ThrowsException()
	{
		try
		{
			new fflib_MatcherDefinitions.StringStartsWith(null);	
			System.Assert.fail('Expected exception');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.Assert.areEqual('Arg cannot be null: null', e.getMessage());
		}
	}

	@isTest
	private static void whenJSONExceptionOccursStringifyShouldReturnsObjectToString()
	{
		// SObjectField object definitely can't be serialized by JSON.serialize() method
		Schema.SObjectField sObjField = Account.Description;
		System.Assert.areEqual('' + sObjField, fflib_MatcherDefinitions.stringify(sObjField));
	}

	private class StringMatcher implements fflib_IMatcher
	{
		private final String value;

		public StringMatcher(String value)
		{
			this.value = value;
		}

		public Boolean matches(Object arg)
		{
			return true;
		}

		public override String toString()
		{
			return '"' + value + '"';
		}
	}
}
