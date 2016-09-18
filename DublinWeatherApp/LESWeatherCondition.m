//
//  LESWeatherCondition.m
//  DublinWeatherApp
//
//  Created by kieran buckley on 16/09/2016.
//  Copyright (c) 2014 LesApps. All rights reserved.
//

#import "LESWeatherCondition.h"

#define MPS_T0_MPH 2.23694f

static NSString * const kDateKey = @"DateKey";
static NSString * const kHumidityKey = @"HumidityKey";
static NSString * const kTemperatureKey = @"TemperatureKey";
static NSString * const kTempHighKey = @"TempHighKey";
static NSString * const kTempLowKey = @"TempLowKey";
static NSString * const kLocationNameKey = @"LocationNameKey";
static NSString * const kSunriseKey = @"SunriseKey";
static NSString * const kSunsetKey = @"SunsetKey";
static NSString * const kConditionDescriptionKey = @"ConditionDescritpionKey";
static NSString * const kConditionKey = @"ConditionKey";
static NSString * const kWindBearingKey = @"WindBearingKey";
static NSString * const kWindSpeedKey = @"WindSpeedKey";
static NSString * const kIconKey = @"IconKey";

@implementation LESWeatherCondition

+ (NSDictionary*)imageMap {
    
    
    static NSDictionary *_imageMap = nil;
    
    if (!_imageMap) {
        _imageMap = @{
                      @"01d" : @"weather-clear",
                      @"02d" : @"weather-few",
                      @"03d" : @"weather-few",
                      @"04d" : @"weather-broken",
                      @"09d" : @"weather-shower",
                      @"10d" : @"weather-rain",
                      @"11d" : @"weather-tstorm",
                      @"13d" : @"weather-snow",
                      @"50d" : @"weather-mist",
                      @"01n" : @"weather-moon",
                      @"02n" : @"weather-few-night",
                      @"03n" : @"weather-few-night",
                      @"04n" : @"weather-broken",
                      @"09n" : @"weather-shower",
                      @"10n" : @"weather-rain-night",
                      @"11n" : @"weather-tstorm",
                      @"13n" : @"weather-snow",
                      @"50n" : @"weather-mist",
                      };
    }
    return _imageMap;
}

- (NSString*)imageName{
    return [LESWeatherCondition imageMap][self.icon];
}

+(NSValueTransformer*)windSpeedJSONTransformer{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
        return @(num.floatValue*MPS_T0_MPH);
    } reverseBlock:^(NSNumber *speed) {
        return @(speed.floatValue/MPS_T0_MPH);
    }];
}

+ (NSValueTransformer*)dateJSONTransformer{
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
    } reverseBlock:^(NSDate *date) {
        return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    }];
}

+ (NSValueTransformer*)sunriseJSONTransformer{
    return [self dateJSONTransformer];
}

+ (NSValueTransformer*)sunsetJSONTransformer{
    return [self dateJSONTransformer];
}

+(NSValueTransformer*)conditionDescriptionJSONTransformer{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSArray *values) {
        return [values firstObject];
    } reverseBlock:^(NSString *str) {
        return @[str];
    }];
}

+(NSValueTransformer*)conditionJSONTransformer{
    
    return [self conditionDescriptionJSONTransformer];
}

+(NSValueTransformer*)iconJSONTransformer{
    return [self conditionDescriptionJSONTransformer];
}

+ (NSDictionary*)JSONKeyPathsByPropertyKey{
    
    return @{
             @"date": @"dt",
             @"locationName": @"name",
             @"humidity": @"main.humidity",
             @"temperature": @"main.temp",
             @"tempHigh": @"main.temp_max",
             @"tempLow": @"main.temp_min",
             @"sunrise": @"sys.sunrise",
             @"sunset": @"sys.sunset",
             @"conditionDescription": @"weather.description",
             @"condition": @"weather.main",
             @"icon": @"weather.icon",
             @"windBearing": @"wind.deg",
             @"windSpeed": @"wind.speed"
             };
}

#pragma mark - Coding

-(id)initWithCoder:(NSCoder *)coder{
    
    self = [super init];
    if (self) {
        self.date = [coder decodeObjectForKey:kDateKey];
        self.humidity = [coder decodeObjectForKey:kHumidityKey];
        self.temperature = [coder decodeObjectForKey:kTemperatureKey];
        self.tempHigh = [coder decodeObjectForKey:kTempHighKey];
        self.tempLow = [coder decodeObjectForKey:kTempLowKey];
        self.locationName = [coder decodeObjectForKey:kLocationNameKey];
        self.sunrise = [coder decodeObjectForKey:kSunriseKey];
        self.sunset = [coder decodeObjectForKey:kSunsetKey];
        self.conditionDescription = [coder decodeObjectForKey:kConditionDescriptionKey];
        self.condition = [coder decodeObjectForKey:kConditionKey];
        self.windBearing = [coder decodeObjectForKey:kWindBearingKey];
        self.windSpeed = [coder decodeObjectForKey:kWindSpeedKey];
        self.icon = [coder decodeObjectForKey:kIconKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    
    [coder encodeObject:self.date forKey:kDateKey];
    [coder encodeObject:self.humidity forKey:kHumidityKey];
    [coder encodeObject:self.temperature forKey:kTemperatureKey];
    [coder encodeObject:self.tempHigh forKey:kTempHighKey];
    [coder encodeObject:self.tempLow forKey:kTempLowKey];
    [coder encodeObject:self.locationName forKey:kLocationNameKey];
    [coder encodeObject:self.sunrise forKey:kSunriseKey];
    [coder encodeObject:self.sunset forKey:kSunsetKey];
    [coder encodeObject:self.conditionDescription forKey:kConditionDescriptionKey];
    [coder encodeObject:self.condition forKey:kConditionKey];
    [coder encodeObject:self.windBearing forKey:kWindBearingKey];
    [coder encodeObject:self.windSpeed forKey:kWindSpeedKey];
    [coder encodeObject:self.icon forKey:kIconKey];
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    LESWeatherCondition *newWeatherCondition = [[[self class] allocWithZone:zone]init];
    if (newWeatherCondition) {
        [newWeatherCondition setDate:self.date];
        [newWeatherCondition setHumidity:self.humidity];
        [newWeatherCondition setTemperature:self.temperature];
        [newWeatherCondition setTempHigh:self.tempHigh];
        [newWeatherCondition setTempLow:self.tempLow];
        [newWeatherCondition setLocationName:self.locationName];
        [newWeatherCondition setSunrise:self.sunrise];
        [newWeatherCondition setSunset:self.sunset];
        [newWeatherCondition setConditionDescription:self.conditionDescription];
        [newWeatherCondition setCondition:self.condition];
        [newWeatherCondition setWindBearing:self.windBearing];
        [newWeatherCondition setWindSpeed:self.windSpeed];
        [newWeatherCondition setIcon:self.icon];
    }
    return newWeatherCondition;
}

@end
