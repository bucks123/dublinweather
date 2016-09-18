/*
 LESUtils.m
 ChatApp
 
 Created by kieran buckley on 16/09/2016.
 Copyright (c) 2014 LesApps. All rights reserved.
 */

#import "LESUtils.h"

NSString *const kWeatherAPIContentUpdateNotification = @"com.lesapps.dublinweatherapp.NewWeatherInformation";

@implementation LESUtils

+ (void)showErrorAlertWithMessage:(NSString*)textForMessage{
   
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:textForMessage
                              message:nil
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
    
	[alertView show];
    
}

@end
