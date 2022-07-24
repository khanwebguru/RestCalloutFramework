/*
* Application Name:- RestCalloutFramework
* Created:- 20/03/2020
* Last Updated:- 20/07/2022
* Description:- This is the custom exception class with error messages
* Contributors:-
*    1. ASIF A KHAN
*/
public class RestCalloutFrameworkException extends Exception {
    public static final String CUSTOM_METADATA_NOT_FOUND = 'Unable to query custom metadata. Make sure you\'ve passed the correct developer name.';
    public static final String MOCK_NOT_FOUND = 'Response Mock not found for the current request URL';
    public static final String CONTINUATION_LIMIT_EXCEEDED = 'You can add upto ' + RestCalloutAsyncService.CONTINUATION_LIMIT + ' callouts in a single continuation request.';
}