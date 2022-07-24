/*
* Application Name:- RestCalloutFramework
* Created:- 20/03/2020
* Last Updated:- 20/07/2022
* Description:- This is the test class for RestCalloutService class.
*               Test Coverage:- RestCalloutService.cls (99%)
* Dependencies:- TestMetadata record in RestCalloutConfiguration__mdt
* Contributors:-
*    1. ASIF A KHAN
*/
@isTest
public class RestCalloutServiceTest {

    /*
    * Initializing constants
    */
    private static final String CUSTOM_METADATA_NAME = 'TestMetadata';
    private static final String ENDPOINT = 'https://www.test.com';
    private static final String METHOD = 'POST';
    private static final String REQUEST_BODY = '{"input":"Test Input"}';
    private static final String REQUEST_BODY_XML = '<input>Test Input</input>';
    private static final String RESPONSE_BODY = '{"output":"Test Output"}';
    private static final Integer RESPONSE_SUCCESS = 200;
    private static final Integer TIMEOUT = 120000;
    private static final Boolean ISCOMPRESSED = true;
    private static final String KEY1 = 'key1';
    private static final String KEY2 = 'key2';
    private static final String VALUE1 = 'value1';
    private static final String VALUE2 = 'value2';
    private static final String CERTIFICATE = 'Test Certificate';

    /*
    * Testing with predefined custom metadata record
    */
    @isTest
    public static void testWithCustomMetadata() {
        Test.startTest();
        RestCalloutServiceMock testMock = new RestCalloutServiceMock(RESPONSE_SUCCESS, RESPONSE_BODY);
        Test.setMock(HTTPCalloutMock.class, testMock);
        RestCalloutService service = new RestCalloutService(CUSTOM_METADATA_NAME);
        HTTPResponse testResponse = service.sendRequest();
        System.assertEquals(RESPONSE_SUCCESS, testResponse.getStatusCode());
        System.assertEquals(RESPONSE_BODY, testResponse.getBody());
        Test.stopTest();
    }

    /*
    * Testing with custom metadata record and setting blob as body
    */
    @isTest
    public static void testWithCustomMetadataAndBlobInBody() {
        Test.startTest();
        RestCalloutServiceMock testMock = new RestCalloutServiceMock(RESPONSE_SUCCESS, RESPONSE_BODY);
        Test.setMock(HTTPCalloutMock.class, testMock);
        RestCalloutService service = new RestCalloutService(CUSTOM_METADATA_NAME);
        service.setRequestBodyAsBlob(Blob.valueOf(service.getRequestBody()));
        service.setRequestBody('');
        // Calling sendRequest() method and passing HTTPRequest in parameter
        HTTPResponse testResponse = service.sendRequest(service.getRequest());
        System.assertEquals(RESPONSE_SUCCESS, testResponse.getStatusCode());
        System.assertEquals(RESPONSE_BODY, testResponse.getBody());
        Test.stopTest();
    }

    /*
    * Testing with custom metadata record and setting document as body
    */
    @isTest
    public static void testWithCustomMetadataAndDocumentInBody() {
        Test.startTest();
        RestCalloutServiceMock testMock = new RestCalloutServiceMock(RESPONSE_SUCCESS, RESPONSE_BODY);
        Test.setMock(HTTPCalloutMock.class, testMock);
        RestCalloutService service = new RestCalloutService(CUSTOM_METADATA_NAME);
        Dom.Document requestDocument = new Dom.Document();
        requestDocument.load(REQUEST_BODY_XML);
        service.setRequestBodyAsDocument(requestDocument);
        service.setRequestBody('');
        HTTPResponse testResponse = service.sendRequest();
        System.assertEquals(RESPONSE_SUCCESS, testResponse.getStatusCode());
        System.assertEquals(RESPONSE_BODY, testResponse.getBody());
        Test.stopTest();
    }

    /*
    * Testing with wrong custom metadata record to cover the custom exception scenario
    */
    @isTest
    public static void testWithWrongCustomMetadata() {
        Test.startTest();
        try {
            RestCalloutService service = new RestCalloutService('TestMetadata1');
        } catch(Exception e) {
            System.assertEquals(RestCalloutFrameworkException.CUSTOM_METADATA_NOT_FOUND, e.getMessage());
        }
        Test.stopTest();
    }

    /*
    * Testing with custom metadata and wrong certificate
    * to cover the getters and setters for client certificate
    */
    @isTest
    public static void testWithCustomMetadataWrongCertificate() {
        Test.startTest();
        RestCalloutServiceMock testMock = new RestCalloutServiceMock(RESPONSE_SUCCESS, RESPONSE_BODY);
        Test.setMock(HTTPCalloutMock.class, testMock);
        RestCalloutService service = new RestCalloutService(CUSTOM_METADATA_NAME);
        service.setRequestCertificate(CERTIFICATE);
        System.assertEquals(CERTIFICATE, service.getRequestCertificate());
        Test.stopTest();
    }

