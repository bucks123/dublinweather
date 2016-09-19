//
//  LESWeatherAPI.h
//  DublinWeatherApp
//
//  Created by kieran buckley on 16/09/2016.
//  Copyright (c) 2014 LesApps. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kWeatherAPIContentUpdateNotification;

@class LESWeatherCondition;

@interface LESWeatherAPI : NSObject 

+ (LESWeatherAPI*)sharedInstance;

@property (nonatomic,strong)LESWeatherCondition *currentCondition;
@property (nonatomic,strong, readonly)NSArray *hourlyForecast;
@property (nonatomic,strong, readonly)NSArray *dailyForecast;

@end