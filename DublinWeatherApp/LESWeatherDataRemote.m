//
//  LESWeatherDataManager.m
//  DublinWeatherApp
//
//  Created by Kieran Buckley on 17/09/2016.
//  Copyright © 2016 LesApps. All rights reserved.
//

#import "LESWeatherDataRemote.h"
#import "LESWeatherData.h"
#import "LESWeatherHTTPClient.h"
#import "LESWeatherDataHTTP.h"
#import "LESWeatherCondition.h"
#import "LESPersistencyManager.h"

@interface LESWeatherDataRemote() <LESWeatherData>

@property (nonatomic,strong) id<LESWeatherDataHTTP> weatherData;
@property (strong,nonatomic) LESPersistencyManager *persistencyManager;

@end

@implementation LESWeatherDataRemote


-(instancetype)init{
    
    CLLocationDegrees lat = 53.3498;
    CLLocationDegrees lon = 6.2603;
    
    CLLocationCoordinate2D dublin = CLLocationCoordinate2DMake(lat,lon);
    return [self initWithLocation:dublin];
    
}

-(instancetype)initWithLocation:(CLLocationCoordinate2D)coordinate{
    
    self = [super init];
    
    if (self) {
       
       _weatherData = (id<LESWeatherDataHTTP>)[[LESWeatherHTTPClient alloc] initWithLocation:coordinate];
        _persistencyManager = [[LESPersistencyManager alloc] init];
        
    }
    return self;
}

-(instancetype)initWithCity:(NSString*)city{
    
    self = [super init];
    
    if (self) {
        
        _weatherData = (id<LESWeatherDataHTTP>)[[LESWeatherHTTPClient alloc] initWithCity:city];
        _persistencyManager = [[LESPersistencyManager alloc] init];
        
    }
    return self;
}

-(void)getCurrentWeatherConditionWithCompletion:(WeatherCompletionBlock)completionBlock;{
    
    __block LESWeatherCondition *currentCondition;
    __weak LESWeatherDataRemote *weakSelf = self;
    
    [self.weatherData fetchCurrentConditionWithCompletionBlock:^(id weatherData, NSError *error) {
        
        LESWeatherDataRemote *strongSelf = weakSelf;
        if (strongSelf != nil) {
            
            if (weatherData != nil && [weatherData isKindOfClass:[LESWeatherCondition class]]) {
                currentCondition = weatherData;
                [strongSelf.persistencyManager addWeatherCondition:currentCondition];
                if (completionBlock) {
                    completionBlock(currentCondition);
                }
            }else{
                completionBlock(nil);
            
                //show alert for error
            }
        }
        
        
    }];
}

-(void)getDailyForecastWithCompletion:(WeatherCompletionBlock)completionBlock;{
    
    __block NSArray *dailyForecast;
    __weak LESWeatherDataRemote *weakSelf = self;
    
    [self.weatherData fetchDailyForecastWithCompletionBlock:^(id weatherDataArray, NSError *error) {
        
        LESWeatherDataRemote *strongSelf = weakSelf;
        
        if (strongSelf != nil) {
    
            if (weatherDataArray != nil) {
                dailyForecast = weatherDataArray;
                [strongSelf.persistencyManager addDailyForecast:dailyForecast];
                if (completionBlock) {
                    completionBlock(dailyForecast);
                }
                //[self notifyWeatherWatchersOfWeatherUpdates];
            }else{
                completionBlock(nil);
                
                //show alert for error
            }
        }
       
    }];
    
}

-(void)getHourlyForecastWithCompletion:(WeatherCompletionBlock)completionBlock;{
    
    __block NSArray *hourlyForecast;
    __weak LESWeatherDataRemote *weakSelf = self;
    
    [self.weatherData fetchHourlyForecastWithCompletionBlock:^(id weatherDataArray, NSError *error) {
        
        LESWeatherDataRemote *strongSelf = weakSelf;
        
        if (strongSelf != nil) {
            
            if (weatherDataArray != nil) {
                
                hourlyForecast = weatherDataArray;
                [strongSelf.persistencyManager addHourlyForecast:hourlyForecast];
                if (completionBlock) {
                    completionBlock(hourlyForecast);
                }
                // [self notifyWeatherWatchersOfWeatherUpdates];
            }else{
                completionBlock(nil);
                //show alert for error
            }
            
        }
    }];

}


@end
