/*
 Copyright (c) 2014-2017 FinancialForce.com, inc.  All rights reserved.
 */

/**
 * @group Core
 */
public with sharing class fflib_MethodCountRecorder
{
	public Boolean Verifying { get; set; }
	public Integer VerifyCount { get; set; }
	public String CustomAssertMessage { get; set; }

	public fflib_InOrder OrderedVerify { get; set; }

	/*
	 * Map of method counts by type name.
	 *
	 * Key: qualifiedMethod
	 * Object: map of method calls by method.
	 *
	 * Key: methodArgValues
	 * Object: map of count by method call argument.
	 */
	private Map<fflib_QualifiedMethod, Map<fflib_MethodArgValues, Integer>> methodCountsByTypeName;

	private static List<fflib_QualifiedMethodAndArgValues> orderedMethodCalls = new List<fflib_QualifiedMethodAndArgValues>();

	public fflib_MethodCountRecorder()
	{
		methodCountsByTypeName = new Map<fflib_QualifiedMethod, Map<fflib_MethodArgValues, Integer>>();
	}

	/**
	 * getter for the list of the methods ordered calls.
	 * @return the list of methods called in order.
	 */
	public static List<fflib_QualifiedMethodAndArgValues> getOrderedMethodCalls()
	{
		return orderedMethodCalls;
	}

	/**
	 * Verify a method was called on a mock object.
	 * @param qm The method you expect to have been called.
	 * @param methodArg The argument you expect to have been passed to the method being verified.
	 */
	public void verifyMethodCall(fflib_QualifiedMethod qm, fflib_MethodArgValues methodArg)
	{
		String assertMessage = 'Wanted but not invoked: ' + qm + '.';

		if(CustomAssertMessage != null)
		{
			assertMessage += ' ' + CustomAssertMessage;
		}

		if (OrderedVerify == null)
		{
			System.assertEquals(VerifyCount, getMethodCount(qm, methodArg), assertMessage);
		}
		else
		{
			OrderedVerify.verify(qm, methodArg, assertMessage, VerifyCount);
		}

		Verifying = false;
		CustomAssertMessage = null;

		OrderedVerify = null;
	}

	/**
	 * Record a method was called on a mock object.
	 * @param mockInstance The mock object instance.
	 * @param qm The method to be recorded.
	 * @param methodArg The method argument to be recorded.
	 */
	public void recordMethod(Object mockInstance, fflib_QualifiedMethod qm, fflib_MethodArgValues methodArg)
	{
		Map<fflib_MethodArgValues, Integer> methodCountByArgs = methodCountsByTypeName.get(qm);
		if (methodCountByArgs == null)
		{
			methodCountByArgs = new Map<fflib_MethodArgValues, Integer>();
			methodCountsByTypeName.put(qm, methodCountByArgs);
		}

		Integer currentCount = methodCountByArgs.get(methodArg);
		Integer newCount = currentCount == null ? 1 : ++currentCount;

		methodCountByArgs.put(methodArg, newCount);

		orderedMethodCalls.add(new fflib_QualifiedMethodAndArgValues(qm, methodArg, mockInstance));
	}

	private Integer getMethodCount(fflib_QualifiedMethod qm, fflib_MethodArgValues methodArg)
	{
		List<fflib_IMatcher> matchers = fflib_Match.Matching ? fflib_Match.getAndClearMatchers(methodArg.argValues.size()) : null;
		Integer retval = 0;
		Map<fflib_MethodArgValues, Integer> methodCountByArgs = methodCountsByTypeName.get(qm);
		if (methodCountByArgs != null)
		{
			if (matchers != null)
			{
				for (fflib_MethodArgValues args : methodCountByArgs.keySet())
				{
					if (fflib_Match.matchesAllArgs(args, matchers))
					{
						capture(matchers);

						retval += methodCountByArgs.get(args);
					}
				}
			}
			else if (methodCountByArgs.get(methodArg) != null)
			{
				return methodCountByArgs.get(methodArg);
			}
		}

		return retval;
	}

	private void capture(List<fflib_IMatcher> matchers)
	{
		for(fflib_IMatcher matcher : matchers)
		{
			if( matcher instanceof fflib_ArgumentCaptor.AnyObject )
			{
				((fflib_ArgumentCaptor.AnyObject)matcher).storeArgument();
			}
		}
	}
}