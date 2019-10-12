#import "FlutterFileHelperPlugin.h"

@implementation FlutterFileHelperPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"plugins.mysoft/file_helper"
                                     binaryMessenger:[registrar messenger]];
    FlutterFileHelperPlugin* instance = [[FlutterFileHelperPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

    NSString *methodName = call.method;
    if ([@"getAvailableSize" isEqualToString:methodName]) {
        double availableStorageSize = [self getFreeSize];
        result(@(availableStorageSize));
    }else if ([@"getTotalSize" isEqualToString:methodName]){

        double totalStorageSize = [self getTotalSize];
        result(@(totalStorageSize));
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

- (double)getTotalSize
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *fat = [fm attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    double totalSize = [[fat objectForKey:NSFileSystemSize] doubleValue];
    return totalSize;
}

- (double)getFreeSize
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *fat = [fm attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    double freeSize = [[fat objectForKey:NSFileSystemFreeSize] doubleValue];
    if (@available(iOS 11.0, *)) {

        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:NSTemporaryDirectory()];
        NSDictionary *results = [fileURL resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey] error:nil];
        freeSize = [results[NSURLVolumeAvailableCapacityForImportantUsageKey] doubleValue];
    }
    return freeSize;
}
@end
