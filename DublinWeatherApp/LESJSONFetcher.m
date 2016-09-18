//
//  LESJSONFetcher.m
//  DublinWeatherApp
//
//  Created by Kieran Buckley on 16/09/2016.
//  Copyright © 2016 LesApps. All rights reserved.
//

#import "LESJSONFetcher.h"

@interface LESJSONFetcher()
@property (nonatomic,strong) NSURLSession *session;
@end

@implementation LESJSONFetcher

-(instancetype)init{
    
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}


-(void)fetchJSONFromURL:(NSURL *)url withCompletionBlock:(JsonReturnedCompletionBlock)completionBlock{
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        id jsonObj = nil;
        
        if(!error){
            NSError *jsonError = nil;
            jsonObj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        }
        
        if (completionBlock) {
            completionBlock(jsonObj, error);
        }
        
    }];
    
    [dataTask resume];
}


@end
