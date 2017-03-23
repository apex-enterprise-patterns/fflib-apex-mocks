/*
 Copyright (c) 2017 FinancialForce.com, inc.  All rights reserved.
 */


/**
 * @group Core
 */
public with sharing class fflib_InOrder
{
	private final List<Object> unorderedMockInstances;
	private Integer idxMethodCall = 0;

	private final fflib_ApexMocks mocks;

	/**
	 * Construct the InOrder instance.
	 * @param mocks The apex mock object instance.
	 * @param unorderedMockInstances One or more mock implementation classes (listed in any order), whose ordered method calls require verification.
	 */
	public fflib_InOrder(fflib_ApexMocks mocks, List<Object> unorderedMockInstances)
	{
		this.unorderedMockInstances = unorderedMockInstances;
		this.mocks = mocks;
	}

	/**
	 * Verify a method was called on a mock object.
	 * @param mockInstance The mock object instance.
	 * @return The mock object instance.
	 */
	public Object verify(Object mockInstance)
	{
		mocks.verify(mockInstance, 1, null, this);
		return mockInstance;
	}

	/**
	 * Verify a method was called on a mock object.
	 * @param mockInstance The mock object instance.
	 * @param times The number of times you expect the method to have been called.
	 * @return The mock object instance.
	 */
	public Object verify(Object mockInstance, Integer times)
	{
		mocks.verify(mockInstance, times, null, this);
		return mockInstance;
	}

	/**
	 * Verify a method was called on a mock object.
	 * @param mockInstance The mock object instance.
	 * @param customAssertMessage The Custom message for the assert in case the assert is false to be queued to the default message.
	 * @return The mock object instance.
	 */
	public Object verify(Object mockInstance, String customAssertMessage)
	{
		mocks.verify(mockInstance, 1, customAssertMessage, this);
		return mockInstance;
	}

	/**
	 * Verify a method was called on a mock object.
	 * @param mockInstance The mock object instance.
	 * @param times The number of times you expect the method to have been called.
	 * @param customAssertMessage The Custom message for the assert in case the assert is false to be queued to the default message.
	 * @return The mock object instance.
	 */
	public Object verify(Object mockInstance, Integer times, String customAssertMessage)
	{
		mocks.verify(mockInstance, times, customAssertMessage, this);
		return mockInstance;
	}

	private fflib_QualifiedMethodAndArgValues getNextMethodCall()
	{
		Integer idx = 0;

		for (fflib_QualifiedMethodAndArgValues qm : fflib_MethodCountRecorder.getOrderedMethodCalls())
		{
			for (Object mockInstance : unorderedMockInstances)
			{
				if (qm.getMockInstance() === mockInstance)
				{
					if (idx == idxMethodCall)
					{
						idxMethodCall++;
						return qm;
					}
					else
					{
						idx++;
					}
				}
			}
		}

		return null;
	}

	private Boolean argumentsMatch(fflib_MethodArgValues calledMethodArg, List<fflib_IMatcher> matchers, fflib_MethodArgValues methodArg)
	{
		//Check it was called with the right args.
		if (matchers != null)
		{
			if(fflib_Match.matchesAllArgs(calledMethodArg, matchers))
			{
				//Return now we've matched the method call
				return true;
			}
		}
		else if(calledMethodArg == methodArg)
		{
			//Return now we've matched the method call
			return true;
		}

		return false;
	}

	/**
	 * Method that actually perform the verify
	 * @param qualifiedMethod The method to be verified.
	 * @param methodArg The arguments of the method that needs to be verified.
	 * @param assertMessage The message to return in the exception in case the verify fails.
	 * @param verifyCount Number of times the method is expected to be called.
	 * @return The Boolean that indicated if the verify is Strictly.
	 */
	public void verify(fflib_QualifiedMethod qm, fflib_MethodArgValues methodArg, String assertMessage, Integer verifyCount)
	{
		assertMessage = 'In Order: ' + assertMessage;

		List<fflib_IMatcher> matchers = fflib_Match.Matching ? fflib_Match.getAndClearMatchers(methodArg.argValues.size()) : null;

		for (Integer i=1; i<=verifyCount; i++)
		{
			verifyMethodCalledInOrder(matchers, qm, methodArg, assertMessage);
		}
	}

	private void verifyMethodCalledInOrder(
		List<fflib_IMatcher> matchers,
		fflib_QualifiedMethod qm,
		fflib_MethodArgValues methodArg,
		String assertMessage)
	{
		fflib_QualifiedMethodAndArgValues calledMethod = getNextMethodCall();
		while(calledMethod != null)
		{
			if(calledMethod.getQualifiedMethod() == qm &&
				argumentsMatch(calledMethod.getMethodArgValues(), matchers, methodArg))
			{
				//it's our method
				return;
			}

			calledMethod = getNextMethodCall();
		}

		//No further method calls => no match
		throw new fflib_ApexMocks.ApexMocksException(assertMessage);
	}

}