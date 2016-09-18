//
//  LESWeatherData.h
//  DublinWeatherApp
//
//  Created by Kieran Buckley on 17/09/2016.
//  Copyright © 2016 LesApps. All rights reserved.
//
@import CoreLocation;

typedef void (^WeatherDataDownloadingCompletionBlock)(id weatherData, NSError *error);

@protocol LESWeatherDataHTTP <NSObject>

-(void)fetchCurrentConditionWithCompletionBlock:(WeatherDataDownloadingCompletionBlock)completionBlock;
-(void)fetchHourlyForecastWithCompletionBlock:(WeatherDataDownloadingCompletionBlock)completionBlock;
-(void)fetchDailyForecastWithCompletionBlock:(WeatherDataDownloadingCompletionBlock)completionBlock;

@end
