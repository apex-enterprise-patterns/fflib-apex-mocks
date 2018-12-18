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

Lets assume we've written our own list interface MyList.IList that we want to either verify or stub:

	public class MyList implements IList
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
		MyList.IList mockList = (MyList.IList)mocks.mock(MyList.class);

		// When
		mockList.add('bob');

		// Then
		((MyList.IList) Mocks.verify(mockList)).add('bob');
		((MyList.IList) Mocks.verify(mockList, Mocks.NEVER)).clear();

### when() dependency stubbing

		MyList.IList mockList = (MyList.IList)mocks.mock(MyList.class);

		Mocks.when(mockList.get(0)).thenReturn('bob');
		Mocks.when(mockList.get(1)).thenReturn('fred');
	
### a more complicated case

		MyList mockedList = (MyList) Mk.mock(MyList.class);

        Mk.when(mockedList.add(Mk.anyString())).thenReturn('Hello!');
        Mk.when(mockedList.get(Mk.integerMoreThan(-1))).thenReturn('You got it!');
        Mk.Method addObjectMethod = Mk.when(mockedList.addObject(Mk.anyObject())).thenReturn(false);

        System.assertEquals('Hello!', mockedList.add('anAddedValue'));
        System.assertEquals('You got it!', mockedList.get(2));


        mockedList.addObject(getHttpResponse(200, 'what a nice bod'));

        HttpResponse addedObject = (HttpResponse) addObjectMethod.getCall().getArgument(0);
        System.assertEquals('what a nice bod', addedObject.getBody());
        System.assertEquals(200, addedObject.getStatusCode());

### doing this the old way (+5 LOC)
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        MyList mockedList = (MyList) mocks.mock(MyList.class);

        mocks.startStubbing();
        mocks.when(mockedList.add(fflib_Match.anyString())).thenReturn('Hello!');
        mocks.when(mockedList.get(fflib_Match.integerMoreThan(-1))).thenReturn('You got it!');
        mocks.when(mockedList.addObject(fflib_Match.anyObject())).thenReturn(false);
        mocks.stopStubbing();

        System.assertEquals('Hello!', mockedList.add('anAddedValue'));
        System.assertEquals('You got it!', mockedList.get(2));


        mockedList.addObject(getHttpResponse(200, 'what a nice bod'));

        fflib_ArgumentCaptor captor = fflib_ArgumentCaptor.forClass(HttpResponse.class);
        ((MyList) Mocks.verify(mockedList)).addObject(captor.capture());
        HttpResponse addedObject = (HttpResponse) captor.getValue();
        System.assertEquals('what a nice bod', addedObject.getBody());
        System.assertEquals(200, addedObject.getStatusCode());