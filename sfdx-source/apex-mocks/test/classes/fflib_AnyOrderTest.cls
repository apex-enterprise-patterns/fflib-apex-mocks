/*
Copyright (c) 2017 FinancialForce.com, inc.  All rights reserved.
*/

/**
* @nodoc
*/
@IsTest
private class fflib_AnyOrderTest
{
	/*
	*	replicating the apex mocks tests with the new syntax
	*/

	@IsTest
	private static void whenVerifyMultipleCallsWithMatchersShouldReturnCorrectMethodCallCounts()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add(fflib_Match.anyString());
		((fflib_MyList.IList) mocks.verify(mockList)).add('fred');
		((fflib_MyList.IList) mocks.verify(mockList)).add(fflib_Match.stringContains('fred'));
	}

	@IsTest
	private static void whenVerifyWithCombinedMatchersShouldReturnCorrectMethodCallCounts()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add((String) fflib_Match.allOf(fflib_Match.eq('bob'), fflib_Match.stringContains('re')));

		((fflib_MyList.IList) mocks.verify(mockList)).add((String) fflib_Match.allOf(fflib_Match.eq('fred'), fflib_Match.stringContains('re')));

		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add((String) fflib_Match.anyOf(fflib_Match.eq('bob'), fflib_Match.eq('fred')));

		((fflib_MyList.IList) mocks.verify(mockList)).add((String) fflib_Match.anyOf(fflib_Match.eq('bob'), fflib_Match.eq('jack')));

		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add((String) fflib_Match.noneOf(fflib_Match.eq('jack'), fflib_Match.eq('tim')));

		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add((String) fflib_Match.noneOf(fflib_Match.anyOf(fflib_Match.eq('jack'), fflib_Match.eq('jill')), fflib_Match.allOf(fflib_Match.eq('tim'), fflib_Match.stringContains('i'))));

		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add((String) fflib_Match.isNot(fflib_Match.eq('jack')));
	}

	@IsTest
	private static void whenVerifyCustomMatchersCanBeUsed()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.get(1);
		mockList.get(2);
		mockList.get(3);
		mockList.get(4);
		mockList.get(5);

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(3))).get((Integer) fflib_Match.matches(new isOdd()));
		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).get((Integer) fflib_Match.matches(new isEven()));
	}

	@IsTest
	private static void verifyMultipleMethodCallsWithSameSingleArgument()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add('bob');
	}

	@IsTest
	private static void verifyMethodNotCalled()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.get(0);

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add('bob');
		((fflib_MyList.IList) mocks.verify(mockList)).get(0);
	}

	@IsTest
	private static void verifySingleMethodCallWithMultipleArguments()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.set(0, 'bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList)).set(0, 'bob');
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).set(0, 'fred');
	}

	@IsTest
	private static void verifyMethodCallWhenNoCallsBeenMadeForType()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add('bob');
	}

	@IsTest
	private static void whenVerifyMethodNeverCalledMatchersAreReset()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).get(fflib_Match.anyInteger());
		((fflib_MyList.IList) mocks.verify(mockList)).add(fflib_Match.anyString());
	}

	/*
	*	times
	*/

	@IsTest
	private static void verifyTimesMethodHasBeenCalled()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(3))).add('bob');
	}

	@IsTest
	private static void verifyTimesMethodHasBeenCalledWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob1');
		mockList.add('bob2');
		mockList.add('bob3');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(3))).add(fflib_Match.anyString());
	}

	@IsTest
	private static void thatVerifyTimesMethodFailsWhenCalledLessTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.times(4))).add('bob');

			System.Assert.fail('an exception was expected');
		}
		catch (Exception exc)
		{
			assertFailMessage(exc.getMessage(), 4, 3);
		}
	}

	@IsTest
	private static void thatVerifyTimesMethodFailsWhenCalledMoreTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add('bob');

			System.Assert.fail('an exception was expected');
		}
		catch (Exception exc)
		{
			assertFailMessage(exc.getMessage(), 2, 3);
		}
	}

	@IsTest
	private static void thatVerifyTimesMethodFailsWhenCalledLessTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.times(4))).add(fflib_Match.anyString());

			System.Assert.fail('an exception was expected');
		}
		catch (Exception exc)
		{
			assertFailMessage(exc.getMessage(), 4, 3);
		}
	}

	@IsTest
	private static void thatVerifyTimesMethodFailsWhenCalledMoreTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add(fflib_Match.anyString());

			System.Assert.fail('an exception was expected');
		}
		catch (Exception exc)
		{
			assertFailMessage(exc.getMessage(), 2, 3);
		}
	}

	/*
	*	description
	*/

	@IsTest
	private static void thatCustomMessageIsAdded()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		String customAssertMessage = 'Custom message to explain the reason of the verification';

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2).description(customAssertMessage))).add(fflib_Match.anyString());

			System.Assert.fail('an exception was expected');
		}
		catch (Exception exc)
		{
			System
				.Assert
				.areEqual(
					'EXPECTED COUNT: 2'
					+ '\nACTUAL COUNT: 3'
					+ '\nMETHOD: fflib_MyList__sfdc_ApexStub.add(String)'
					+ '\nCustom message to explain the reason of the verification'
					+ '\n---'
					+ '\nACTUAL ARGS: ("bob"), ("bob"), ("bob")'
					+ '\n---'
					+ '\nEXPECTED ARGS: [any String]',
					exc.getMessage(),
					'Unexpected verify fail message'
				);
		}
	}

	/*
	*	atLeast
	*/

	@IsTest
	private static void thatVerifiesAtLeastNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeast(2))).add('bob');
	}

	@IsTest
	private static void thatVerifiesAtLeastNumberOfTimesWhenIsCalledMoreTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeast(2))).add('bob');
	}

	@IsTest
	private static void thatThrownExceptionIfCalledLessThanAtLeastNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeast(3))).add('bob');

			System.Assert.fail('an exception was expected because we are asserting that the method is called 3 times when instead is called only twice');
		}
		catch (fflib_ApexMocks.ApexMocksException ex)
		{
			System
				.Assert
				.areEqual(
					'EXPECTED COUNT: 3 or more times' + '\nACTUAL COUNT: 2' + '\nMETHOD: fflib_MyList__sfdc_ApexStub.add(String)' + '\n---' + '\nACTUAL ARGS: ("bob"), ("fred"), ("bob")' + '\n---' + '\nEXPECTED ARGS: "bob"',
					ex.getMessage(),
					'Unexpected verify fail message'
				);
		}
	}

	@IsTest
	private static void thatVerifiesAtLeastNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeast(2))).add(fflib_Match.anyString());
	}

	@IsTest
	private static void thatVerifiesAtLeastNumberOfTimesWhenIsCalledMoreTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeast(2))).add(fflib_Match.anyString());
	}

	@IsTest
	private static void thatThrownExceptionIfCalledLessThanAtLeastNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeast(3))).add(fflib_Match.anyString());

			System.Assert.fail('an exception was expected because we are asserting that the method is called 3 times when instead is called only twice');
		}
		catch (fflib_ApexMocks.ApexMocksException ex)
		{
			System
				.Assert
				.areEqual(
					'EXPECTED COUNT: 3 or more times' + '\nACTUAL COUNT: 2' + '\nMETHOD: fflib_MyList__sfdc_ApexStub.add(String)' + '\n---' + '\nACTUAL ARGS: ("bob"), ("fred")' + '\n---' + '\nEXPECTED ARGS: [any String]',
					ex.getMessage(),
					'Unexpected verify fail message'
				);
		}
	}

	/*
	*	atMost
	*/

	@IsTest
	private static void thatVerifiesAtMostNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atMost(5))).add('bob');
	}

	@IsTest
	private static void thatVerifiesAtMostSameNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atMost(3))).add('bob');
	}

	@IsTest
	private static void thatThrownExceptionIfCalledMoreThanAtMostNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atMost(3))).add('bob');

			System.Assert.fail('an exception was expected because we are asserting that the method is called 3 times when instead is called four times');
		}
		catch (fflib_ApexMocks.ApexMocksException ex)
		{
			System
				.Assert
				.areEqual(
					'EXPECTED COUNT: 3 or fewer times' + '\nACTUAL COUNT: 4' + '\nMETHOD: fflib_MyList__sfdc_ApexStub.add(String)' + '\n---' + '\nACTUAL ARGS: ("bob"), ("fred"), ("fred"), ("bob"), ("bob"), ("bob"), ("fred")' + '\n---' + '\nEXPECTED ARGS: "bob"',
					ex.getMessage(),
					'Unexpected verify fail message'
				);
		}
	}

	@IsTest
	private static void thatVerifiesAtMostNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atMost(5))).add(fflib_Match.anyString());
	}

	@IsTest
	private static void thatVerifiesAtMostSameNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atMost(3))).add(fflib_Match.anyString());
	}

	@IsTest
	private static void thatThrownExceptionIfCalledMoreThanAtMostNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');
		mockList.add('fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atMost(3))).add(fflib_Match.anyString());

			System.Assert.fail('an exception was expected because we are asserting that the method is called 3 times when instead is called four times');
		}
		catch (fflib_ApexMocks.ApexMocksException ex)
		{
			System
				.Assert
				.areEqual(
					'EXPECTED COUNT: 3 or fewer times' + '\nACTUAL COUNT: 4' + '\nMETHOD: fflib_MyList__sfdc_ApexStub.add(String)' + '\n---' + '\nACTUAL ARGS: ("bob"), ("fred"), ("fred"), ("fred")' + '\n---' + '\nEXPECTED ARGS: [any String]',
					ex.getMessage(),
					'Unexpected verify fail message'
				);
		}
	}

	/*
	*	atLeastOnce
	*/

	@IsTest
	private static void thatVerifiesAtLeastOnceNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add('bob');
	}

	@IsTest
	private static void thatVerifiesAtLeastOnceNumberOfTimesWhenIsCalledMoreTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add('bob');
	}

	@IsTest
	private static void thatThrownExceptionIfCalledLessThanAtLeastOnceNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('rob');
		mockList.add('fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add('bob');

			System.Assert.fail('an exception was expected because we are asserting that the method is called at least once when instead is never called');
		}
		catch (fflib_ApexMocks.ApexMocksException ex)
		{
			System
				.Assert
				.areEqual(
					'EXPECTED COUNT: 1 or more times' + '\nACTUAL COUNT: 0' + '\nMETHOD: fflib_MyList__sfdc_ApexStub.add(String)' + '\n---' + '\nACTUAL ARGS: ("rob"), ("fred")' + '\n---' + '\nEXPECTED ARGS: "bob"',
					ex.getmessage(),
					'Unexpected verify fail message'
				);
		}
	}

	@IsTest
	private static void thatVerifiesAtLeastOnceNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred', 'fred', 'fred', 'fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add(fflib_Match.anyString());
	}

	@IsTest
	private static void thatVerifiesAtLeastOnceNumberOfTimesWhenIsCalledMoreTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred', 'fred', 'fred', 'fred');
		mockList.add('bob');
		mockList.add('fred', 'fred', 'fred', 'fred');
		mockList.add('bob');
		mockList.add('fred', 'fred', 'fred', 'fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add(fflib_Match.anyString());
	}

	@IsTest
	private static void thatThrownExceptionIfCalledLessThanAtLeastOnceNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('fred', 'fred', 'fred', 'fred');
		mockList.add('fred', 'fred', 'fred', 'fred');
		mockList.add('fred', 'fred', 'fred', 'fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add(fflib_Match.anyString());

			System.Assert.fail('an exception was expected because we are asserting that the method is called at lest once when instead is never called');
		}
		catch (fflib_ApexMocks.ApexMocksException ex)
		{
			System
				.Assert
				.areEqual(
					'EXPECTED COUNT: 1 or more times' + '\nACTUAL COUNT: 0' + '\nMETHOD: fflib_MyList__sfdc_ApexStub.add(String)' + '\n---' + '\nACTUAL ARGS: ()' + '\n---' + '\nEXPECTED ARGS: [any String]',
					ex.getMessage(),
					'Unexpected verify fail message'
				);
		}
	}

	/*
	*	between
	*/

	@IsTest
	private static void thatVerifiesBetweenNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.between(3, 5))).add('bob');
	}

	@IsTest
	private static void thatBetweenThrownExceptionIfCalledLessThanAtLeastNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.between(3, 5))).add('bob');

			System.Assert.fail('an exception was expected because we are asserting that the method is called at least 3 times when instead is called only twice');
		}
		catch (fflib_ApexMocks.ApexMocksException ex)
		{
			System.Assert.areEqual('EXPECTED COUNT: 3 or more times' + '\nACTUAL COUNT: 2' + '\nMETHOD: fflib_MyList__sfdc_ApexStub.add(String)' + '\n---' + '\nACTUAL ARGS: ("bob"), ("fred"), ("bob")' + '\n---' + '\nEXPECTED ARGS: "bob"', ex.getMessage());
		}
	}

	@IsTest
	private static void thatVerifiesBetweenNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.between(3, 5))).add(fflib_Match.anyString());
	}

	@IsTest
	private static void thatBetweenThrownExceptionIfCalledLessThanAtLeastNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.between(3, 5))).add(fflib_Match.anyString());

			System.Assert.fail('an exception was expected because we are asserting that the method is called 3 times when instead is called only twice');
		}
		catch (fflib_ApexMocks.ApexMocksException ex)
		{
			System.Assert.areEqual('EXPECTED COUNT: 3 or more times' + '\nACTUAL COUNT: 2' + '\nMETHOD: fflib_MyList__sfdc_ApexStub.add(String)' + '\n---' + '\nACTUAL ARGS: ("bob"), ("fred")' + '\n---' + '\nEXPECTED ARGS: [any String]', ex.getMessage());
		}
	}

	@IsTest
	private static void thatBetweenThrownExceptionIfCalledMoreThanAtMostNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.between(3, 5))).add('bob');

			System.Assert.fail('an exception was expected because we are asserting that the method is called at most 5 times when instead is called six times');
		}
		catch (fflib_ApexMocks.ApexMocksException ex)
		{
			System
				.Assert
				.areEqual(
					'EXPECTED COUNT: 5 or fewer times'
					+ '\nACTUAL COUNT: 6'
					+ '\nMETHOD: fflib_MyList__sfdc_ApexStub.add(String)'
					+ '\n---'
					+ '\nACTUAL ARGS: ("bob"), ("fred"), ("fred"), ("bob"), ("bob"), ("bob"), ("bob"), ("bob"), ("fred")'
					+ '\n---'
					+ '\nEXPECTED ARGS: "bob"',
					ex.getMessage()
				);
		}
	}

	@IsTest
	private static void thatBetweenThrownExceptionIfCalledMoreThanAtMostNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');
		mockList.add('fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.between(3, 5))).add(fflib_Match.anyString());

			System.Assert.fail('an exception was expected because we are asserting that the method is called 5 times when instead is called six times');
		}
		catch (fflib_ApexMocks.ApexMocksException ex)
		{
			System
				.Assert
				.areEqual(
					'EXPECTED COUNT: 5 or fewer times' + '\nACTUAL COUNT: 6' + '\nMETHOD: fflib_MyList__sfdc_ApexStub.add(String)' + '\n---' + '\nACTUAL ARGS: ("bob"), ("fred"), ("bob"), ("fred"), ("fred"), ("fred")' + '\n---' + '\nEXPECTED ARGS: [any String]',
					ex.getMessage(),
					'Unexpected verify fail message'
				);
		}
	}

	/*
	*	never
	*/

	@IsTest
	private static void verifyNeverMethodHasNotBeenCalled()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob1');
		mockList.add('bob2');
		mockList.add('bob3');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add('bob');
	}

	@IsTest
	private static void verifyNeverMethodHasBeenNotCalledWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('fred', 'fred', 'fred', 'fred');
		mockList.add('fred', 'fred', 'fred', 'fred');
		mockList.add('fred', 'fred', 'fred', 'fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add(fflib_Match.anyString());
	}

	@IsTest
	private static void thatVerifyNeverFailsWhenCalledMoreTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add('bob');

			System.Assert.fail('an exception was expected');
		}
		catch (Exception exc)
		{
			assertFailMessage(exc.getMessage(), 0, 2);
		}
	}

	@IsTest
	private static void thatVerifyNeverFailsWhenCalledMoreTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add(fflib_Match.anyString());

			System.Assert.fail('an exception was expected');
		}
		catch (Exception exc)
		{
			assertFailMessage(exc.getMessage(), 0, 3);
		}
	}

	/*
	*	atLeastOnce
	*/

	@IsTest
	private static void thatVerifiesAtLeastOnce()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add('bob');
	}

	@IsTest
	private static void thatVerifiesAtLeastOnceWhenIsCalledMoreTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add('bob');
	}

	@IsTest
	private static void thatThrownExceptionIfCalledLessThanAtLeastOnce()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add('rob');

			System.Assert.fail('an exception was expected because we are asserting that the method is called one times when instead is not called');
		}
		catch (fflib_ApexMocks.ApexMocksException ex)
		{
			System
				.Assert
				.areEqual(
					'EXPECTED COUNT: 1 or more times' + '\nACTUAL COUNT: 0' + '\nMETHOD: fflib_MyList__sfdc_ApexStub.add(String)' + '\n---' + '\nACTUAL ARGS: ("bob"), ("fred"), ("bob")' + '\n---' + '\nEXPECTED ARGS: "rob"',
					ex.getMessage(),
					'Unexpected verify fail message'
				);
		}
	}

	@IsTest
	private static void thatVerifiesAtLeastOnceWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add(fflib_Match.anyString());
	}

	@IsTest
	private static void thatVerifiesAtLeastOnceWhenIsCalledMoreTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add(fflib_Match.anyString());
	}

	@IsTest
	private static void thatThrownExceptionIfCalledLessThanAtLeastOnceWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList mockList = (fflib_MyList) mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add(fflib_Match.stringStartsWith('rob'));

			System.Assert.fail('an exception was expected because we are asserting that the method is called once when instead is not called');
		}
		catch (fflib_ApexMocks.ApexMocksException ex)
		{
			System
				.Assert
				.areEqual(
					'EXPECTED COUNT: 1 or more times' + '\nACTUAL COUNT: 0' + '\nMETHOD: fflib_MyList__sfdc_ApexStub.add(String)' + '\n---' + '\nACTUAL ARGS: ("bob"), ("fred")' + '\n---' + '\nEXPECTED ARGS: [starts with "rob"]',
					ex.getMessage(),
					'Unexpected verify fail message'
				);
		}
	}

	/*
	*	HELPER METHODS
	*/

	private static void assertFailMessage(String exceptionMessage, Integer expectedInvocations, Integer actualsInvocations)
	{
		System.Assert.isTrue(exceptionMessage.startsWith('EXPECTED COUNT: ' + expectedInvocations + '\nACTUAL COUNT: ' + actualsInvocations), 'Unexpected verify fail message: ' + exceptionMessage);
	}

	/*
	*	HELPER CLASSES
	*/

	private class isOdd implements fflib_IMatcher
	{
		public Boolean matches(Object arg)
		{
			return arg instanceof Integer ? Math.mod((Integer) arg, 2) == 1 : false;
		}
	}

	private class isEven implements fflib_IMatcher
	{
		public Boolean matches(Object arg)
		{
			return arg instanceof Integer ? Math.mod((Integer) arg, 2) == 0 : false;
		}
	}
}
