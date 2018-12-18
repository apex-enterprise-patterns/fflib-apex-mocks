@isTest class MkTest {
    @isTest static void when_shouldStub_withoutStartStubbing() {
        MkTestClassToMock mock = (MkTestClassToMock) fflib_Mocks.mock(MkTestClassToMock.class);

        fflib_Mocks.when(mock.getIntValue()).thenReturn(5);

        System.assertEquals(5, mock.getIntValue());
    }

    @isTest static void verify_shouldCountInvocationsCorrectly_whenMockingWithoutStartStubbing() {
        MkTestClassToMock mock = (MkTestClassToMock) fflib_Mocks.mock(MkTestClassToMock.class);
        fflib_Mocks.when(mock.getIntValue()).thenReturn(5);

        mock.getIntValue();

        ((MkTestClassToMock) fflib_Mocks.verify(mock, fflib_Mocks.times(1))).getIntValue();
    }

    @isTest static void doThrowWhen_shouldStub_withoutStartStubbing() {
        MkTestClassToMock mock = (MkTestClassToMock) fflib_Mocks.mock(MkTestClassToMock.class);

        ((MkTestClassToMock) Mocks.doThrowWhen(new IllegalArgumentException(), mock)).getIntValue();

        try {
            mock.getIntValue();
            Assertions.assertThrewException();
        } catch (IllegalArgumentException e) {
            System.assert(true, 'Exception was thrown as expected');
        }
    }

    /*

public interface MyList {
    String add(String value);
    String get(Integer index);
    Boolean addObject(Object o);
}
     */

    @isTest static void aMoreComplicatedExample() {
        MyList mockedList = (MyList) fflib_Mocks.mock(MyList.class);

        fflib_Mocks.when(mockedList.add(fflib_Mocks.anyString())).thenReturn('Hello!');
        fflib_Mocks.when(mockedList.get(fflib_Mocks.integerMoreThan(-1))).thenReturn('You got it!');
        Mocks.Method addObjectMethod = fflib_Mocks.when(mockedList.addObject(fflib_Mocks.anyObject())).thenReturn(false);

        System.assertEquals('Hello!', mockedList.add('anAddedValue'));
        System.assertEquals('You got it!', mockedList.get(2));


        mockedList.addObject(getHttpResponse(200, 'what a nice bod'));

        HttpResponse addedObject = (HttpResponse) addObjectMethod.getCall().getArgument(0);
        System.assertEquals('what a nice bod', addedObject.getBody());
        System.assertEquals(200, addedObject.getStatusCode());
    }

    @isTest static void aMoreComplicatedExampleOldFashioned() {
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
    }

    static HttpResponse getHttpResponse(Integer statusCode, String body) {
        HttpResponse response = new HttpResponse();
        response.setBody(body);
        response.setStatusCode(statusCode);
        return response;
    }

}