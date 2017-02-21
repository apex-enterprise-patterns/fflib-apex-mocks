/*
 * Copyright (c) 2017, FinancialForce.com, inc
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

/**
 * @nodoc
 */
@isTest
private class fflib_AnyOrderTest
{
	private static final String BASIC_VERIFY_ASSERTION_MESSAGE = 'Expected : {0}, Actual: {1} -- Wanted but not invoked: ';

	/*
	 *	replicating the apex mocks tests with the new syntax
	 */

	@isTest
	private static void whenVerifyMultipleCallsWithMatchersShouldReturnCorrectMethodCallCounts()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add(fflib_Match.anyString());
		((fflib_MyList.IList) mocks.verify(mockList)).add('fred');
		((fflib_MyList.IList) mocks.verify(mockList)).add(fflib_Match.stringContains('fred'));
	}

	@isTest
	private static void whenVerifyWithCombinedMatchersShouldReturnCorrectMethodCallCounts()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add(
			(String)fflib_Match.allOf(fflib_Match.eq('bob'), fflib_Match.stringContains('re'))
		);

		((fflib_MyList.IList) mocks.verify(mockList)).add(
			(String)fflib_Match.allOf(fflib_Match.eq('fred'), fflib_Match.stringContains('re'))
		);

		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add(
			(String)fflib_Match.anyOf(fflib_Match.eq('bob'), fflib_Match.eq('fred'))
		);

		((fflib_MyList.IList) mocks.verify(mockList)).add(
			(String)fflib_Match.anyOf(fflib_Match.eq('bob'), fflib_Match.eq('jack'))
		);

		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add(
			(String)fflib_Match.noneOf(fflib_Match.eq('jack'), fflib_Match.eq('tim'))
		);

		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add(
			(String)fflib_Match.noneOf(
				fflib_Match.anyOf(fflib_Match.eq('jack'), fflib_Match.eq('jill')),
				fflib_Match.allOf(fflib_Match.eq('tim'), fflib_Match.stringContains('i'))
			)
		);

		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add(
			(String)fflib_Match.isNot(fflib_Match.eq('jack'))
		);
	}

	@isTest
	private static void whenVerifyCustomMatchersCanBeUsed()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.get(1);
		mockList.get(2);
		mockList.get(3);
		mockList.get(4);
		mockList.get(5);

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(3))).get((Integer)fflib_Match.matches(new isOdd()));
		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).get((Integer)fflib_Match.matches(new isEven()));
	}

	@isTest
	private static void verifyMultipleMethodCallsWithSameSingleArgument()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add('bob');
	}

	@isTest
	private static void verifyMethodNotCalled()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.get(0);

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add('bob');
		((fflib_MyList.IList) mocks.verify(mockList)).get(0);
	}

	@isTest
	private static void verifySingleMethodCallWithMultipleArguments()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.set(0, 'bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList)).set(0, 'bob');
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).set(0, 'fred');
	}

	@isTest
	private static void verifyMethodCallWhenNoCallsBeenMadeForType()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add('bob');
	}

	@isTest
	private static void whenVerifyMethodNeverCalledMatchersAreReset()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).get(fflib_Match.anyInteger());
		((fflib_MyList.IList) mocks.verify(mockList)).add(fflib_Match.anyString());
	}

	/*
	 *	times
	 */

	@isTest
	private static void verifyTimesMethodHasBeenCalled()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(3))).add('bob');
	}

	@isTest
	private static void verifyTimesMethodHasBeenCalledWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob1');
		mockList.add('bob2');
		mockList.add('bob3');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.times(3))).add(fflib_Match.anyString());
	}

	@isTest
	private static void thatVerifyTimesMethodFailsWhenCalledLessTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.times(4))).add('bob');

			System.assert(false, 'an exception was expected');
		}
		catch(Exception exc)
		{
			assertFailMessage(exc.getMessage(), 4, 3);
		}
	}

	@isTest
	private static void thatVerifyTimesMethodFailsWhenCalledMoreTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add('bob');

			System.assert(false, 'an exception was expected');
		}
		catch(Exception exc)
		{
			assertFailMessage(exc.getMessage(), 2, 3);
		}
	}

	@isTest
	private static void thatVerifyTimesMethodFailsWhenCalledLessTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.times(4))).add(fflib_Match.anyString());

			System.assert(false, 'an exception was expected');
		}
		catch(Exception exc)
		{
			assertFailMessage(exc.getMessage(), 4, 3);
		}
	}

	@isTest
	private static void thatVerifyTimesMethodFailsWhenCalledMoreTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2))).add(fflib_Match.anyString());

			System.assert(false, 'an exception was expected');
		}
		catch(Exception exc)
		{
			assertFailMessage(exc.getMessage(), 2, 3);
		}
	}

	/*
	 *	description
	 */

	@isTest
	private static void thatCustomMessageIsAdded()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		String customAssertMessage = 'Custom message to explain the reason of the verification';

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.times(2).description(customAssertMessage))).add(fflib_Match.anyString());

			System.assert(false, 'an exception was expected');
		}
		catch(Exception exc)
		{
			String exceptionMessage = exc.getMessage();

			String expectedMessage =
				String.format(BASIC_VERIFY_ASSERTION_MESSAGE,
					new List<String>{'2', '3'}) + 'Mockfflib_MyList.add(String). ' + customAssertMessage + '.';

			System.assertEquals(expectedMessage, exceptionMessage,
				'The exception was caught, but the message was not as expected. ' +
				'Expected: [' + expectedMessage + '],  Actual: [' + exceptionMessage + '].');
		}
	}

	/*
	 *	atLeast
	 */

	@isTest
	private static void thatVerifiesAtLeastNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeast(2))).add('bob');
	}

	@isTest
	private static void thatVerifiesAtLeastNumberOfTimesWhenIsCalledMoreTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

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

	@isTest
	private static void thatThrownExceptionIfCalledLessThanAtLeastNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeast(3))).add('bob');

			System.assert(false, 'an exception was expected because we are asserting that the method is called 3 times when instead is called only twice');
		}
		catch(fflib_ApexMocks.ApexMocksException ex)
		{
			String expectedMessage = 'Expected : 3 or more times, Actual: 2 -- Wanted but not invoked: Mockfflib_MyList.add(String).';
			String actualMessage = ex.getMessage();
			System.assertEquals(expectedMessage, actualMessage,
				'the exception has been caught as expected, however the message is not as expected');
		}
	}

	@isTest
	private static void thatVerifiesAtLeastNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeast(2))).add(fflib_Match.anyString());
	}

	@isTest
	private static void thatVerifiesAtLeastNumberOfTimesWhenIsCalledMoreTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeast(2))).add(fflib_Match.anyString());
	}

	@isTest
	private static void thatThrownExceptionIfCalledLessThanAtLeastNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeast(3))).add(fflib_Match.anyString());

			System.assert(false, 'an exception was expected because we are asserting that the method is called 3 times when instead is called only twice');
		}
		catch(fflib_ApexMocks.ApexMocksException ex)
		{
			String expectedMessage = 'Expected : 3 or more times, Actual: 2 -- Wanted but not invoked: Mockfflib_MyList.add(String).';
			String actualMessage = ex.getMessage();
			System.assertEquals(expectedMessage, actualMessage,
				'the exception has been caught as expected, however the message is not as expected');
		}
	}

	/*
	 *	atMost
	 */

	@isTest
	private static void thatVerifiesAtMostNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atMost(5))).add('bob');
	}

	@isTest
	private static void thatVerifiesAtMostSameNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atMost(3))).add('bob');
	}

	@isTest
	private static void thatThrownExceptionIfCalledMoreThanAtMostNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

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

			System.assert(false, 'an exception was expected because we are asserting that the method is called 3 times when instead is called four times');
		}
		catch(fflib_ApexMocks.ApexMocksException ex)
		{
			String expectedMessage = 'Expected : 3 or fewer times, Actual: 4 -- Wanted but not invoked: Mockfflib_MyList.add(String).';
			String actualMessage = ex.getMessage();
			System.assertEquals(expectedMessage, actualMessage,
				'the exception has been caught as expected, however the message is not as expected');
		}
	}

	@isTest
	private static void thatVerifiesAtMostNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atMost(5))).add(fflib_Match.anyString());
	}

	@isTest
	private static void thatVerifiesAtMostSameNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atMost(3))).add(fflib_Match.anyString());
	}

	@isTest
	private static void thatThrownExceptionIfCalledMoreThanAtMostNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');
		mockList.add('fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atMost(3))).add(fflib_Match.anyString());

			System.assert(false, 'an exception was expected because we are asserting that the method is called 3 times when instead is called four times');
		}
		catch(fflib_ApexMocks.ApexMocksException ex)
		{
			String expectedMessage = 'Expected : 3 or fewer times, Actual: 4 -- Wanted but not invoked: Mockfflib_MyList.add(String).';
			String actualMessage = ex.getMessage();
			System.assertEquals(expectedMessage, actualMessage,
				'the exception has been caught as expected, however the message is not as expected');
		}
	}

	/*
	 *	atLeastOnce
	 */

	@isTest
	private static void thatVerifiesAtLeastOnceNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add('bob');
	}

	@isTest
	private static void thatVerifiesAtLeastOnceNumberOfTimesWhenIsCalledMoreTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add('bob');
	}

	@isTest
	private static void thatThrownExceptionIfCalledLessThanAtLeastOnceNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('rob');
		mockList.add('fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add('bob');

			System.assert(false, 'an exception was expected because we are asserting that the method is called at least once when instead is never called');
		}
		catch(fflib_ApexMocks.ApexMocksException ex)
		{
			String expectedMessage = 'Expected : 1 or more times, Actual: 0 -- Wanted but not invoked: Mockfflib_MyList.add(String).';
			String actualMessage = ex.getMessage();
			System.assertEquals(expectedMessage, actualMessage,
				'the exception has been caught as expected, however the message is not as expected');
		}
	}

	@isTest
	private static void thatVerifiesAtLeastOnceNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred', 'fred', 'fred', 'fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add(fflib_Match.anyString());
	}

	@isTest
	private static void thatVerifiesAtLeastOnceNumberOfTimesWhenIsCalledMoreTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

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

	@isTest
	private static void thatThrownExceptionIfCalledLessThanAtLeastOnceNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('fred', 'fred', 'fred', 'fred');
		mockList.add('fred', 'fred', 'fred', 'fred');
		mockList.add('fred', 'fred', 'fred', 'fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add(fflib_Match.anyString());

			System.assert(false, 'an exception was expected because we are asserting that the method is called at lest once when instead is never called');
		}
		catch(fflib_ApexMocks.ApexMocksException ex)
		{
			String expectedMessage = 'Expected : 1 or more times, Actual: 0 -- Wanted but not invoked: Mockfflib_MyList.add(String).';
			String actualMessage = ex.getMessage();
			System.assertEquals(expectedMessage, actualMessage,
				'the exception has been caught as expected, however the message is not as expected');
		}
	}

	/*
	 *	between
	 */

	@isTest
	private static void thatVerifiesBetweenNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

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

	@isTest
	private static void thatBetweenThrownExceptionIfCalledLessThanAtLeastNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.between(3, 5))).add('bob');

			System.assert(false, 'an exception was expected because we are asserting that the method is called at least 3 times when instead is called only twice');
		}
		catch(fflib_ApexMocks.ApexMocksException ex)
		{
			String expectedMessage = 'Expected : 3 or more times, Actual: 2 -- Wanted but not invoked: Mockfflib_MyList.add(String).';
			String actualMessage = ex.getMessage();
			System.assertEquals(expectedMessage, actualMessage,
				'the exception has been caught as expected, however the message is not as expected');
		}
	}

	@isTest
	private static void thatVerifiesBetweenNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.between(3, 5))).add(fflib_Match.anyString());
	}

	@isTest
	private static void thatBetweenThrownExceptionIfCalledLessThanAtLeastNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.between(3, 5))).add(fflib_Match.anyString());

			System.assert(false, 'an exception was expected because we are asserting that the method is called 3 times when instead is called only twice');
		}
		catch(fflib_ApexMocks.ApexMocksException ex)
		{
			String expectedMessage = 'Expected : 3 or more times, Actual: 2 -- Wanted but not invoked: Mockfflib_MyList.add(String).';
			String actualMessage = ex.getMessage();
			System.assertEquals(expectedMessage, actualMessage,
				'the exception has been caught as expected, however the message is not as expected');
		}
	}

	@isTest
	private static void thatBetweenThrownExceptionIfCalledMoreThanAtMostNumberOfTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

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

			System.assert(false, 'an exception was expected because we are asserting that the method is called at most 5 times when instead is called six times');
		}
		catch(fflib_ApexMocks.ApexMocksException ex)
		{
			String expectedMessage = 'Expected : 5 or fewer times, Actual: 6 -- Wanted but not invoked: Mockfflib_MyList.add(String).';
			String actualMessage = ex.getMessage();
			System.assertEquals(expectedMessage, actualMessage,
				'the exception has been caught as expected, however the message is not as expected');
		}
	}

	@isTest
	private static void thatBetweenThrownExceptionIfCalledMoreThanAtMostNumberOfTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

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

			System.assert(false, 'an exception was expected because we are asserting that the method is called 5 times when instead is called six times');
		}
		catch(fflib_ApexMocks.ApexMocksException ex)
		{

			String expectedMessage = 'Expected : 5 or fewer times, Actual: 6 -- Wanted but not invoked: Mockfflib_MyList.add(String).';
			String actualMessage = ex.getMessage();
			System.assertEquals(expectedMessage, actualMessage,
				'the exception has been caught as expected, however the message is not as expected');
		}
	}

	/*
	 *	never
	 */

	@isTest
	private static void verifyNeverMethodHasNotBeenCalled()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob1');
		mockList.add('bob2');
		mockList.add('bob3');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add('bob');
	}

	@isTest
	private static void verifyNeverMethodHasBeenNotCalledWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('fred', 'fred', 'fred', 'fred');
		mockList.add('fred', 'fred', 'fred', 'fred');
		mockList.add('fred', 'fred', 'fred', 'fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add(fflib_Match.anyString());
	}

	@isTest
	private static void thatVerifyNeverFailsWhenCalledMoreTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add('bob');

			System.assert(false, 'an exception was expected');
		}
		catch(Exception exc)
		{
			assertFailMessage(exc.getMessage(), 0, 2);
		}
	}

	@isTest
	private static void thatVerifyNeverFailsWhenCalledMoreTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.never())).add(fflib_Match.anyString());

			System.assert(false, 'an exception was expected');
		}
		catch(Exception exc)
		{
			assertFailMessage(exc.getMessage(), 0, 3);
		}
	}



	/*
	 *	atLeastOnce
	 */

	@isTest
	private static void thatVerifiesAtLeastOnce()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add('bob');
	}

	@isTest
	private static void thatVerifiesAtLeastOnceWhenIsCalledMoreTimes()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

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

	@isTest
	private static void thatThrownExceptionIfCalledLessThanAtLeastOnce()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('bob');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add('rob');

			System.assert(false, 'an exception was expected because we are asserting that the method is called one times when instead is not called');
		}
		catch(fflib_ApexMocks.ApexMocksException ex)
		{
			String expectedMessage = 'Expected : 1 or more times, Actual: 0 -- Wanted but not invoked: Mockfflib_MyList.add(String).';
			String actualMessage = ex.getMessage();
			System.assertEquals(expectedMessage, actualMessage,
				'the exception has been caught as expected, however the message is not as expected');
		}
	}

	@isTest
	private static void thatVerifiesAtLeastOnceWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add(fflib_Match.anyString());
	}

	@isTest
	private static void thatVerifiesAtLeastOnceWhenIsCalledMoreTimesWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');
		mockList.add('fred');
		mockList.add('fred');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add(fflib_Match.anyString());
	}

	@isTest
	private static void thatThrownExceptionIfCalledLessThanAtLeastOnceWithMatchers()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new fflib_Mocks.Mockfflib_MyList(mocks);

		// When
		mockList.add('bob');
		mockList.add('fred');

		// Then
		try
		{
			((fflib_MyList.IList) mocks.verify(mockList, mocks.atLeastOnce())).add(fflib_Match.stringStartsWith('rob'));

			System.assert(false, 'an exception was expected because we are asserting that the method is called once when instead is not called');
		}
		catch(fflib_ApexMocks.ApexMocksException ex)
		{
			String expectedMessage = 'Expected : 1 or more times, Actual: 0 -- Wanted but not invoked: Mockfflib_MyList.add(String).';
			String actualMessage = ex.getMessage();
			System.assertEquals(expectedMessage, actualMessage,
				'the exception has been caught as expected, however the message is not as expected');
		}
	}

	/*
	 *	HELPER METHODS
	 */

	private static void assertFailMessage(String exceptionMessage, Integer expectedInvocations, Integer actualsInvocations)
	{
		String expectedMessage =
			String.format(BASIC_VERIFY_ASSERTION_MESSAGE,
				new List<String>{String.valueOf(expectedInvocations), String.valueOf(actualsInvocations)});
		System.assert(exceptionMessage.contains(expectedMessage),
			'The exception was caught, but the message was not as expected. ' +
			'Expected: [' + expectedMessage + '],  Actual: [' + exceptionMessage + '].');
	}

	/*
	 *	HELPER CLASSES
	 */

	private class isOdd implements fflib_IMatcher
	{
		public Boolean matches(Object arg)
		{
			return arg instanceof Integer ? Math.mod((Integer)arg, 2) == 1: false;
		}
	}

	private class isEven implements fflib_IMatcher
	{
		public Boolean matches(Object arg)
		{
			return arg instanceof Integer ? Math.mod((Integer)arg, 2) == 0: false;
		}
	}
}