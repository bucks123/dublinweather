//
//  LESLocationFetcher.h
//  DublinWeatherApp
//
//  Created by Kieran Buckley on 16/09/2016.
//  Copyright © 2016 LesApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LESLocationFetcherDelegate;

@interface LESLocationFetcher : NSObject

@property(nonatomic,weak)id<LESLocationFetcherDelegate>delegate;
-(void)findCurrentLocation;

@end


@protocol LESLocationFetcherDelegate <NSObject>

@required
-(void)updateWithLocation:(CLLocation*)location;
@optional
-(void)didFailWithError:(NSError*)error;

@end