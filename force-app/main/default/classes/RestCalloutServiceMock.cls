/*
* Application Name:- HTTPCalloutFramework
* Created:- 20/03/2020
* Last Updated:- 20/07/2022
* Description:- This is the mock class used for single HTTP Callout during testing
* Contributors:-
*    1. ASIF A KHAN
*/
@isTest
public class RestCalloutServiceMock implements HTTPCalloutMock {

    private HTTPResponse response;
    private Integer responseCode;
    private String responseBody;
    private String responseStatus;
    private Blob responseBodyAsBlob;
    private Map<String, String> responseHeaders;

    /*
    * Constructor
    */
    public RestCalloutServiceMock() {
        responseHeaders = new Map<String, String>();
    }

    /*
    * Constructor with response code and response body
    */
    public RestCalloutServiceMock(Integer responseCode, String responseBody) {
        responseHeaders = new Map<String, String>();
        this.responseCode = responseCode;
        this.responseBody = responseBody;
    }

    /*
    * Getters and Setters - Begin
    */
	public Integer getResponseCode() {
		return responseCode;
	}

	public void setResponseCode(Integer responseCode) {
		this.responseCode = responseCode;
	}

	public String getResponseBody() {
		return responseBody;
	}

	public void setResponseBody(String responseBody) {
		this.responseBody = responseBody;
	}

    public Map<String, String> getResponseHeaders() {
        return responseHeaders;
    }

    public void setResponseHeader(String key, String value) {
        responseHeaders.put(key, value);
    }

	public String getResponseStatus() {
		return responseStatus;
	}

	public void setResponseStatus(String responseStatus) {
		this.responseStatus = responseStatus;
	}

	public Blob getResponseBodyAsBlob() {
		return responseBodyAsBlob;
	}

	public void setResponseBodyAsBlob(Blob responseBodyAsBlob) {
		this.responseBodyAsBlob = responseBodyAsBlob;
	}
    /*
    * Getters and Setters - End
    */

    /*
    * This method is used to generate and send the mock HTTP Response for the incoming request
    */
    public HTTPResponse respond(HTTPRequest request) {
        response = new HTTPResponse();
        if(responseCode!=null) {
            response.setStatusCode(responseCode);
        }
        if(responseStatus!=null) {
            response.setStatus(responseStatus);
        }
        if(responseBodyAsBlob!=null) {
            response.setBodyAsBlob(responseBodyAsBlob);
        } else {
            response.setBody(responseBody);
        }
        if(responseHeaders != null) {
            for(String headerKey : responseHeaders.keySet()) {
                response.setHeader(headerKey, responseHeaders.get(headerKey));
            }
        }
        return response;
    }
}