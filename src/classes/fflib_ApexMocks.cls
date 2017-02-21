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
public with sharing class fflib_ApexMocks
{
	public static final Integer NEVER = 0;

	private final fflib_MethodCountRecorder methodCountRecorder;
	private final fflib_MethodReturnValueRecorder methodReturnValueRecorder;

	private fflib_MethodVerifier methodVerifier;
	private fflib_VerificationMode verificationMode;

	public Boolean Verifying { get; set;	}

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
		Verifying = false;

		this.methodCountRecorder = new fflib_MethodCountRecorder();
		this.verificationMode = new fflib_VerificationMode();
		this.methodVerifier = new fflib_AnyOrder();

		this.methodReturnValueRecorder = new fflib_MethodReturnValueRecorder();

		this.methodReturnValueRecorder.Stubbing = false;
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
		return verify(mockInstance, this.times(1));
	}

	/**
	 * Verify a method was called on a mock object.
	 * @param mockInstance The mock object instance.
	 * @param verificationMode Defines the constraints for performing the verification (e.g. the minimum and maximum expected invocation counts).
	 * @return The mock object instance.
	 */
	public Object verify(Object mockInstance, fflib_VerificationMode verificationMode)
	{
		Verifying = true;
		this.verificationMode = verificationMode;

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
		return verify(mockInstance, this.times(times));
	}

	/**
	 * Verfiy a method was called on a mock object.
	 * @param qm The method you expect to have been called.
	 * @param methodArg The argument you expect to have been passed to the method being verified.
	 */
	public void verifyMethodCall(fflib_QualifiedMethod qm, fflib_MethodArgValues methodArg)
	{
		this.methodVerifier.verifyMethodCall(qm, methodArg, verificationMode);
		this.methodVerifier = new fflib_AnyOrder();
		Verifying = false;
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
	 * @param ignoredRetVal This is the return value from the method called on the mockInstance, and is ignored here since we are about to setup
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
	public void recordMethod(Object mockInstance, fflib_QualifiedMethod qm, fflib_MethodArgValues methodArg)
	{
		methodCountRecorder.recordMethod(mockInstance, qm, methodArg);
	}

	/**
	 * Prepare a stubbed method return value.
	 * @param qm The method for which to prepare a return value.
	 * @param methodArg The method argument for which to prepare a return value.
	 */
	public fflib_MethodReturnValue prepareMethodReturnValue(fflib_QualifiedMethod qm, fflib_MethodArgValues methodArg)
	{
		return methodReturnValueRecorder.prepareMethodReturnValue(qm, methodArg);
	}

	/**
	 * Get the method return value for the given method call.
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
		fflib_QualifiedMethod qm = new fflib_QualifiedMethod(extractTypeName(mockInstance), methodName, methodArgTypes);
		fflib_MethodArgValues argValues = new fflib_MethodArgValues(methodArgValues);

		if (Verifying)
		{
			verifyMethodCall(qm, argValues);
		}
		else if (Stubbing)
		{
			prepareMethodReturnValue(qm, argValues).thenThrow(DoThrowWhenException);
		}
		else
		{
			fflib_MethodReturnValue methodReturnValue = getMethodReturnValue(qm, argValues);

			if (methodReturnValue != null && methodReturnValue.ReturnValue instanceof Exception)
			{
				throw ((Exception) methodReturnValue.ReturnValue);
			}

			recordMethod(mockInstance, qm, argValues);
		}
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
			prepareMethodReturnValue(qm, argValues);
			return null;
		}
		else
		{
			recordMethod(mockInstance, qm, argValues);

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
	{

	}

	/**
	 * Sets how many times the method is expected to be called.
	 * @param times The number of times you expect the method to have been called.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode times(Integer times)
	{
		return new fflib_VerificationMode().times(times);
	}

	/**
	 * Sets how many times the method is expected to be called for an InOrder verifier. Available Only with the InOrder verification.
	 * A verification mode using calls will not fail if the method is called more times than expected.
	 * @param times The number of times you expect the method to have been called in the InOrder verifying ( no greedy verify).
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode calls(Integer times)
	{
		return new fflib_VerificationMode().calls(times);
	}

	/**
	 * Sets a custom assert message for the verify.
	 * @param customAssertMessage The custom message for the assert in case the assert is false. The custom message is queued to the default message.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode description(String customAssertMessage)
	{
		return new fflib_VerificationMode().description(customAssertMessage);
	}

	/**
	 * Sets the minimum number of times the method is expected to be called.
	 * @param atLeastTimes The minimum number of times you expect the method to have been called.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode atLeast(Integer atLeastTimes)
	{
		return new fflib_VerificationMode().atLeast(atLeastTimes);
	}

	/**
	 * Sets the maximum number of times the method is expected to be called.
	 * @param atMostTimes The maximum number of times the method is expected to be called.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode atMost(Integer atMostTimes)
	{
		return new fflib_VerificationMode().atMost(atMostTimes);
	}

	/**
	 * Sets that the method is called at least once.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode atLeastOnce()
	{
		return new fflib_VerificationMode().atLeastOnce();
	}

	/**
	 * Sets the range of how many times the method is expected to be called.
	 * @param atLeastTimes The minimum number of times you expect the method to have been called.
	 * @param atMostTimes The maximum number of times the method is expected to be called.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode between(Integer atLeastTimes, Integer atMostTimes)
	{
		return new fflib_VerificationMode().between(atLeastTimes, atMostTimes);
	}

	/**
	 * Sets that the method is not expected to be called.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode never()
	{
		return new fflib_VerificationMode().never();
	}

	/**
	 * Sets the fflib_VerificationMode object.
	 * To internal use only.
	 * Used to pass the verification mode that has been set in the  verify of the fflib_InOrder class.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public void setOrderedVerifier(fflib_InOrder verifyOrderingMode)
	{
		this.methodVerifier = verifyOrderingMode;
	}
}