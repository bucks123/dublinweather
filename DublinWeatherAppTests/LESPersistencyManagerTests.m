//
//  LESPersistencyManagerTests.m
//  DublinWeatherApp
//
//  Created by kieran buckley on 16/09/2016.
//  Copyright (c) 2014 LesApps. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LESPersistencyManager.h"
#import "LESWeatherCondition.h"
#import "Mantle.h"

@interface LESPersistencyManagerTests : XCTestCase

@end

@implementation LESPersistencyManagerTests{
    
    LESPersistencyManager *_persistencyMgr;
    LESWeatherCondition *_weatherCondition;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _persistencyMgr = [[LESPersistencyManager alloc]init];
    _weatherCondition = [[LESWeatherCondition alloc]init];
    
    NSDate *today = [NSDate date];
    [_weatherCondition setDate:today];
    [_weatherCondition setHumidity:@123];
    [_weatherCondition setCondition:@"Sunny"];

}

-(void)test_addWeatherCondition_weatherConditionArchived{
    
    NSDate *today = [NSDate date];
    
    [_weatherCondition setDate:today];
    [_weatherCondition setHumidity:@123];
    [_weatherCondition setCondition:@"Rainy"];
    
    [_persistencyMgr addWeatherCondition:_weatherCondition];
    LESWeatherCondition *newWeatherCondition = [_persistencyMgr getWeatherCondition];
    
    XCTAssertEqualObjects(_weatherCondition, newWeatherCondition, @"Should be the same - archiving unsuccessful");
    
}

-(void)test_getWeatherCondition_weatherConditionUnArchived{
    
    LESWeatherCondition *tempWeatherCondition = [_persistencyMgr getWeatherCondition];
    XCTAssertNotNil(tempWeatherCondition, "Should be a valid weather condition object");
}

-(void)test_getdataFilePath_dataFilePathIsCorrect{
    
    NSString *filePath = [_persistencyMgr dataFilePathWithFileName:@"weatherdata.archive"];
    
    NSLog(@"file name : %@",[filePath lastPathComponent]);
    
    XCTAssertEqualObjects(@"weatherdata.archive", [filePath lastPathComponent], @"File Names should be equal");
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


@end
