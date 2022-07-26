# RestCalloutFramework

This is a lightweight framework for apex HTTP callouts in salesforce. Use this if you are making callouts/Rest Callouts from Apex.

## Overview

RestCalloutFramework can be used to perform apex callouts to external systems. 
It has in-built apex classes that can be used to perform HTTPCallouts. 
The required information for the callout can be stored in the custom metadata named **RestCalloutConfiguration**.
The framework also consists of mock classes that can be used to define mocks for single
and multiple HTTP Callouts in a single transaction. The code used in the framework is already covered
so that you don't need to worry during the deployments.

### Prerequisites

There are no such pre-requisites for installing and using this framework. 
If you want to download the code in your local system, 
you can do it by the executing the below command or downloading the code directly as a zip file.

```
git clone https://github.com/khanwebguru/RestCalloutFramework.git
```

### Installing

RestCalloutFramework is very easy to use. You can install this application in your salesforce org as an unmanaged package or by using the **deploy to salesforce** button
present in the [deployment](#deployment) section of this readme. Installing this will add the following to your org :- 

1. RestCalloutService - Apex Class
2. RestCalloutServiceMock - Apex Class
3. RestCalloutServiceMultiMock - Apex Class
4. RestCalloutFrameworkException - Apex Class
5. RestCalloutServiceTest - Apex Class
6. RestCalloutConfiguration - Custom Metadata
7. TestMetadata - RestCalloutConfiguration record used in test class (should not be deleted)
8. SFDCStopBlogs - RestCalloutConfiguration record (Not included in unmanaged package. For demo purposes - can be deleted if installed through deploy to salesforce button)
9. RestCalloutConfiguration Layout - Layout for RestCalloutConfiguration metadata
10. SFDCStopAPI - Remote Site Settings record for SFDC Stop API (Not included in unmanaged package. For demo purposes - can be deleted if installed through deploy to salesforce button)

**RestCalloutFramework** is now ready for use.

## Deployment

You can deploy RestCalloutFramework directly to your org by clicking the button below

<a href="https://githubsfdeploy.herokuapp.com?owner=khanwebguru&repo=RestCalloutFramework&ref=gsdt">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Usage

### Synchronous Callouts

Once installed you'll see the below custom metadata records created in your org:-

![RestCalloutConfigurationMetadata](https://github.com/khanwebguru/RestCalloutFramework/blob/main/Images/HTTPCalloutConfigurationMetadata.JPG)

You can see that I have specified details of the request in the metadata itself.

![SFDCStopAPIRemoteSiteSettingsRecord](https://github.com/khanwebguru/RestCalloutFramework/blob/main/Images/SFDCStopAPIRemoteSiteSettingsRecord.JPG)

You can copy and execute the below code in developer console to test the framework.
As you can see below, I have passed the custom metadata record developer name in the constructor.
Rest of the details are fetched automatically.

```apex
RestCalloutService service = new RestCalloutService('SFDCStopBlogs');
System.debug(service.getRequest());
System.debug(service.sendRequest().getBody());
```

![DeveloperConsole](https://github.com/khanwebguru/RestCalloutFramework/blob/main/Images/DeveloperConsole.JPG)

Custom metadata and remote site setting record of SFDC Stop API are for demo purposes only. 
You can delete these records after installation and create your own records for HTTP callouts.
Make sure you **Do not delete the TestMetadata** record  of HTTPCalloutConfiguration custom metadata as it's being used in the test class for code coverage.

### Asynchronous Callouts

Now, let's jump on to the asynchronous apex callouts part. As you must be aware that the asynchronous callouts in apex are implemented using the [Continuation](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_System_Continuation.htm) class. The continuation class has different syntax for Visualforce Pages and Lightning Components. So, we're going to see the syntax for implementation in both cases. The good thing is that we have a single [RestCalloutAsyncService](https://github.com/khanwebguru/RestCalloutFramework/blob/main/force-app/main/default/classes/RestCalloutAsyncService.cls) class that we can use for both Visualforce Pages and Lightning Components.

#### Visualforce Page

The syntax of vf page controller is given below:-

```apex
RestCalloutAsyncService service {get;set;} // Creating an instance of RestCalloutAsyncService in controller
List<String> requestLabels; // This list will be used to store the request labels returned by the continuation process
// Define your action method (should have return type of Object)
public Object sendAsyncCalloutRequest() {
    service = new RestCalloutAsyncService(<Integer Timeout>, new List<String> {<CustomMetadata1>, <CustomMetadata2>, <CustomMetadata3>});       
    Continuation con = service.sendRequest('getAsyncCalloutResponse'); // Pass the callback method name in the parameter
    requestLabels = service.getRequestLabels(); // Storing the request labels returned by continuation
    return con; // Returning the continuation
}

// Define a callback method with the same name as passed in the sendRequest method of service class
public Object getAsyncCalloutResponse() {
    // Getting a list of responses by passing the request labels in the parameter
    List<HTTPResponse> responses = service.getResponse(requestLabels);
    // Process the responses (Set variables that are being used in VF Page)
    // Returning null to re-render the vf page
    return null;
}
```

The visualforce page should have an command button calling our controller method as shown below:-
```html
<apex:commandButton action="{!sendAsyncCalloutRequest}" value="Send Request"  reRender="<id of the block to re render>"/>
```

#### Lightning Component

The syntax of lightning component controller is given below:-

```apex
// This method will be called from lightning component (should have return type of Object)
@AuraEnabled(cacheable=true continuation=true)
public static Object fetchData() {
    RestCalloutAsyncService service = new RestCalloutAsyncService(<Integer Timeout>, new List<String> {<CustomMetadata1>, <CustomMetadata2>, <CustomMetadata3>});
    return service.sendRequest('sendResponse'); // Pass the response method name in the parameter
}

// Define a callback method with the same name as passed in the sendRequest method of service class
@AuraEnabled(cacheable=true)
public static Object sendResponse(List<String> labels, Object state) {
    RestCalloutAsyncService service = new RestCalloutAsyncService(<Integer Timeout>, new List<String> {<CustomMetadata1>, <CustomMetadata2>, <CustomMetadata3>});
    // Getting a list of responses by passing the request labels in the parameter
    List<HTTPResponse> responses = service.getResponse(labels);
    // Process the responses (Create a wrapper to send the response)
    // Returning the wrapper in JSON format back to lightning component
    return JSON.serialize(<wrapper>);
}
```

We should have call our apex method in lightning component helper as shown below:-
```js
var fetchDataAction = component.get('c.fetchData');
fetchDataAction.setCallback(this, function(response) {
  if(response.getState() === 'SUCCESS') {
    var data = JSON.parse(response.getReturnValue());
  }
}
$A.enqueueAction(fetchDataAction);
```

I have created a working example for both VF and Lightning that you can deploy in your org by clicking the below button. **Make sure that you've installed the framework in your org first otherwise the deployment of examples will fail.**

<a href="https://githubsfdeploy.herokuapp.com?owner=khanwebguru&repo=RestCalloutFramework&ref=asyncexample">
  <img alt="Deploy Asynchronous Examples to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Tools and Softwares used

You just need a salesforce org to run this application. 
If you want to make any changes in the code, you can do that by using the developer console provided by Salesforce. 
However I like to use VS Code IDE to keep a local copy of code on my system too. For regular deployments, 
I use SFDX Deploy Tool. So below are the tools or softwares I use personally :-

* [VS Code](https://code.visualstudio.com) - Open Source IDE for Salesforce
* [SFDX Deploy Tool](https://github.com/rahulmalhotra/SFDX-Deploy-Tool) - SFDX Deploy Tool for Windows and Mac

## Todo

- [ ] Find a way to cover code adding client certificate to HTTP callout in test class. 
It will increase the code coverage of HTTPCalloutService class to 100% (Current coverage:- 99%)

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on code of conduct and the process for submitting pull requests.

## Authors

* **ASIF A KHAN** - [@asifahmedkhan](https://www.linkedin.com/in/asifahmedkhan/) inspired by Rahul M

## License

This project is licensed under GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details.

