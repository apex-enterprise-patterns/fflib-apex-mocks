/**
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
public with sharing class fflib_MethodReturnValueRecorder
{
	public Boolean Stubbing { get; set; }

	public Exception DoThrowWhenException { get; set; }

	/**
	 * Map of method return values by type name.
	 *
	 * Key: typeName
	 * Object: map of method return values by methodName.
	 *
	 * Key: methodName
	 * Object: map of MethodReturnVakue by method call argument.
	 */
	private Map<String, Map<String, Map<Object, fflib_MethodReturnValue>>> methodReturnValuesByTypeName;

	public fflib_MethodReturnValue MethodReturnValue { get; private set; }

	public fflib_MethodReturnValueRecorder()
	{
		methodReturnValuesByTypeName = new Map<String, Map<String, Map<Object, fflib_MethodReturnValue>>>();
		MethodReturnValue = null;
	}

	/**
	 * Prepare a stubbed method return value.
	 * @param mockInstance The mock object instance.
	 * @param methodName The method for which to prepare a return value.
	 * @param methodArg The method argument for which to prepare a return value.
	 */
	public fflib_MethodReturnValue prepareMethodReturnValue(Object mockInstance, String methodName, Object methodArg)
	{
		String typeName = fflib_ApexMocks.extractTypeName(mockInstance);

		if (methodReturnValuesByTypeName.get(typeName) == null)
		{
			methodReturnValuesByTypeName.put(typeName, new Map<String, Map<Object, fflib_MethodReturnValue>>());
		}

		Map<String, Map<Object, fflib_MethodReturnValue>> methodReturnValues = methodReturnValuesByTypeName.get(typeName);

		MethodReturnValue = new fflib_MethodReturnValue();

		if (methodReturnValues.get(methodName) == null)
		{
			methodReturnValues.put(methodName, new Map<Object, fflib_MethodReturnValue>());
		}

		methodReturnValues.get(methodName).put(methodArg, MethodReturnValue);

		return MethodReturnValue;
	}

	/**
	 * Get the method return value for the given method call.
	 * @param mockInstance The mock object instance.
	 * @param methodName The method for which to prepare a return value.
	 * @param methodArg The method argument for which to prepare a return value.
	 * @return The MethodReturnValue instance.
	 */
	public fflib_MethodReturnValue getMethodReturnValue(Object mockInstance, String methodName, Object methodArg)
	{
		String typeName = fflib_ApexMocks.extractTypeName(mockInstance);

		if (methodReturnValuesByTypeName.get(typeName) != null && methodReturnValuesByTypeName.get(typeName).get(methodName) != null)
		{
			Map<Object, fflib_MethodReturnValue> foundMethod = methodReturnValuesByTypeName.get(typeName).get(methodName);
			for(Object key : foundMethod.keySet())
			{
				fflib_MethodReturnValue currentMethodReturnValue = foundMethod.get(key);

				if(testMatches(key, currentMethodReturnValue, methodArg))
				{
					return currentMethodReturnValue;
				}
			}
		}
		return null;
	}

	private boolean testMatches(Object returnValueKey, fflib_MethodReturnValue currentMethodReturnValue, Object methodArg)
	{
		List<fflib_ArgumentMatcher> matcherList = currentMethodReturnValue.Matchers;
		// This makes all the mock's work from before custom matches
		if(!currentMethodReturnValue.MatcherSet){
			return (returnValueKey == methodArg);
		}
		else
		{
			// No idea if everyone will pass a list
			// This will sort out so all the data is lists of objects
			List<Object> myListOfArgs;
			List<Object> myListOfValueKeys;
			try
			{
				myListOfArgs = (List<Object>)methodArg;
			}
			catch(Exception e)
			{
				myListOfArgs = new List<Object>();
				myListOfArgs.add(methodArg);
			}

			try
			{
				myListOfValueKeys = (List<Object>)returnValueKey;
			}
			catch(Exception e)
			{
				myListOfValueKeys = new List<Object>();
				myListOfValueKeys.add(returnValueKey);
			}

			// For now, assume they need to have one matcher per property.
			Integer matcherListSize = currentMethodReturnValue.Matchers.size();
			if(myListOfArgs.size() == matcherListSize)
			{
				Boolean myCheck = true;
				for(Integer i = 0 ; i < matcherListSize ; i ++)
				{
					if(currentMethodReturnValue.Matchers[i] instanceof Is.ArgumentMatcherExactValue)
					{
						if(myListOfArgs[i] != myListOfValueKeys[i])
						{
							myCheck = false;
							break;
						}
					}
					else if(!currentMethodReturnValue.Matchers[i].matches(myListOfArgs[i]))
					{
						myCheck = false;
						break;
					}

				}
				return myCheck;
			}
			return false;
		}
	}

	/**
	 * Prepare a stubbed exception for a void method.
	 * @param e The exception to throw.
	 */
	public void prepareDoThrowWhenException(Exception e)
	{
		DoThrowWhenException = e;
	}
}