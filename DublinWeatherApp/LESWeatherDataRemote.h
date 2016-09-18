//
//  LESWeatherDataManager.h
//  DublinWeatherApp
//
//  Created by Kieran Buckley on 17/09/2016.
//  Copyright © 2016 LesApps. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface LESWeatherDataRemote : NSObject

-(instancetype)initWithLocation:(CLLocationCoordinate2D)coordinate;

@end
