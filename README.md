FinancialForce ApexMocks Framework
==================================

This Library
============

ApexMocks is a mocking framework for the Force.com Apex language.

It derives it's inspiration from the well known Java mocking framework [Mockito](https://code.google.com/p/mockito/)

Using ApexMocks on Force.com
============================

ApexMocks allows you to write tests to both verify behaviour and stub dependencies:

### verify() behvariour verification

		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new MockMyList(mocks);

		// When
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList)).add('bob');
		((fflib_MyList.IList) mocks.verify(mockList, fflib_ApexMocks.NEVER)).clear();
		
### when() dependency stubbing

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new MockMyList(mocks);

		mocks.startStubbing();
		mocks.when(mockList.get(0)).thenReturn('bob');
		mocks.stopStubbing();
		
		
The basic steps involved in using this framework are as follows:

  * Define your component interface IMyComponent
  * Define your implementation class MyClass implements IMyComponent
  * Create your unit test class MyClassTest
  * Inject the mock implementation of your interface into your unit test class using apex-mocks-generator
  * Start mocking!

Code4Clode
----------

See the [Code4Clode](http://code4cloud.wordpress.com/) blog for further information regarding the ApexMocks framework, including full instructions of how to use it.
