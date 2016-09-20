//
//  LESWeatherAPITests.m
//  DublinWeatherApp
//
//  Created by kieran buckley on 16/09/2016.
//  Copyright (c) 2014 LesApps. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LESWeatherAPI.h"
#import "LESWeatherHTTPClient.h"

@interface LESWeatherAPITests : XCTestCase

@end

@implementation LESWeatherAPITests


- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

-(void)test_getCurrentWeatherConditionForLocation{
    
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[LESWeatherAPI sharedInstance] currentCondition];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];

    XCTAssertNotNil([[LESWeatherAPI sharedInstance] currentCondition], @"A current weather condition should be set");
    
}

-(void)test_getHourlyForecast{
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[LESWeatherAPI sharedInstance] hourlyForecast];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    XCTAssertNotNil([[LESWeatherAPI sharedInstance] hourlyForecast], @"A current weather hourly forecast should be set");
    
}

-(void)test_getDailyForecast{
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[LESWeatherAPI sharedInstance] dailyForecast];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    XCTAssertNotNil([[LESWeatherAPI sharedInstance] dailyForecast], @"A current weather daily forecast should be set");
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
