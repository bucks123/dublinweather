//
//  LESWeatherCondition.h
//  DublinWeatherApp
//
//  Created by kieran buckley on 16/09/2016.
//  Copyright (c) 2014 LesApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface LESWeatherCondition : MTLModel <MTLJSONSerializing,NSCoding,NSCopying>

@property (nonatomic,strong)NSDate *date;
@property (nonatomic,strong)NSNumber *humidity;
@property (nonatomic,strong)NSNumber *temperature;
@property (nonatomic,strong)NSNumber *tempHigh;
@property (nonatomic,strong)NSNumber *tempLow;
@property (nonatomic,strong)NSString *locationName;
@property (nonatomic,strong)NSDate *sunrise;
@property (nonatomic,strong)NSDate *sunset;
@property (nonatomic,strong)NSString *conditionDescription;
@property (nonatomic,strong)NSString *condition;
@property (nonatomic,strong)NSNumber *windBearing;
@property (nonatomic,strong)NSNumber *windSpeed;
@property (nonatomic,strong)NSString *icon;

-(NSString*)imageName;

@end
