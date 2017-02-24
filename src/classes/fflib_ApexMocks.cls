/*
 * Copyright (c) 2014-2017 FinancialForce.com, inc.  All rights reserved.
 */
public with sharing class fflib_ApexMocks implements System.StubProvider
{
	public static final Integer NEVER = 0;

	private final fflib_MethodCountRecorder methodCountRecorder;
	private final fflib_MethodReturnValueRecorder methodReturnValueRecorder;

	public Boolean Verifying
	{
		get
		{
			return methodCountRecorder.Verifying;
		}

		private set;
	}

	public Boolean Stubbing
	{
		get
		{
			return methodReturnValueRecorder.Stubbing;
		}

		private set;
	}

	public Exception DoThrowWhenException
	{
		get
		{
			return methodReturnValueRecorder.DoThrowWhenException;
		}

		set
		{
			methodReturnValueRecorder.DoThrowWhenException = value;
		}
	}

	/**
	 * Construct an ApexMocks instance.
	 */
	public fflib_ApexMocks()
	{
		methodCountRecorder = new fflib_MethodCountRecorder();
		methodReturnValueRecorder = new fflib_MethodReturnValueRecorder();

		methodCountRecorder.Verifying = false;
		methodReturnValueRecorder.Stubbing = false;
	}

	/**
     * Creates mock object of given class or interface.
     * @param classToMock class or interface to mock.
     * @return mock object.
     */
	public Object mock(Type classToMock)
	{
		return Test.createStub(classToMock, this);
	}

	/**
	 * Inherited from StubProvider.
	 * @param stubbedObject The stubbed object.
	 * @param stubbedMethodName The name of the invoked method.
	 * @param returnType The return type of the invoked method.
	 * @param listOfParamTypes A list of the parameter types of the invoked method.
	 * @param listOfParamNames A list of the parameter names of the invoked method.
	 * @param listOfArgs The actual argument values passed into this method at runtime.
	 * @return The stubbed return value. Null by default, unless you prepared one that matches this method and argument values in stubbing.
	 */
	public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, Type returnType,
		List<type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs)
    {
        return mockNonVoidMethod(stubbedObject, stubbedMethodName, listOfParamTypes, listOfArgs);
    }

	public static String extractTypeName(Object mockInstance)
	{
		return String.valueOf(mockInstance).split(':').get(0);
	}

	/**
	 * Verify a method was called on a mock object.
	 * @param mockInstance The mock object instance.
	 * @return The mock object instance.
	 */
	public Object verify(Object mockInstance)
	{
		return verify(mockInstance, 1);
	}

	/**
	 * Verify a method was called on a mock object.
	 * @param mockInstance The mock object instance.
	 * @param times The number of times you expect the method to have been called.
	 * @return The mock object instance.
	 */
	public Object verify(Object mockInstance, Integer times)
	{
		methodCountRecorder.Verifying = true;
		methodCountRecorder.VerifyCount = times;
		return mockInstance;
	}

	/**
	 * Verfiy a method was called on a mock object.
	 * @param mockInstance The mock object instance.
	 * @param qm The method you expect to have been called.
	 * @param methodArg The argument you expect to have been passed to the method being verified.
	 */
	public void verifyMethodCall(fflib_QualifiedMethod qm, fflib_MethodArgValues methodArg)
	{
		methodCountRecorder.verifyMethodCall(qm, methodArg);
	}

	/**
	 * Tell ApexMocks framework you are about to start stubbing using when() calls.
	 */
	public void startStubbing()
	{
		methodReturnValueRecorder.Stubbing = true;
	}

	/**
	 * Tell ApexMocks framework you are about to stop stubbing using when() calls.
	 */
	public void stopStubbing()
	{
		methodReturnValueRecorder.Stubbing = false;
	}

	/**
	 * Setup when stubbing for a mock object instance.
	 * @param This is the return value from the method called on the mockInstance, and is ignored here since we are about to setup
	 *        the stubbed return value using thenReturn() (see MethodReturnValue class below).
	 */
	public fflib_MethodReturnValue when(Object ignoredRetVal)
	{
		return methodReturnValueRecorder.MethodReturnValue;
	}

	/**
	 * Record a method was called on a mock object.
	 * @param mockInstance The mock object instance.
	 * @param qm The method to be recorded.
	 * @param methodArg The method argument to be recorded.
	 */
	public void recordMethod(fflib_QualifiedMethod qm, fflib_MethodArgValues methodArg)
	{
		methodCountRecorder.recordMethod(qm, methodArg);
	}

	/**
	 * Prepare a stubbed method return value.
	 * @param mockInstance The mock object instance.
	 * @param qm The method for which to prepare a return value.
	 * @param methodArg The method argument for which to prepare a return value.
	 */
	public fflib_MethodReturnValue prepareMethodReturnValue(fflib_QualifiedMethod qm, fflib_MethodArgValues methodArg)
	{
		return methodReturnValueRecorder.prepareMethodReturnValue(qm, methodArg);
	}

	/**
	 * Get the method return value for the given method call.
	 * @param mockInstance The mock object instance.
	 * @param qm The method for which to prepare a return value.
	 * @param methodArg The method argument for which to prepare a return value.
	 * @return The MethodReturnValue instance.
	 */
	public fflib_MethodReturnValue getMethodReturnValue(fflib_QualifiedMethod qm, fflib_MethodArgValues methodArg)
	{
		return methodReturnValueRecorder.getMethodReturnValue(qm, methodArg);
	}

	/**
	 * Setup exception stubbing for a void method.
	 * @param e The exception to throw.
	 * @param mockInstance The mock object instance.
	 */
	public Object doThrowWhen(Exception e, Object mockInstance)
	{
		methodReturnValueRecorder.prepareDoThrowWhenException(e);
		return mockInstance;
	}

	/**
	 * Mock a void method. Called by generated mock instance classes, not directly by a developers
	 * code.
	 * @param mockInstance The mock object instance.
	 * @param methodName The method for which to prepare a return value.
	 * @param methodArgTypes The method argument types for which to prepare a return value.
	 * @param methodArgValues The method argument values for which to prepare a return value.
	 */
	public void mockVoidMethod(Object mockInstance, String methodName, List<Type> methodArgTypes, List<Object> methodArgValues)
	{
		//Ideally, we would supersede all calls to mockVoidMethod with mockNonVoidMethod and ignore the return value.
		//However, retaining mockVoidMethod for backwards compatibility.
		mockNonVoidMethod(mockInstance, methodName, methodArgTypes, methodArgValues);
	}

	/**
	 * Mock a non-void method. Called by generated mock instance classes, not directly by a developers
	 * code.
	 * @param mockInstance The mock object instance.
	 * @param methodName The method for which to prepare a return value.
	 * @param methodArgTypes The method argument types for which to prepare a return value.
	 * @param methodArgValues The method argument values for which to prepare a return value.
	 */
	public Object mockNonVoidMethod(Object mockInstance, String methodName, List<Type> methodArgTypes, List<Object> methodArgValues)
	{
		fflib_QualifiedMethod qm = new fflib_QualifiedMethod(extractTypeName(mockInstance), methodName, methodArgTypes);
		fflib_MethodArgValues argValues = new fflib_MethodArgValues(methodArgValues);
		
		if (Verifying)
		{
			verifyMethodCall(qm, argValues);
		}
		else if (Stubbing)
		{
			prepareMethodReturnValue(qm, argValues).thenThrow(DoThrowWhenException);
			DoThrowWhenException = null;
			return null;
		}
		else
		{
			recordMethod(qm, argValues);

			fflib_MethodReturnValue methodReturnValue = getMethodReturnValue(qm, argValues);

			if (methodReturnValue != null && methodReturnValue.ReturnValue != null)
			{
				if (methodReturnValue.ReturnValue instanceof Exception)
				{
					throw ((Exception) methodReturnValue.ReturnValue);
				}

				return methodReturnValue.ReturnValue;
			}
		}

		return null;
	}
	
	public class ApexMocksException extends Exception
	{}
}