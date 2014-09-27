FinancialForce ApexMocks Framework
==================================

<a href="https://githubsfdeploy.herokuapp.com?owner=financialforcedev&repo=fflib-apex-mocks">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

ApexMocks is a mocking framework for the Force.com Apex language.

It derives it's inspiration from the well known Java mocking framework [Mockito](https://code.google.com/p/mockito/)

Using ApexMocks on Force.com
============================

ApexMocks allows you to write tests to both verify behaviour and stub dependencies.

An assumption is made that you are using some form of [Dependency Injection](http://en.wikipedia.org/wiki/Dependency_injection) - for example passing dependencies via a constructor:

	public MyClass(ClassA.IClassA dependencyA, ClassB.IClassB depdenceyB)

This allows you to pass mock implementations of depdencies A and B when you want to unit test MyClass.

Lets assume we've written our own list interface MyList.IList that we want to either verify or stub:

	public class fflib_MyList implements IList
	{
		public interface IList
		{
			void add(String value);
			String get(Integer index);
			void clear();
			Boolean isEmpty();
		}
	}

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
		mocks.when(mockList.get(1)).thenReturn('fred');
		mocks.stopStubbing();


Documentation
=============

Full documentation for ApexMocks can be found at [Code4Clode](http://code4cloud.wordpress.com/):

* [ApexMocks Framework Tutorial](http://code4cloud.wordpress.com/2014/05/06/apexmocks-framework-tutorial/)
* [Simple Dependency Injection](http://code4cloud.wordpress.com/2014/05/09/simple-dependency-injection/)
* [ApexMocks Generator](http://code4cloud.wordpress.com/2014/05/15/using-apex-mocks-generator-to-create-mock-class-definitions/)
* [Behaviour Verification](http://code4cloud.wordpress.com/2014/05/15/writing-behaviour-verification-unit-tests/)
* [Stubbing Dependencies](http://code4cloud.wordpress.com/2014/05/15/stubbing-dependencies-in-a-unit-test/)
* [Supported Features](http://code4cloud.wordpress.com/2014/05/15/apexmocks-supported-features/)
* [New Improved apex-mocks-generator](http://code4cloud.wordpress.com/2014/06/27/new-improved-apex-mocks-generator/)
