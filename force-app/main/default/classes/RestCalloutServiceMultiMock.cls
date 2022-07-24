/*
* Application Name:- RestCalloutFramework
* Created:- 20/03/2020
* Last Updated:- 20/07/2022
* Description:- This is the mock class for multiple HTTP Callouts during testing
* Contributors:-
*    1. ASIF A KHAN
*/
@isTest
public class RestCalloutServiceMultiMock implements HTTPCalloutMock {

    Map<String, RestCalloutServiceMock> calloutMocks;

    /*
    * Constructor initializing the class variables
    */
    public RestCalloutServiceMultiMock() {
        calloutMocks = new Map<String, RestCalloutServiceMock>();
    }

    /*
    * Constructor initializing the class variables (from user input if available)
    */
    public RestCalloutServiceMultiMock(Map<String, RestCalloutServiceMock> calloutMocks) {
        this.calloutMocks = calloutMocks;
        if(this.calloutMocks == null) {
            calloutMocks = new Map<String, RestCalloutServiceMock>();
        }
    }

    /*
    * Adding a callout mock class instance to (URL - Mock) map
    */
    public void addCalloutMock(String endpoint, RestCalloutServiceMock calloutMock) {
        calloutMocks.put(endpoint, calloutMock);
    }

    /*
    * This method is used to generate and send a mock HTTP response for the incoming request
    * It also throws a custom exception in case the mock is not found for the input request URL
    */
    public HTTPResponse respond(HTTPRequest request) {
        RestCalloutServiceMock calloutMock = calloutMocks.get(request.getEndpoint());
        if(calloutMock != null) {
            return calloutMock.respond(request);
        } else {
            throw new RestCalloutFrameworkException(RestCalloutFrameworkException.MOCK_NOT_FOUND);
        }
    }
}