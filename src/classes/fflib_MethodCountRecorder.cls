/*
 Copyright (c) 2014-2017 FinancialForce.com, inc.  All rights reserved.
 */

/**
 * @group Core
 */
public with sharing class fflib_MethodCountRecorder
{
	/*
	 * Map of method counts by type name.
	 *
	 * Key: qualifiedMethod
	 * Object: map of method calls by method.
	 *
	 * Key: methodArgValues
	 * Object: map of count by method call argument.
	 */
	private static Map<fflib_QualifiedMethod, Map<fflib_MethodArgValues, Integer>> methodCountsByTypeName =
		new Map<fflib_QualifiedMethod, Map<fflib_MethodArgValues, Integer>>();

	private static List<fflib_QualifiedMethodAndArgValues> orderedMethodCalls =
		new List<fflib_QualifiedMethodAndArgValues>();

	/**
	 * getter for the list of the methods ordered calls.
	 * @return the list of methods called in order.
	 */
	public static List<fflib_QualifiedMethodAndArgValues> getOrderedMethodCalls()
	{
		return orderedMethodCalls;
	}

	/**
	 * Getter for the map of the method's calls with the related arguments.
	 * @return The map of methods called with the arguments.
	 */
	public static Map<fflib_QualifiedMethod, Map<fflib_MethodArgValues, Integer>> getMethodCountsByTypeName()
	{
		return methodCountsByTypeName;
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
}