    /*
    * Testing without custom metadata
    */
    @isTest
    public static void testWithoutCustomMetadata() {
        Test.startTest();
        RestCalloutServiceMock testMock = new RestCalloutServiceMock(RESPONSE_SUCCESS, RESPONSE_BODY);
        Test.setMock(HTTPCalloutMock.class, testMock);
        // Initializing service and testing all the getters and setters
        RestCalloutService service = new RestCalloutService();
        service.setEndpointURL(ENDPOINT);
        System.assertEquals(ENDPOINT, service.getEndpointURL());
        service.setRequestMethod(METHOD);
        System.assertEquals(METHOD, service.getRequestMethod());
        service.setRequestBody(REQUEST_BODY);
        System.assertEquals(REQUEST_BODY, service.getRequestBody());
        service.setRequestBodyAsBlob(Blob.valueOf(REQUEST_BODY));
        System.assertEquals(Blob.valueOf(REQUEST_BODY), service.getRequestBodyAsBlob());
        Dom.document requestDocument = new Dom.Document();
        requestDocument.load(REQUEST_BODY_XML);
        service.setRequestBodyAsDocument(requestDocument);
        System.assertEquals(requestDocument, service.getRequestBodyAsDocument());
        service.setRequestTimeout(TIMEOUT);
        System.assertEquals(TIMEOUT, service.getRequestTimeout());
        service.setIsCompressedRequest(ISCOMPRESSED);
        System.assertEquals(ISCOMPRESSED, service.getIsCompressedRequest());
        service.setHeaderParameter(KEY1, VALUE1);
        System.assertEquals(VALUE1, service.getHeaderParameter(KEY1));
        service.setHeaderParameter(KEY2, VALUE2);
        System.assertEquals(VALUE2, service.getHeaderParameter(KEY2));
        service.removeHeaderParameter(KEY2);
        System.assertEquals(null, service.getHeaderParameter(KEY2));
        Map<String, String> headerParams = service.getHeaderParameters();
        System.assertEquals(VALUE1, headerParams.get(KEY1));
        service.setURLParameter(KEY1, VALUE1);
        System.assertEquals(VALUE1, service.getURLParameter(KEY1));
        service.setURLParameter(KEY2, VALUE2);
        System.assertEquals(VALUE2, service.getURLParameter(KEY2));
        service.removeURLParameter(KEY2);
        System.assertEquals(null, service.getURLParameter(KEY2));
        service.setURLParameter(KEY2, null);
        Map<String, String> urlParams = service.getURLParameters();
        System.assertEquals(VALUE1, urlParams.get(KEY1));
        System.assertEquals(null, urlParams.get(KEY2));
        // Testing the request and response
        HTTPRequest testRequest = service.getRequest();
        System.assertEquals(METHOD, testRequest.getMethod());
        System.assertEquals(ENDPOINT + '?key1=value1&key2=null', testRequest.getEndpoint());
        HTTPResponse testResponse = service.sendRequest();
        System.assertEquals(RESPONSE_SUCCESS, testResponse.getStatusCode());
        System.assertEquals(RESPONSE_BODY, testResponse.getBody());
        Test.stopTest();
    }

    /*
    * Testing with custom metadata and multiple requests
    * Covered the successful request and response
    * Covered the custom exception in the case of wrong endpoint
    */
    @isTest
    public static void testWithCustomMetadataMultipleRequests() {
        Test.startTest();
        // Initializing multi mock class
        RestCalloutServiceMultiMock testMultiMock = new RestCalloutServiceMultiMock();
        // Testing the successful response
        RestCalloutServiceMock testMock = new RestCalloutServiceMock(RESPONSE_SUCCESS, RESPONSE_BODY);
        testMultiMock.addCalloutMock(ENDPOINT + '?key1=&key2=value2', testMock);
        Test.setMock(HTTPCalloutMock.class, testMultiMock);
        RestCalloutService service = new RestCalloutService(CUSTOM_METADATA_NAME);
        HTTPResponse testResponse = service.sendRequest();
        System.assertEquals(RESPONSE_SUCCESS, testResponse.getStatusCode());
        System.assertEquals(RESPONSE_BODY, testResponse.getBody());
        // Testing the custom exception in case of wrong URL
        service.setEndpointURL('https://www.wrongurl.com');
        try {
            service.sendRequest();
        } catch(Exception e) {
            System.assertEquals(RestCalloutFrameworkException.MOCK_NOT_FOUND, e.getMessage());
        }
        Test.stopTest();
    }
}