/**
 * Created by sebastian.mischke on 2018-12-17.
 */

public with sharing class fflib_InvocationStore {
    private List<fflib_InvocationOnMock> invocations = new List<fflib_InvocationOnMock>();

    public void add(fflib_InvocationOnMock invocation) {
        invocations.add(invocation);
    }

    public fflib_InvocationOnMock call(Integer callIndex) {
        checkIndex(callIndex);
        return invocations.get(callIndex);
    }

    public fflib_InvocationOnMock call() {
        return call(callCount() - 1);
    }

    public Integer callCount() {
        return invocations.size();
    }

    private void checkIndex(Integer index) {
        //TODO: check if any calls where made
    }
}