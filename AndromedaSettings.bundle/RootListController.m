#import <Preferences/Preferences.h>
#import <spawn.h>

@interface AndromedaRootListController : PSListController
@end

@implementation AndromedaRootListController

- (NSArray*)specifiers {
    if(!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (void)respring {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Andromeda"
        message:@"Respring now to apply changes?"
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action) {
        pid_t pid;
        const char* args[] = { "sbreload", NULL };
        posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)scanStatus {
    Class scannerClass = NSClassFromString(@"AdaptiveScanner");
    NSArray *selectors = @[];
    NSArray *classes = @[];

    if (scannerClass) {
        id scanner = [scannerClass performSelector:@selector(sharedInstance)];
        if (scanner) {
            selectors = [scanner performSelector:@selector(lastDetectedSelectors)] ?: @[];
            classes = [scanner performSelector:@selector(lastDetectedClasses)] ?: @[];
        }
    }

    NSString *message;
    if (selectors.count == 0 && classes.count == 0) {
        message = @"No detections found yet.\n\nEnable Adaptive Mode, then launch a protected app to trigger a scan.";
    } else {
        NSMutableString *selList = [NSMutableString string];
        for (NSString *s in selectors) {
            [selList appendFormat:@"  %@\n", s];
        }
        message = [NSString stringWithFormat:
            @"Last scan results:\n\n"
            @"%lu selectors hooked\n"
            @"%lu suspicious classes found\n\n"
            @"Hooked selectors:\n%@",
            (unsigned long)selectors.count,
            (unsigned long)classes.count,
            selList];
    }

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Adaptive Scan Status"
        message:message
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
