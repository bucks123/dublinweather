//
//  LESDailyWeatherCondition.m
//  DublinWeatherApp
//
//  Created by kieran buckley on 16/09/2016.
//  Copyright (c) 2014 LesApps. All rights reserved.
//

#import "LESDailyWeatherCondition.h"

@implementation LESDailyWeatherCondition

+ (NSDictionary*)JSONKeyPathsByPropertyKey{
    
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    
    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";
    
    return paths;
    
}


@end
