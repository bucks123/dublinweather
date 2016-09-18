//
//  LESWeatherAPI.m
//  DublinWeatherApp
//
//  Created by kieran buckley on 16/09/2016.
//  Copyright (c) 2014 LesApps. All rights reserved.
//


#import "LESWeatherAPI.h"
#import "LESWeatherHTTPClient.h"
#import "Reachability.h"
#import "LESUtils.h"
#import "LESLocationFetcher.h"
#import "LESWeatherData.h"
#import "LESWeatherDataRemote.h"
#import "LESWeatherDataLocal.h"


@interface LESWeatherAPI() <LESLocationFetcherDelegate>

@property (nonatomic,strong,readwrite)NSArray *hourlyForecast;
@property (nonatomic,strong,readwrite)NSArray *dailyForecast;
@property (nonatomic,strong)LESLocationFetcher *locationFetcher;
@property (nonatomic,strong) id<LESWeatherData> weatherData;
@property (nonatomic,assign) BOOL isOnline;

    //Check if online
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@end

@implementation LESWeatherAPI

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        _isOnline = YES;
        _weatherData = (id<LESWeatherData>)[[LESWeatherDataRemote alloc] init];
        _locationFetcher = [[LESLocationFetcher alloc] init];
        _locationFetcher.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        _internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        
    }
    return self;
}

+(LESWeatherAPI*)sharedInstance{
    
    static LESWeatherAPI *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LESWeatherAPI alloc]init];
    });
    
    return _sharedInstance;
}

/*
 * Delegate callback with location update
 *
 */
-(void)updateWithLocation:(CLLocation*)location{
    
    if (self.isOnline) {
        self.weatherData = (id<LESWeatherData>) [[LESWeatherDataRemote alloc] initWithLocation:location.coordinate];
    }
    
    [self getCurrentWeatherCondition];
    [self getHourlyForecast];
    [self getDailyForecast];
}

#pragma mark - weather/forecast data calls

/*
 If no internet connection use Persistence to get data
 */
-(void)getCurrentWeatherCondition{
    
    __weak LESWeatherAPI *weakSelf = self;
    
    [self.weatherData getCurrentWeatherConditionWithCompletion:^(id weatherData) {
            
        LESWeatherAPI *strongSelf = weakSelf;
        if (strongSelf != nil) {
                strongSelf.currentCondition = weatherData;
                [strongSelf notifyWeatherWatchersOfWeatherUpdates];
        }
            
    }];
    
}

-(void)getHourlyForecast{
    
    __weak LESWeatherAPI *weakSelf = self;
    
    [self.weatherData getHourlyForecastWithCompletion:^(id weatherData) {
        
        LESWeatherAPI *strongSelf = weakSelf;
        if (strongSelf != nil) {
            strongSelf.hourlyForecast = weatherData;
            [strongSelf notifyWeatherWatchersOfWeatherUpdates];
        }
        
    }];
    
}

-(void)getDailyForecast{
    
    __weak LESWeatherAPI *weakSelf = self;
    
    [self.weatherData getDailyForecastWithCompletion:^(id weatherData) {
        
        LESWeatherAPI *strongSelf = weakSelf;
        if (strongSelf != nil) {
            strongSelf.dailyForecast = weatherData;
            [strongSelf notifyWeatherWatchersOfWeatherUpdates];
        }

    }];
    
}

/*
 Observer set in controller to update table and views when change in the weather data calls below returns
 */
-(void)notifyWeatherWatchersOfWeatherUpdates{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNotification *notification = [NSNotification notificationWithName:kWeatherAPIContentUpdateNotification object:nil];
        [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
    });
    
}

#pragma mark - Reachability (Online) methods

/*!
 * Called by Reachability whenever status changes. - To be dug into more
 */
- (void)reachabilityChanged:(NSNotification *)note{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        self.weatherData = (id<LESWeatherData>) [[LESWeatherDataRemote alloc] init];
        self.isOnline = NO;
    } else {
        self.weatherData = (id<LESWeatherData>) [[LESWeatherDataLocal alloc] init];
        self.isOnline = YES;
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}




@end
