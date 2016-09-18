//
//  LESWeatherDataLocal.m
//  DublinWeatherApp
//
//  Created by Kieran Buckley on 17/09/2016.
//  Copyright © 2016 LesApps. All rights reserved.
//

#import "LESWeatherDataLocal.h"
#import "LESWeatherData.h"
#import "LESPersistencyManager.h"

@interface LESWeatherDataLocal() <LESWeatherData>

@property (strong,nonatomic) LESPersistencyManager *persistencyManager;

@end

@implementation LESWeatherDataLocal

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        _persistencyManager = [[LESPersistencyManager alloc] init];
        
    }
    return self;
}

-(void)getCurrentWeatherConditionWithCompletion:(WeatherCompletionBlock)completionBlock;{
    
    LESWeatherCondition *weatherCondition = [self.persistencyManager getWeatherCondition];
    if (completionBlock) {
        completionBlock(weatherCondition);
    }
    
}

-(void)getDailyForecastWithCompletion:(WeatherCompletionBlock)completionBlock;{
    
    NSArray *dailyForecast = [self.persistencyManager getDailyForecast];
    if (completionBlock) {
        completionBlock(dailyForecast);
    }
    
}

-(void)getHourlyForecastWithCompletion:(WeatherCompletionBlock)completionBlock;{
    
    NSArray *hourlyForecast = [self.persistencyManager getHourlyForecast];
    if (completionBlock) {
        completionBlock(hourlyForecast);
    }

}


@end
