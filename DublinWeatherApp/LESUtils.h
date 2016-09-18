/*
  LESUtils.h
  ChatApp

  Created by kieran buckley on 11/05/2014.
  Copyright (c) 2014 LesApps. All rights reserved.
*/

#import <Foundation/Foundation.h>

    //Notification when new weather api data comes in
extern NSString * const kWeatherAPIContentUpdateNotification;


@interface LESUtils : NSObject

// Convenience function to show a UIAlertView
+ (void)showErrorAlertWithMessage:(NSString*)textForMessage;
@end
