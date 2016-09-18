//
//  LESWeatherHTTPClient.h
//  DublinWeatherApp
//
//  Created by kieran buckley on 16/09/2016.
//  Copyright (c) 2014 LesApps. All rights reserved.
//

@import CoreLocation;

@interface LESWeatherHTTPClient : NSObject

-(instancetype)initWithLocation:(CLLocationCoordinate2D)coordinate;

@end