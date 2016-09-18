//
//  LESPersistencyManager.h
//  DublinWeatherApp
//
//  Created by kieran buckley on 16/09/2016.
//  Copyright (c) 2014 LesApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LESWeatherCondition.h"

@interface LESPersistencyManager : NSObject

-(void)addWeatherCondition:(LESWeatherCondition*)weatherCondition;
-(void)addHourlyForecast:(NSArray*)hourlyForecast;
-(void)addDailyForecast:(NSArray*)dailyForecast;

-(LESWeatherCondition*)getWeatherCondition;
-(NSArray*)getHourlyForecast;
-(NSArray*)getDailyForecast;

-(NSString*)dataFilePathWithFileName:(NSString*)fileName;

@end
