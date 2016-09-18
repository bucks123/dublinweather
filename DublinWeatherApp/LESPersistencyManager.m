//
//  LESPersistencyManager.m
//  DublinWeatherApp
//
//  Created by kieran buckley on 16/09/2016.
//  Copyright (c) 2014 LesApps. All rights reserved.
//

#import "LESPersistencyManager.h"

static NSString * const kRootKey = @"RootKey";

@implementation LESPersistencyManager

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
       
    }
    return self;
}

-(void)addWeatherCondition:(LESWeatherCondition*)weatherCondition{
    
    NSString *filePath = [self dataFilePathWithFileName:@"weathercondition.archive"];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:weatherCondition forKey:kRootKey];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
    
}

-(void)addHourlyForecast:(NSArray*)hourlyForecast{
    
    NSString *filePath = [self dataFilePathWithFileName:@"hourlyforecast.archive"];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:hourlyForecast forKey:kRootKey];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}

-(void)addDailyForecast:(NSArray*)dailyForecast{
   
    NSString *filePath = [self dataFilePathWithFileName:@"dailyforecast.archive"];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dailyForecast forKey:kRootKey];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}


-(LESWeatherCondition*)getWeatherCondition{
    
    NSString *filePath = [self dataFilePathWithFileName:@"weathercondition.archive"];
    
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    LESWeatherCondition *weatherCondition = [unarchiver decodeObjectForKey:kRootKey];
    [unarchiver finishDecoding];
    
    return weatherCondition;
}

-(NSArray*)getHourlyForecast{
    
     NSString *filePath = [self dataFilePathWithFileName:@"hourlyforecast.archive"];
    
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray *hourlyForecast = [unarchiver decodeObjectForKey:kRootKey];
    [unarchiver finishDecoding];
    
    return hourlyForecast;
}

-(NSArray*)getDailyForecast{
    
    NSString *filePath = [self dataFilePathWithFileName:@"dailyforecast.archive"];
    
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray *dailyForecast = [unarchiver decodeObjectForKey:kRootKey];
    [unarchiver finishDecoding];
    
    return dailyForecast;
}

-(NSString*)dataFilePathWithFileName:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
        // NSLog(@"File Path : %@", [documentsDirectory stringByAppendingPathComponent:fileName]);
    
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}


@end
