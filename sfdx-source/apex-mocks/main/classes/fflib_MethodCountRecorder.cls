/*
Copyright (c) 2014-2017 FinancialForce.com, inc.  All rights reserved.
*/

/**
 * @group Core
 */
@NamespaceAccessible
public with sharing class fflib_MethodCountRecorder
{
	/*
	* Map of method arguments by type name.
	*
	* Key: qualifiedMethod
	* Object: list of method arguments.
	*
	* Object: map of count by method call argument.
	*/
	private final Map<fflib_QualifiedMethod, List<fflib_MethodArgValues>> methodArgumentsByTypeName = new Map<fflib_QualifiedMethod, List<fflib_MethodArgValues>>();

	private final List<fflib_InvocationOnMock> orderedMethodCalls = new List<fflib_InvocationOnMock>();

	private static final fflib_MethodCountRecorder STATIC_RECORDER = new fflib_MethodCountRecorder();

	/**
	 * Getter for the list of the methods ordered calls.
	 * @return The list of methods called in order.
	 */
	public List<fflib_InvocationOnMock> getInstanceOrderedMethodCalls()
	{
		return orderedMethodCalls;
	}

	/**
	 * Getter for the map of the method's calls with the related arguments.
	 * @return The map of methods called with the arguments.
	 */
	public Map<fflib_QualifiedMethod, List<fflib_MethodArgValues>> getInstanceMethodArgumentsByTypeName()
	{
		return methodArgumentsByTypeName;
	}

	/**
	 * Getter for the list of the methods ordered calls.
	 * @return The list of methods called in order.
	 * @deprecated Use {@link #getInstanceOrderedMethodCalls()} instead.
	 */
	public static List<fflib_InvocationOnMock> getOrderedMethodCalls()
	{
		return STATIC_RECORDER.getInstanceOrderedMethodCalls();
	}

	/**
	 * Getter for the map of the method's calls with the related arguments.
	 * @return The map of methods called with the arguments.
	 * @deprecated Use {@link #getInstanceMethodArgumentsByTypeName()} instead.
	 */
	public static Map<fflib_QualifiedMethod, List<fflib_MethodArgValues>> getMethodArgumentsByTypeName()
	{
		return STATIC_RECORDER.getInstanceMethodArgumentsByTypeName();
	}

	/**
	 * Record a method was called on a mock object.
	 * @param invocation The object holding all the data of the invocation, like the method and arguments and the mock instance.
	 */
	public void recordMethod(fflib_InvocationOnMock invocation)
	{
		// Primary, async-safe recording lives on this instance (held by the owning
		// fflib_ApexMocks), so it survives Platform Event triggered async flows.
		record(invocation);

		// Also mirror into the static singleton so the deprecated static getters
		// retain their historical (globally shared) behaviour for callers that
		// still rely on the published static API.
		if (this != STATIC_RECORDER)
		{
			STATIC_RECORDER.record(invocation);
		}
	}

	private void record(fflib_InvocationOnMock invocation)
	{
		List<fflib_MethodArgValues> methodArgs = methodArgumentsByTypeName.get(invocation.getMethod());

		if (methodArgs == null)
		{
			methodArgs = new List<fflib_MethodArgValues>();
			methodArgumentsByTypeName.put(invocation.getMethod(), methodArgs);
		}

		methodArgs.add(invocation.getMethodArgValues());

		orderedMethodCalls.add(invocation);
	}
}
