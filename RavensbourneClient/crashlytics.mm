//
//  crashlytics.m
//  RavensbourneTable
//
//  Created by Jonathan Jones-morris on 08/02/2017.
//
//

#import <Foundation/Foundation.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

void setupCrashlytics() {
    [Fabric with:@[[Crashlytics class]]];
}
