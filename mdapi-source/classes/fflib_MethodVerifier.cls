/*
 Copyright (c) 2017 FinancialForce.com, inc.  All rights reserved.
 */

/**
 *	This class implements the actual verification.
 *	@group Core
 */
public abstract class fflib_MethodVerifier
{
	/**
	 * Verify a method was called on a mock object.
	 * @param mockInvocation The object holding all the data of the invocation, like the method and arguments and the mock instance.
	 * @param verificationMode The verification mode that holds the setting about how the verification should be performed.
	 */
	public void verifyMethodCall(fflib_InvocationOnMock mockInvocation, fflib_VerificationMode verificationMode)
	{
		validateMode(verificationMode);

		verify(mockinvocation.getMethod(), mockinvocation.getMethodArgValues(), verificationMode);
	}

	/*
	 * Method that actually performs the verify
	 * @param qm The method to be verified.
	 * @param methodArg The arguments of the method that needs to be verified.
	 * @param verificationMode The verification mode that holds the setting about how the verification should be performed.
	 */
	protected abstract void verify(
		fflib_QualifiedMethod qm,
		fflib_MethodArgValues methodArg,
		fflib_VerificationMode verificationMode);

	/*
	 * Method that validates the verification mode used in the verify.
	 * Not all the methods from the fflib_VerificationMode are implemented for the different classes that extends the fflib_MethodVerifier.
	 * The error is thrown at run time, so this method is called in the method that actually performs the verify.
	 * @param verificationMode The verification mode that has to have been verified.
	 * @throws Exception with message for the fflib_VerificationMode not implemented.
	 */
	protected abstract void validateMode(fflib_VerificationMode verificationMode);

	/*
	 * Method that performs the argument capturing.
	 * Captures argument values during verification.
	 * @param matchers The list of matcher with which a method is verified.
	 */
	protected void capture(List<fflib_IMatcher> matchers)
	{
		for(fflib_IMatcher matcher : matchers)
		{
			if( matcher instanceof fflib_ArgumentCaptor.AnyObject )
			{
				((fflib_ArgumentCaptor.AnyObject)matcher).storeArgument();
			}
		}
	}

	protected void throwException(
		fflib_QualifiedMethod qm,
		String inOrder,
		Integer expectedCount,
		String qualifier,
		Integer methodCount,
		String customAssertMessage,
		fflib_MethodArgValues expectedArguments,
		List<fflib_IMatcher> expectedMatchers,
		List<fflib_MethodArgValues> actualArguments)
	{
		String template = 'EXPECTED COUNT: {0}{1}{2}' // qualified expected count (e.g. "3 or fewer times in order")
			+ '\nACTUAL COUNT: {3}' // actual count
			+ '\nMETHOD: {4}' // method signature
			+ '{5}'; // custom assert message

		String expectedDescription = '';
		String actualDescription = '';

		if (qm.hasArguments())
		{
			template += '\n---' // separator
				+ '\nACTUAL ARGS: {6}' // actual args
				+ '\n---' // separator
				+ '\nEXPECTED ARGS: {7}'; // matcher descriptions 

			if (expectedMatchers == null)
			{
				expectedDescription = describe(expectedArguments);
			}
			else
			{
				expectedDescription = describe(expectedMatchers);
			}
			actualDescription = describe(actualArguments);
		}

		String message = String.format(template, new List<String>{
			'' + expectedCount,
			String.isBlank(qualifier) ? '' : ('' + qualifier),
			inOrder,
			'' + methodCount,
			'' + qm,
			String.isBlank(customAssertMessage) ? '' : ('\n' + customAssertMessage),
			actualDescription,
			expectedDescription
		});

		throw new fflib_ApexMocks.ApexMocksException(message);
	}

	private static String describe(List<fflib_IMatcher> matchers)
	{
		List<String> descriptions = new List<String>();
		for (fflib_IMatcher matcher : matchers)
		{
			descriptions.add('' + matcher);
		}

		return String.join(descriptions, ', ');
	}

	private static String describe(List<fflib_MethodArgValues> valuesFromAllInvocations)
	{
		List<String> descriptions = new List<String>();
		if (valuesFromAllInvocations != null)
		{
			for (fflib_MethodArgValues valuesFromOneInvocation : valuesFromAllInvocations)
			{
				descriptions.add(describe(valuesFromOneInvocation));
			}
		}

		return '(' + String.join(descriptions, '), (') + ')';
	}

	private static String describe(fflib_MethodArgValues values)
	{
		List<String> descriptions = new List<String>();
		for (Object value : values.argValues)
		{
			try
			{
				// Attempt to JSON serialize - that way it doesn't truncate SObject fields etc.
				// Bear in mind that something are not JSON serializable, e.g. things with circular references.
				descriptions.add(JSON.serialize(value));
			}
			catch (Exception error)
			{
				descriptions.add('' + value);
			}
		}

		return String.join(descriptions, ', ');
	}
}