//
//  LESWeatherHTTPClient.m
//  DublinWeatherApp
//
//  Created by kieran buckley on 16/09/2016.
//  Copyright (c) 2014 LesApps. All rights reserved.
//
    
#import "LESWeatherHTTPClient.h"
#import "LESWeatherCondition.h"
#import "LESDailyWeatherCondition.h"
#import "LESJSONFetcher.h"
#import "LESWeatherDataHTTP.h"

static NSString * const kOpenWeatherMapAPIKey = @"&APPID=ff6e05543968f0b26a7f083a099ce0b4";
static NSString * const kOpenWeatherMapBaseURL = @"http://api.openweathermap.org/data/2.5";

@interface LESWeatherHTTPClient() <LESWeatherDataHTTP>

@property(nonatomic, strong) LESJSONFetcher *jsonFetcher;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *city;

@end

@implementation LESWeatherHTTPClient

-(instancetype)init{
    
    CLLocationDegrees lat = 53.3498;
    CLLocationDegrees lon = 6.2603;
    
    CLLocationCoordinate2D dublin = CLLocationCoordinate2DMake(lat,lon);
    return [self initWithLocation:dublin];
    
}

-(instancetype)initWithLocation:(CLLocationCoordinate2D)coordinate{
    
    self = [super init];
    if (self) {
        _jsonFetcher = [[LESJSONFetcher alloc] init];
        _coordinate = coordinate;
        _city = nil;
    }
    return self;
}

-(instancetype)initWithCity:(NSString*)city{
    
    self = [super init];
    if (self) {
        _jsonFetcher = [[LESJSONFetcher alloc] init];
        _city = city;
    }
    return self;
}



-(void)fetchCurrentConditionWithCompletionBlock:(WeatherDataDownloadingCompletionBlock)completionBlock{
    
    NSString *urlString = nil;
    if (self.city) {
        urlString = [NSString stringWithFormat:@"%@/weather?q=%@&units=metric%@",kOpenWeatherMapBaseURL,self.city, kOpenWeatherMapAPIKey];
    }else{
        urlString = [NSString stringWithFormat:@"%@/weather?lat=%f&lon=%f&units=metric%@",kOpenWeatherMapBaseURL, self.coordinate.latitude, self.coordinate.longitude, kOpenWeatherMapAPIKey];
    }
    
    NSLog(@"URL string: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.jsonFetcher fetchJSONFromURL:url withCompletionBlock:^(NSDictionary *jsonObj, NSError *error) {
        NSError *mantleError = nil;
        id adaptedObj = [MTLJSONAdapter modelOfClass:[LESWeatherCondition class] fromJSONDictionary:jsonObj error:&mantleError];
            NSLog(@"Object returned from mantle for location %@", adaptedObj);
        if (completionBlock) {
            completionBlock(adaptedObj, error);
        }
    }];
    
}

-(void)fetchHourlyForecastWithCompletionBlock:(WeatherDataDownloadingCompletionBlock)completionBlock{
    
    NSString *urlString = nil;
    
    if (self.city) {
        urlString = [NSString stringWithFormat:@"%@/forecast?q=%@&units=metric%@",kOpenWeatherMapBaseURL,self.city, kOpenWeatherMapAPIKey];
    }else{
        urlString = [NSString stringWithFormat:@"%@/forecast?lat=%f&lon=%f&units=metric&cnt=12%@", kOpenWeatherMapBaseURL, self.coordinate.latitude, self.coordinate.longitude,kOpenWeatherMapAPIKey];
    }

    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.jsonFetcher fetchJSONFromURL:url withCompletionBlock:^(NSDictionary *weatherDataList, NSError *error) {
        NSArray *weatherObjects = weatherDataList[@"list"];
            NSLog(@"initial array list %@ and count is %lu", weatherObjects, (unsigned long)weatherObjects.count);
        
        NSMutableArray *weatherObjectsMappedMantle = [NSMutableArray array];
        [weatherObjects enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            weatherObjectsMappedMantle[idx] = [MTLJSONAdapter modelOfClass:[LESWeatherCondition class] fromJSONDictionary:object error:nil];
                NSLog(@"Hourly Object %lu  %@ returned from server after mantle",(unsigned long)idx, weatherObjectsMappedMantle[idx]);
        }];
        
        if (completionBlock) {
            completionBlock(weatherObjectsMappedMantle, error);
        }
    }];
    
}

- (void)fetchDailyForecastWithCompletionBlock:(WeatherDataDownloadingCompletionBlock)completionBlock{
    
    
    NSString *urlString = nil;
    
    if (self.city) {
        urlString = [NSString stringWithFormat:@"%@/forecast/daily?q=%@&units=metric&cnt=7%@",kOpenWeatherMapBaseURL, self.city,kOpenWeatherMapAPIKey];
    }else{
        urlString = [NSString stringWithFormat:@"%@/forecast/daily?lat=%f&lon=%f&units=metric&cnt=7%@",kOpenWeatherMapBaseURL,self.coordinate.latitude, self.coordinate.longitude,kOpenWeatherMapAPIKey];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.jsonFetcher fetchJSONFromURL:url withCompletionBlock:^(NSDictionary *weatherDataList, NSError *error) {
        NSArray *weatherObjects = weatherDataList[@"list"];
            NSLog(@"initial array list %@ and count is %lu", weatherObjects, (unsigned long)weatherObjects.count);
        
        NSMutableArray *weatherObjectsMappedMantle = [NSMutableArray array];
        [weatherObjects enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            weatherObjectsMappedMantle[idx] = [MTLJSONAdapter modelOfClass:[LESDailyWeatherCondition class] fromJSONDictionary:object error:nil];
                NSLog(@"Daily Object %lu  %@ returned from server after mantle",(unsigned long)idx, weatherObjectsMappedMantle[idx]);
        }];
        
        if (completionBlock) {
            completionBlock(weatherObjectsMappedMantle, error);
        }
    }];
}



@end
