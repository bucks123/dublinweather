//
//  LESWeatherHTTPClientTests.m
//  DublinWeatherApp
//
//  Created by kieran buckley on 16/09/2016.
//  Copyright (c) 2014 LesApps. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LESWeatherHTTPClient.h"
#import "LESWeatherCondition.h"
@import CoreLocation;

const int64_t kDefaultTimeoutLengthInNanoSeconds = 10000000000; // 10 Seconds

@interface LESWeatherHTTPClientTests : XCTestCase

@end

@implementation LESWeatherHTTPClientTests{
    LESWeatherHTTPClient *_httpClient;
    CLLocationCoordinate2D _location;
    BOOL _callbackInvoked;
    NSDictionary *_jsonWeatherDataDict;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _httpClient = [[LESWeatherHTTPClient alloc]init];
    _location.latitude = 53.341450f;
    _location.longitude = -6.299072f;
    
    NSURL *dataServiceURL = [[NSBundle bundleForClass:self.class] URLForResource:@"weathermaptestdata" withExtension:@"json"];
    
    NSData *sampleData = [NSData dataWithContentsOfURL:dataServiceURL];
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:sampleData
                                              options:kNilOptions
                                                error:&error];
    XCTAssertNotNil(json, @"invalid test data");
    
    
    _jsonWeatherDataDict = json;
}

-(void)test_fetchCurrentConditionsForLocation_asyncIsWorking{
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, kDefaultTimeoutLengthInNanoSeconds); // time for async call to run
    
    [_httpClient fetchCurrentConditionsForLocation:_location withCompletionBlock:^(id weatherData, NSError *error) {
        if (error) {
            XCTFail(@"%@ failed. %@", weatherData, error);
        }
        XCTAssertNotNil(weatherData, @"Weather data should not be nil");
        dispatch_semaphore_signal(semaphore); // increments semaphore eg. release semaphore
    }];
    
    if (dispatch_semaphore_wait(semaphore, timeoutTime)) { // waits for semaphore until timeout - if happens then test fails - took too long for async call to run
        XCTFail(@"fetchCurrentConditionsForLocationtimed out");
    }
    
}

-(void)test_fetchHourlyForecastForLocation_asyncIsWorking{
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, kDefaultTimeoutLengthInNanoSeconds); // time for async call to run
    
    [_httpClient fetchHourlyForecastForLocation:_location withCompletionBlock:^(id weatherData, NSError *error) {
        if (error) {
            XCTFail(@"%@ failed. %@", weatherData, error);
        }
        XCTAssertNotNil(weatherData, @"Weather data should not be nil");
        dispatch_semaphore_signal(semaphore); // increments semaphore eg. release semaphore
    }];
    
    if (dispatch_semaphore_wait(semaphore, timeoutTime)) { // waits for semaphore until timeout - if happens then test fails - took too long for async call to run
        XCTFail(@"fetchHourlyConditionsForLocationtimed out");
    }
    
}

-(void)test_fetchDailyForecastForLocation_asyncIsWorking{
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, kDefaultTimeoutLengthInNanoSeconds); // time for async call to run
    
    [_httpClient fetchDailyForecastForLocation:_location withCompletionBlock:^(id weatherData, NSError *error) {
        if (error) {
            XCTFail(@"%@ failed. %@", weatherData, error);
        }
        XCTAssertNotNil(weatherData, @"Weather data should not be nil");
        dispatch_semaphore_signal(semaphore); // increments semaphore eg. release semaphore
    }];
    
    if (dispatch_semaphore_wait(semaphore, timeoutTime)) { // waits for semaphore until timeout - if happens then test fails - took too long for async call to run
        XCTFail(@"fetchDailyConditionsForLocationtimed out");
    }
    
}

/*
 condition = Clouds;
 conditionDescription = "broken clouds";
 date = "2014-06-29 21:30:40 +0000";
 humidity = 66;
 icon = 04n;
 locationName = Dublin;
 sunrise = "2014-06-29 04:01:04 +0000";
 sunset = "2014-06-29 20:56:32 +0000";
 tempHigh = 13;
 tempLow = 13;
 temperature = 13;
 windBearing = 130;
 windSpeed = "9.171453";*/

-(void)test_mantleTransformationFromJson{
    
    LESWeatherCondition *adaptedObj = [MTLJSONAdapter modelOfClass:[LESWeatherCondition class] fromJSONDictionary:_jsonWeatherDataDict error:nil];
    
    XCTAssertNotNil(adaptedObj, @"Should not be nil!");
    NSLog(@"date : %@", adaptedObj.date);
    XCTAssertEqualObjects(adaptedObj.date, @"2014-06-29 22:00:32 +0000", @"Dates should be the same!");
    
}

- (void)tearDown{
    
    _jsonWeatherDataDict = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


@end
