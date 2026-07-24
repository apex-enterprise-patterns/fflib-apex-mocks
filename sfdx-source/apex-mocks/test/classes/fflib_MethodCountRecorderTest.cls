/*
Copyright (c) 2014-2017 FinancialForce.com, inc.  All rights reserved.
*/

/**
 * @nodoc
 *
 * Regression coverage for the backward-compatible (deprecated) entry points retained
 * when fflib_MethodCountRecorder moved to instance based recording:
 * - the static getOrderedMethodCalls() / getMethodArgumentsByTypeName() getters, and
 * - the no-arg fflib_AnyOrder() constructor that falls back to the static recorder.
 * These paths are not exercised by the rest of the suite (everything internal now uses
 * the instance API), so this class guards against them silently regressing.
 */
@IsTest
private class fflib_MethodCountRecorderTest
{
	@IsTest
	private static void recordMethodPopulatesInstanceState()
	{
		// Given
		fflib_QualifiedMethod qm = new fflib_QualifiedMethod('MyType', 'myMethod', new List<Type>{ String.class });
		fflib_InvocationOnMock invocation = buildInvocation(qm, 'bob');
		fflib_MethodCountRecorder recorder = new fflib_MethodCountRecorder();

		// When
		recorder.recordMethod(invocation);

		// Then
		System.Assert.areEqual(1, recorder.getInstanceOrderedMethodCalls().size(), 'The invocation should be recorded against the instance ordered calls');
		System.Assert.isTrue(recorder.getInstanceMethodArgumentsByTypeName().containsKey(qm), 'The instance arguments map should contain the recorded method');
	}

	@IsTest
	private static void recordMethodMirrorsIntoDeprecatedStaticGetters()
	{
		// Given the static getters start empty for this transaction
		System.Assert.isTrue(fflib_MethodCountRecorder.getOrderedMethodCalls().isEmpty(), 'The static ordered calls should start empty');

		fflib_QualifiedMethod qm = new fflib_QualifiedMethod('MyType', 'myMethod', new List<Type>{ String.class });
		fflib_InvocationOnMock invocation = buildInvocation(qm, 'bob');

		// When recording through an instance (as fflib_ApexMocks does)
		new fflib_MethodCountRecorder().recordMethod(invocation);

		// Then the deprecated static getters mirror that recording rather than returning empty
		System.Assert.areEqual(1, fflib_MethodCountRecorder.getOrderedMethodCalls().size(), 'The deprecated static ordered calls getter should mirror the recorded invocation');
		System.Assert.isTrue(fflib_MethodCountRecorder.getMethodArgumentsByTypeName().containsKey(qm), 'The deprecated static arguments getter should mirror the recorded method');
	}

	@IsTest
	private static void deprecatedAnyOrderConstructorVerifiesViaStaticRecorder()
	{
		// Given an invocation mirrored into the static recorder
		fflib_QualifiedMethod qm = new fflib_QualifiedMethod('MyType', 'myMethod', new List<Type>{ String.class });
		fflib_InvocationOnMock invocation = buildInvocation(qm, 'bob');
		new fflib_MethodCountRecorder().recordMethod(invocation);

		// When verifying through the deprecated no-arg constructor (uses the static recorder state)
		fflib_AnyOrder verifier = new fflib_AnyOrder();
		fflib_VerificationMode once = new fflib_ApexMocks().times(1);

		// Then the verification passes (recorded exactly once) - reaching the assert means no exception was thrown
		verifier.verifyMethodCall(invocation, once);
		System.Assert.areEqual(1, fflib_MethodCountRecorder.getOrderedMethodCalls().size(), 'The static recorder backing the deprecated verifier should hold the single recorded call');
	}

	@IsTest
	private static void deprecatedAnyOrderConstructorReportsUnexpectedCountViaStaticRecorder()
	{
		// Given a single recorded invocation
		fflib_QualifiedMethod qm = new fflib_QualifiedMethod('MyType', 'myMethod', new List<Type>{ String.class });
		fflib_InvocationOnMock invocation = buildInvocation(qm, 'bob');
		new fflib_MethodCountRecorder().recordMethod(invocation);

		// When verifying for two calls through the deprecated no-arg constructor
		fflib_AnyOrder verifier = new fflib_AnyOrder();
		fflib_VerificationMode twice = new fflib_ApexMocks().times(2);

		// Then it should fail because only one call was recorded in the static recorder
		try
		{
			verifier.verifyMethodCall(invocation, twice);
			System.Assert.fail('An exception was expected because the method was recorded only once');
		}
		catch (fflib_ApexMocks.ApexMocksException ex)
		{
			System.Assert.isTrue(ex.getMessage().startsWith('EXPECTED COUNT: 2'), 'Unexpected verify fail message: ' + ex.getMessage());
		}
	}

	private static fflib_InvocationOnMock buildInvocation(fflib_QualifiedMethod qm, String arg)
	{
		fflib_MethodArgValues args = new fflib_MethodArgValues(new List<Object>{ arg });
		return new fflib_InvocationOnMock(qm, args, 'mockInstance');
	}
}
