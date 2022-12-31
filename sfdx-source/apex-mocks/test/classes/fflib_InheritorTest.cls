/*
 * Copyright (c) 2016-2017 FinancialForce.com, inc.  All rights reserved.
 */
@isTest
public class fflib_InheritorTest
{
 	@isTest
    public static void canInstantiateMultipleInterfaceInheritor()
    {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        Object inheritor = mocks.mock(fflib_Inheritor.class);
        System.Assert.isInstanceOfType(inheritor, fflib_Inheritor.IA.class);
        System.Assert.isInstanceOfType(inheritor, fflib_Inheritor.IB.class);
        System.Assert.isInstanceOfType(inheritor, fflib_Inheritor.IC.class);
    }

 	@isTest
    public static void canStubMultipleInterfaceInheritor()
    {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_Inheritor inheritor = (fflib_Inheritor)mocks.mock(fflib_Inheritor.class);

        mocks.startStubbing();
        mocks.when(inheritor.doA()).thenReturn('Did not do A');
        mocks.when(inheritor.doB()).thenReturn('Did not do B');
        mocks.when(inheritor.doC()).thenReturn('Did not do C');
        mocks.stopStubbing();
        
        System.Assert.areEqual('Did not do A', inheritor.doA());
        System.Assert.areEqual('Did not do B', inheritor.doB());
        System.Assert.areEqual('Did not do C', inheritor.doC());
    }
}