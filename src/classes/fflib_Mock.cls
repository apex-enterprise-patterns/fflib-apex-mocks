public with sharing class fflib_Mock extends fflib_Match {
    private static fflib_ApexMocks mocks = new fflib_ApexMocks();

    /**
     * Creates mock object of given class or interface.
     * @param classToMock class or interface to mock.
     * @return mock object.
     */
    public static Object mock(Type classToMock) {
        return mocks.mock(classToMock);
    }

    /**
     * Verify a method was called on a mock object.
     * @param mockInstance The mock object instance.
     * @return The mock object instance.
     */
    public static Object verify(Object mockInstance) {
        return mocks.verify(mockInstance);
    }

    /**
     * Verify a method was called on a mock object.
     * @param mockInstance The mock object instance.
     * @param verificationMode Defines the constraints for performing the verification (e.g. the minimum and maximum expected invocation counts).
     * @return The mock object instance.
     */
    public static Object verify(Object mockInstance, fflib_VerificationMode verificationMode) {
        return mocks.verify(mockInstance, verificationMode);
    }

    /**
     * Verify a method was called on a mock object.
     * @param mockInstance The mock object instance.
     * @param times The number of times you expect the method to have been called.
     * @return The mock object instance.
     */
    public static Object verify(Object mockInstance, Integer times) {
        return mocks.verify(mockInstance, times);
    }

    /**
     * Setup when stubbing for a mock object instance.
     * @param ignoredRetVal This is the return value from the method called on the mockInstance, and is ignored here since we are about to setup
     *        the stubbed return value using thenReturn() (see MethodReturnValue class below).
     */
    public static Method when(Object ignoredRetVal) {
        return new Method(mocks.when(ignoredRetVal));
    }

    /**
     * Setup exception stubbing for a void method.
     * @param e The exception to throw.
     * @param mockInstance The mock object instance.
     */
    public static Object doThrowWhen(Exception e, Object mockInstance) {
        return mocks.doThrowWhen(e, mockInstance);
    }

    /**
     * Setup exception stubbing for a void method.
     * @param exps The list of exceptions to throw.
     * @param mockInstance The mock object instance.
     */
    public static Object doThrowWhen(List<Exception> exps, Object mockInstance) {
        return mocks.doThrowWhen(exps, mockInstance);
    }

    /**
     * Setup answer stubbing for a void method.
     * @param answer The answer to invoke.
     * @param mockInstance The mock object instance.
     */
    public static Object doAnswer(Answer answer, Object mockInstance) {
        return mocks.doAnswer(answer, mockInstance);
    }

    /**
     * Sets how many times the method is expected to be called.
     * For InOrder verification we copy Mockito behavior which is as follows;
     * <ul>
     * <li>Consume the specified number of matching invocations, ignoring non-matching invocations in between</li>
     * <li>Fail an assert if the very next invocation matches, but additional matches can still exist so long as at least one non-matching invocation exists before them</li>
     * </ul>
     * For example if you had a(); a(); b(); a();
     * then inOrder.verify(myMock, 2)).a(); or inOrder.verify(myMock, 3)).a(); would pass but not inOrder.verify(myMock, 1)).a();
     * @param times The number of times you expect the method to have been called.
     * @return The fflib_VerificationMode object instance with the proper settings.
     */
    public static fflib_VerificationMode times(Integer times) {
        return mocks.times(times);
    }

    /**
     * Sets how many times the method is expected to be called for an InOrder verifier. Available Only with the InOrder verification.
     * A verification mode using calls will not fail if the method is called more times than expected.
     * @param times The number of times you expect the method to have been called in the InOrder verifying ( no greedy verify).
     * @return The fflib_VerificationMode object instance with the proper settings.
     */
    public static fflib_VerificationMode calls(Integer times) {
        return mocks.calls(times);
    }

    /**
     * Sets a custom assert message for the verify.
     * @param customAssertMessage The custom message for the assert in case the assert is false. The custom message is queued to the default message.
     * @return The fflib_VerificationMode object instance with the proper settings.
     */
    public static fflib_VerificationMode description(String customAssertMessage) {
        return mocks.description(customAssertMessage);
    }

    /**
     * Sets the minimum number of times the method is expected to be called.
     * With the InOrder verification it performs a greedy verification, which means it would consume all the instances of the method verified.
     * @param atLeastTimes The minimum number of times you expect the method to have been called.
     * @return The fflib_VerificationMode object instance with the proper settings.
     */
    public static fflib_VerificationMode atLeast(Integer atLeastTimes) {
        return mocks.atLeast(atLeastTimes);
    }

    /**
     * Sets the maximum number of times the method is expected to be called. Not available in the InOrder verification.
     * @param atMostTimes The maximum number of times the method is expected to be called.
     * @return The fflib_VerificationMode object instance with the proper settings.
     */
    public static fflib_VerificationMode atMost(Integer atMostTimes) {
        return mocks.atMost(atMostTimes);
    }

    /**
     * Sets that the method is called at least once.
     * With the InOrder verification it performs a greedy verification, which means it would consume all the instances of the method verified.
     * @return The fflib_VerificationMode object instance with the proper settings.
     */
    public static fflib_VerificationMode atLeastOnce() {
        return mocks.atLeastOnce();
    }

    /**
     * Sets the range of how many times the method is expected to be called. Not available in the InOrder verification.
     * @param atLeastTimes The minimum number of times you expect the method to have been called.
     * @param atMostTimes The maximum number of times the method is expected to be called.
     * @return The fflib_VerificationMode object instance with the proper settings.
     */
    public static fflib_VerificationMode between(Integer atLeastTimes, Integer atMostTimes) {
        return mocks.between(atLeastTimes, atMostTimes);
    }

    /**
     * Sets that the method is not expected to be called.
     * @return The fflib_VerificationMode object instance with the proper settings.
     */
    public static fflib_VerificationMode never() {
        return mocks.never();
    }

    public abstract class Answer implements fflib_Answer {
        public Object answer(fflib_InvocationOnMock invocation) {
            return this.answer(new InvocationImpl(invocation));
        }

        public abstract Object answer(Invocation invocation);
    }

    private class InvocationImpl implements Invocation {
        final fflib_InvocationOnMock delegate;
        private InvocationImpl(fflib_InvocationOnMock delegate) {
            this.delegate = delegate;
        }

        public Object getArgument(Integer index) {
            return delegate.getArgument(index);
        }

        public List<Object> getArguments() {
            return delegate.getArguments();
        }
    }

    public interface Invocation {
        /**
         *	Returns the argument at the given index.
         *  @param index The index of the wanted argument.
         *  @throws ApexMocksException in case the index is out of range.
         *  @return The argument at the given index.
         */
        Object getArgument(Integer index);

        /**
         *	Returns the list of arguments passed to the method.
         *  @return The list of arguments.
         */
        List<Object> getArguments();
    }

    public class Method {
        private final fflib_MethodReturnValue delegate;

        private Method(fflib_MethodReturnValue delegate) {
            this.delegate = delegate;
        }
        /**
         * Setup a stubbed return value.
         * @param value The value to return from the stubbed method call.
         * @return The Method instance to allow you to chain the methods.
         */
        public Method thenReturn(Object value) {
            return new Method(delegate.thenReturn(value));
        }
        /**
         * Setup a stubbed exception.
         * @param e The exception to throw from the stubbed method call.
         * @return The Method instance to allow you to chain the methods.
         */
        public Method thenThrow(Exception e) {
            return new Method(delegate.thenThrow(e));
        }

        /**
         * Setup a stubbed answer.
         * @param answer The answer to run from the stubbed method call.
         */
        public void thenAnswer(Answer answer) {
            delegate.thenAnswer(answer);
        }

        /**
         * Setup a list of stubbed return values.
         * @param values The values to return from the stubbed method call in consecutive calls.
         * @return The Method instance to allow you to chain the methods.
         */
        public Method thenReturnMulti(List<Object> values) {
            return new Method(delegate.thenReturnMulti(values));
        }

        /**
         * Setup a list stubbed exceptions.
         * @param es The exceptions to throw from the stubbed method call in consecutive calls.
         * @return The Method instance to allow you to chain the methods.
         */
        public Method thenThrowMulti(List<Exception> values) {
            return new Method(delegate.thenThrowMulti(values));
        }

        /**
         * Returns the last call made to this method.
         * @return The fflib_InvocationOnMock instance that holds the info to the last call.
         */
        public fflib_InvocationOnMock getCall() {
            return delegate.getCall();
        }

        /**
        * Returns the nth call made to this method.
        * @return The fflib_InvocationOnMock instance that holds the info to the nth call.
        */
        public fflib_InvocationOnMock getCall(Integer n) {
            return delegate.getCall(n);
        }

        /**
        * Returns how many times this method was invoked
        * @return An Integer with the count of how many times this method was invoked.
        */
        public Integer getCallCount() {
            return delegate.getCallCount();
        }
    }
}