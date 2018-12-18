public with sharing class fflib_MockingTestClass {
    public void aVoidMethod(){
        throw new IllegalArgumentException();
    }

    public Integer anIntMethod() {
        return 0;
    }
}