# FinancialForce ApexMocks Framework

[![Build Status](https://travis-ci.org/financialforcedev/fflib-apex-mocks.svg)](https://travis-ci.org/financialforcedev/fflib-apex-mocks)

ApexMocks is a mocking framework for the Force.com Apex language. 

It derives it's inspiration from the well known Java mocking framework [Mockito](https://code.google.com/p/mockito/)

<a href="https://githubsfdeploy.herokuapp.com?owner=financialforcedev&repo=fflib-apex-mocks">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

## Setup
- Clone this repo
- Copy the build.properties.template file into build.properties file and add your salesforce username and password.
- Do `ant deploy` to get the classes in your dev org.

## Using ApexMocks on Force.com

ApexMocks allows you to write tests to both verify behaviour and stub dependencies.

An assumption is made that you are using some form of [Dependency Injection](http://en.wikipedia.org/wiki/Dependency_injection) - for example passing dependencies via a constructor:

	public MyClass(ClassA.IClassA dependencyA, ClassB.IClassB dependencyB)

This allows you to pass mock implementations of dependencies A and B when you want to unit test MyClass.

Lets assume we've written our own list interface fflib_MyList.IList that we want to either verify or stub:

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

### verify() behaviour verification

		// Given
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = (fflib_MyList.IList)mocks.mock(fflib_MyList.class);

		// When
		mockList.add('bob');

		// Then
		((fflib_MyList.IList) mocks.verify(mockList)).add('bob');
		((fflib_MyList.IList) mocks.verify(mockList, fflib_ApexMocks.NEVER)).clear();

### when() dependency stubbing

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = (fflib_MyList.IList)mocks.mock(fflib_MyList.class);

		mocks.startStubbing();
		mocks.when(mockList.get(0)).thenReturn('bob');
		mocks.when(mockList.get(1)).thenReturn('fred');
		mocks.stopStubbing();

## Stub API
ApexMocks now implements the [Stub API](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_stub_api.htm)!

Previously, stub objects had to be generated using the ApexMocks generator at compile time.
Now, stub objects can be generated dynamically at run time.

	fflib_ApexMocks mocks = new fflib_ApexMocks();
	fflib_MyList mockList = (fflib_MyList)mocks.mock(fflib_MyList.class);

You can continue to use the ApexMocks generator, if you wish, but this is no longer a prerequisite to using ApexMocks.

## Generating Mock files

Run the apex mocks generator from the command line.

		java -jar apex-mocks-generator-4.0.0.jar
			<Filepath to source files>
			<Filepath to interface properties file>
			<Name of generated mocks class>
			<Filepath to target files - can be the same as filepath to source files>
			<API version of generated mocks class - optional argument, 30.0 by default>

		//E.g. the command used to generate the current version of fflib_Mocks.
		java -jar apex-mocks-generator-4.0.0.jar "/Users/jbloggs/Dev/fflib-apex-mocks/src/classes" "/Users/jbloggs/Dev/fflib-apex-mocks/interfacemocks.properties" "fflib_Mocks" "/Users/jbloggs/Dev/fflib-apex-mocks/src/classes" "30.0"


Instantiate the generated classes as follows:

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MyList.IList mockList = new MockMyList(mocks);

## Documentation

* [ApexMocks Framework Tutorial](http://code4cloud.wordpress.com/2014/05/06/apexmocks-framework-tutorial/)
* [Simple Dependency Injection](http://code4cloud.wordpress.com/2014/05/09/simple-dependency-injection/)
* [ApexMocks Generator](http://code4cloud.wordpress.com/2014/05/15/using-apex-mocks-generator-to-create-mock-class-definitions/)
* [Behaviour Verification](http://code4cloud.wordpress.com/2014/05/15/writing-behaviour-verification-unit-tests/)
* [Stubbing Dependencies](http://code4cloud.wordpress.com/2014/05/15/stubbing-dependencies-in-a-unit-test/)
* [Supported Features](http://code4cloud.wordpress.com/2014/05/15/apexmocks-supported-features/)
* [New Improved apex-mocks-generator](http://code4cloud.wordpress.com/2014/06/27/new-improved-apex-mocks-generator/)
* [ApexMocks Improvements - exception stubbing, base classes and more](http://code4cloud.wordpress.com/2014/11/05/apexmocks-improvements-exception-stubbing-inner-interfaces-and-mock-base-classes/)
* [Matchers](http://superdupercode.blogspot.co.uk/2016/03/apex-mocks-matchers.html)
* [ApexMock blogs from Jesse Altman](http://jessealtman.com/tag/apexmocks/)
* [Order of calls verification](https://xonoxforce.wordpress.com/2017/03/26/inorder-verify/)
* [Answering](https://xonoxforce.wordpress.com/2017/03/31/answering-with-apex-mocks/)
* [Counters](https://xonoxforce.wordpress.com/2017/04/01/counters-in-apex-mocks-verifications/)
