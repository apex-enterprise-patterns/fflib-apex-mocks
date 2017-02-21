/*
 * Copyright (c) 2014, FinancialForce.com, inc
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