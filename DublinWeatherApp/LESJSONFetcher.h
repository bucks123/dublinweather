//
//  LESJSONFetcher.h
//  DublinWeatherApp
//
//  Created by Kieran Buckley on 16/09/2016.
//  Copyright © 2016 LesApps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JsonReturnedCompletionBlock)(id jsonObj, NSError *error);

@interface LESJSONFetcher : NSObject

-(void)fetchJSONFromURL:(NSURL *)url withCompletionBlock:(JsonReturnedCompletionBlock)completionBlock;

@end
