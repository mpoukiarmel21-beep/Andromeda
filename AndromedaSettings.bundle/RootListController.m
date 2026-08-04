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

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
