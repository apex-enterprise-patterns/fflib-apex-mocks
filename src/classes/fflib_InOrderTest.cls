/*
 * Copyright (c) 2017 FinancialForce.com, inc
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
private class fflib_InOrderTest
{
	private static final String EXPECTED_ERROR_MESSAGE_INCIPIT = 'In Order: Wanted but not invoked: ';

	@isTest
	static void thatVerifyInOrderAllTheMethodsCalled()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When
		firstMock.add('1-1');
		firstMock.add('1-2');
		firstMock.add('1-3');
		firstMock.add('1-4');

		// Then
		((fflib_MyList.IList)inOrder1.verify(firstMock)).add('1-1');
		((fflib_MyList.IList)inOrder1.verify(firstMock)).add('1-2');
		((fflib_MyList.IList)inOrder1.verify(firstMock)).add('1-3');
		((fflib_MyList.IList)inOrder1.verify(firstMock)).add('1-4');

		assertVerifyInOrderExceptionForAddMethod('1-2', inOrder1, firstMock,
			'It should fail because 1-2 is in the wrong order');
	}

	@isTest
	static void thatVerifyInOrderDifferentMethodsCalledWithSameArguments()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When
		firstMock.add('1-1');
		firstMock.addMore('1-1');
		firstMock.add('1-2');
		firstMock.addMore('1-2');
		firstMock.add('1-3');
		firstMock.addMore('1-3');
		firstMock.add('1-4');
		firstMock.addMore('1-4');

		// Then
		((fflib_MyList.IList)inOrder1.verify(firstMock)).add('1-1');
		((fflib_MyList.IList)inOrder1.verify(firstMock)).addMore('1-1');
		((fflib_MyList.IList)inOrder1.verify(firstMock)).addMore('1-3');
		((fflib_MyList.IList)inOrder1.verify(firstMock)).add('1-4');
	}

	@isTest
	static void thatVerifyInOrderDifferentMethodsCalledWithSameArgumentsOrderFail()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When
		firstMock.add('1-1');
		firstMock.addMore('1-1');
		firstMock.add('1-2');
		firstMock.addMore('1-2');

		// Then
		((fflib_MyList.IList)inOrder1.verify(firstMock)).addMore('1-1');

		assertVerifyInOrderExceptionForAddMethod('1-1', inOrder1, firstMock,
			'It should fail because 1-1 is called before the addMore(1-1)');
	}

	@isTest
	static void thatVerifyInOrderDifferentMethodsCalledWithSameArgumentsDoubleCallFail()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When
		firstMock.add('1-1');
		firstMock.addMore('1-1');
		firstMock.add('1-2');
		firstMock.addMore('1-2');

		// Then
		((fflib_MyList.IList)inOrder1.verify(firstMock)).addMore('1-1');

		assertVerifyInOrderExceptionForAddMoreMethod('1-1', inOrder1, firstMock,
			'It should fail because addMore(1-1) is called only Once');
	}

	@isTest
	static void thatVerifyInOrderCallMethodWithMatches()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When
		firstMock.add('1-0');
		firstMock.add('1-11');
		firstMock.add('1-12');
		firstMock.add('1-3');
		firstMock.add('1-4');

		// Then
		((fflib_MyList.IList)inOrder1.verify(firstMock, 2)).add(fflib_Match.stringStartsWith('1-1'));
		((fflib_MyList.IList)inOrder1.verify(firstMock)).add('1-4');
	}

	@isTest
	static void thatVerifyInOrderCallMethodWithMatchesFailsIfVerifyACallAlreadyInTheMatcher()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When
		firstMock.add('1-0');
		firstMock.add('1-11');
		firstMock.add('1-12');
		firstMock.add('1-3');
		firstMock.add('1-4');

		// Then
		((fflib_MyList.IList)inOrder1.verify(firstMock, 2)).add(fflib_Match.stringStartsWith('1-1'));
		((fflib_MyList.IList)inOrder1.verify(firstMock)).add('1-4');

		assertVerifyInOrderExceptionForAddMethod('1-11', inOrder1, firstMock,
			'It should fail because addMore(1-11) has been already verified using the matchers');
	}

	@isTest
	static void thatVerifyInOrderCallMethodWithMultipleMatches()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When

		firstMock.add('1-0');
		firstMock.add('1-1');
		firstMock.add('1-3');
		firstMock.add('1-4');


		firstMock.add('2-0');
		firstMock.add('2-1');
		firstMock.add('2-3');
		firstMock.add('2-4');

		// Then
		((fflib_MyList.IList)inOrder1.verify(firstMock, 4)).add(fflib_Match.stringStartsWith('1-'));
		((fflib_MyList.IList)inOrder1.verify(firstMock, 4)).add(fflib_Match.stringStartsWith('2-'));
	}

	@isTest
	static void thatVerifyInOrderCallMethodWithMultipleMatchesMixed()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When
		firstMock.add('1-1');
		firstMock.add('2-1');
		firstMock.add('1-2');
		firstMock.add('2-2');
		firstMock.add('1-3');
		firstMock.add('2-3');
		firstMock.add('1-4');
		firstMock.add('2-4');

		// Then
		((fflib_MyList.IList)inOrder1.verify(firstMock, 4)).add(fflib_Match.stringStartsWith('1-'));
		((fflib_MyList.IList)inOrder1.verify(firstMock)).add(fflib_Match.stringStartsWith('2-'));
	}

	@isTest
	static void thatVerifyInOrderCallMethodWithMultipleMatchesMixedFailWhenMatcherHaveAlreadyVerifiedMethod()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When
		firstMock.add('1-1');
		firstMock.add('2-1');
		firstMock.add('1-2');
		firstMock.add('2-2');
		firstMock.add('1-3');
		firstMock.add('2-3');
		firstMock.add('1-4');
		firstMock.add('2-4');

		// Then
		((fflib_MyList.IList)inOrder1.verify(firstMock, 4)).add(fflib_Match.stringStartsWith('1-'));

		assertVerifyInOrderExceptionForAddMethod('1-11', 4, inOrder1, firstMock,
			'It should fail because only one call for the 2- is available to verify');
	}

	@isTest
	static void thatVerifyInOrderCanSkipMethodsCalledUntilFindTheOneThatNeedsVerify()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When
		firstMock.add('1-1');
		firstMock.add('1-2');
		firstMock.add('1-3');
		firstMock.add('1-4');

		// Then
		((fflib_MyList.IList)inOrder1.verify(firstMock)).add('1-1');
		((fflib_MyList.IList)inOrder1.verify(firstMock)).add('1-4');

		assertVerifyInOrderExceptionForAddMethod('1-2', inOrder1, firstMock,
			'It should fail because is out of order');
	}

	@isTest
	static void thatVerifyInOrderCanHandleMultipleMethodsCalls()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When
		firstMock.add('1-1');
		firstMock.add('1-2');
		firstMock.add('1-2');
		firstMock.add('1-2');
		firstMock.add('1-3');
		firstMock.add('1-4');

		// Then
		((fflib_MyList.IList)inOrder1.verify(firstMock, 3)).add('1-2');
		((fflib_MyList.IList)inOrder1.verify(firstMock)).add('1-4');
	}

	@isTest
	static void thatVerifyInOrderCanHandleMultipleMethodsCallsAndNotFailsIfVerifyCountIsGreaterThenExpected()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When
		firstMock.add('1-1');
		firstMock.add('1-2');
		firstMock.add('1-2');
		firstMock.add('1-2');
		firstMock.add('1-3');
		firstMock.add('1-4');

		// Then

		((fflib_MyList.IList)inOrder1.verify(firstMock, 2)).add('1-2');
	}

	@isTest
	static void thatVerifyInOrderCanHandleMultipleMethodsCallsButFailsIfVerifyCountIsLessThenExpected()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When
		firstMock.add('1-1');
		firstMock.add('1-2');
		firstMock.add('1-2');
		firstMock.add('1-2');
		firstMock.add('1-3');
		firstMock.add('1-4');

		// Then

		assertVerifyInOrderExceptionForAddMethod('1-2', 4, inOrder1, firstMock,
			'It should fail because is actually called only 3 times');
	}

	@isTest
	static void thatVerifyInOrderCanHandleMultipleMocks()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_MyList.IList secondMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_MyList.IList thirdMock = new fflib_Mocks.Mockfflib_MyList(mocks);

		fflib_InOrder inOrder = new fflib_InOrder(mocks, new List<Object>{ firstMock, secondMock });

		// When
		firstMock.add('1-1');
		secondMock.add('2-1');
		thirdMock.add('3-1');

		firstMock.add('1-2');
		secondMock.add('2-2');
		thirdMock.add('3-2');

		firstMock.add('1-1');
		firstMock.add('1-3');
		secondMock.add('2-3');
		thirdMock.add('3-3');

		// Then
		((fflib_MyList.IList)inOrder.verify(firstMock)).add('1-1');
		((fflib_MyList.IList)inOrder.verify(secondMock)).add('2-1');
		((fflib_MyList.IList)inOrder.verify(firstMock)).add('1-2');
		((fflib_MyList.IList)inOrder.verify(secondMock)).add('2-2');
		((fflib_MyList.IList)inOrder.verify(firstMock)).add('1-3');
		((fflib_MyList.IList)inOrder.verify(secondMock)).add('2-3');

		((fflib_MyList.IList)mocks.verify(thirdMock, 3)).add(fflib_Match.stringStartsWith('3-'));
	}

	@isTest
	static void thatVerifyInOrderCanHandleMixedInOrderInstance()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_MyList.IList secondMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_MyList.IList thirdMock = new fflib_Mocks.Mockfflib_MyList(mocks);

		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });
		fflib_InOrder inOrder2 = new fflib_InOrder(mocks, new List<Object>{ firstMock, secondMock });

		// When
		firstMock.add('1-1');
		secondMock.add('2-1');
		thirdMock.add('3-1');

		firstMock.add('1-2');
		secondMock.add('2-2');
		thirdMock.add('3-2');

		firstMock.add('1-1');
		firstMock.add('1-3');
		secondMock.add('2-3');
		thirdMock.add('3-3');

		// Then
		((fflib_MyList.IList)inOrder1.verify(firstMock, 2)).add('1-1');
		((fflib_MyList.IList)inOrder1.verify(firstMock)).add('1-3');


		((fflib_MyList.IList)inOrder2.verify(firstMock)).add('1-1');

		((fflib_MyList.IList)inOrder2.verify(firstMock)).add('1-2');
		((fflib_MyList.IList)inOrder2.verify(secondMock)).add('2-2');
		((fflib_MyList.IList)inOrder2.verify(firstMock)).add('1-3');
		((fflib_MyList.IList)inOrder2.verify(secondMock)).add('2-3');

		((fflib_MyList.IList)mocks.verify(thirdMock, 3)).add(fflib_Match.stringStartsWith('3-'));
	}

	@isTest
	static void thatVerifyInOrderThrownExceptionIfVerifyMockInstanceNotInTheSet()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);
		fflib_MyList.IList secondMock = new fflib_Mocks.Mockfflib_MyList(mocks);

		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		// When
		firstMock.add('1-1');
		secondMock.add('2-1');

		// Then
		assertVerifyInOrderExceptionForAddMethod('2-1', inOrder1, secondMock,
			'It should fail because secondMock is not included in the set of the mock instances to verify');
	}

	@isTest
	static void thatVerifyInOrderThrownExceptionWithCustomMessage()
	{
		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_MyList.IList firstMock = new fflib_Mocks.Mockfflib_MyList(mocks);

		fflib_InOrder inOrder1 = new fflib_InOrder(mocks, new List<Object>{ firstMock });

		String customErrorMesage = 'Some custom error message';

		// When
		firstMock.add('1-1');
		firstMock.add('1-2');

		((fflib_MyList.IList)inOrder1.verify(firstMock)).add('1-2');
		// Then
		try
		{
			((fflib_MyList.IList)inOrder1.verify(firstMock, customErrorMesage)).add('1-1');
			System.assert(false, 'expected some exception ');
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.assertEquals(
				EXPECTED_ERROR_MESSAGE_INCIPIT +'Mockfflib_MyList.add(String). ' + customErrorMesage,
				e.getMessage(),
				'the verify throw an Exception, but the message is not as expected');
		}
	}

	private static void assertVerifyInOrderExceptionForAddMethod(
		String argument, Integer expectedTimes, fflib_InOrder inOrderInstance, fflib_MyList.IList mockToVerify, String expectedFailingReasson)
	{
		try
		{
			((fflib_MyList.IList)inOrderInstance.verify(mockToVerify, expectedTimes)).add(argument);
			System.assert(false, 'expected some exception ' + expectedFailingReasson);
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.assert(e.getMessage().startsWith(EXPECTED_ERROR_MESSAGE_INCIPIT),
				'the verify throw an Exception, but the message is not as expected. Expected: ' +
				EXPECTED_ERROR_MESSAGE_INCIPIT + ', Actual: ' +e.getMessage());
		}
	}

	private static void assertVerifyInOrderExceptionForAddMethod(
		String argument, fflib_InOrder inOrderInstance, fflib_MyList.IList mockToVerify, String expectedFailingReasson)
	{
		assertVerifyInOrderExceptionForAddMethod( argument, 1, inOrderInstance, mockToVerify, expectedFailingReasson);
	}

	private static void assertVerifyInOrderExceptionForAddMoreMethod(
		String argument, fflib_InOrder inOrderInstance, fflib_MyList.IList mockToVerify, String expectedFailingReasson)
	{
		try
		{
			((fflib_MyList.IList)inOrderInstance.verify(mockToVerify)).addMore(argument);
			System.assert(false, 'expected some exception ' + expectedFailingReasson);
		}
		catch (fflib_ApexMocks.ApexMocksException e)
		{
			System.assert(e.getMessage().startsWith(EXPECTED_ERROR_MESSAGE_INCIPIT),
				'the verify throw an Exception, but the message is not as expected. Expected: ' +
				EXPECTED_ERROR_MESSAGE_INCIPIT + ', Actual: ' +e.getMessage());
		}
	}
}