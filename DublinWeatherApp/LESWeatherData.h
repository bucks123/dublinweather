//
//  LESWeatherData.h
//  DublinWeatherApp
//
//  Created by Kieran Buckley on 17/09/2016.
//  Copyright © 2016 LesApps. All rights reserved.
//

@class LESWeatherCondition;

typedef void (^WeatherCompletionBlock)(id weatherData);

@protocol LESWeatherData <NSObject>

@required
-(void)getCurrentWeatherConditionWithCompletion:(WeatherCompletionBlock)completionBlock;
-(void)getDailyForecastWithCompletion:(WeatherCompletionBlock)completionBlock;;
-(void)getHourlyForecastWithCompletion:(WeatherCompletionBlock)completionBlock;;


@end
