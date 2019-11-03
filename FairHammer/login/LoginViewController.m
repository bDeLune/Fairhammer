#import "LoginViewController.h"
#import "Toast+UIView.h"
#import "UserStatsViewController.h"
@interface LoginViewViewController ()
{
    SignUpViewController  *signupViewController;
    UserStatsViewController *userStatsViewController;
    NSDictionary  *currentUserData;
}
@end

@implementation LoginViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.loginButton setHidden:NO];
    [self.statsButton setHidden:NO];
    userStatsViewController=[[UserStatsViewController alloc]init];
    
    self.view.backgroundColor=[UIColor clearColor];
    self.navigationItem.title=@"Login";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)reappearText{
    NSLog(@"view did appear!");
    [self.loginButton setHidden:NO];
    [self.statsButton setHidden:NO];
}

-(IBAction)loginButtonPressed:(id)sender
{
    if (!signupViewController) {
        signupViewController=[[SignUpViewController alloc]init];
        signupViewController.delegate=self;
        
        [self.navigationController pushViewController:signupViewController animated:YES];
    }else
    {
        //NSArray  *vcs=self.navigationController.viewControllers;
        [self.navigationController pushViewController:signupViewController animated:YES];
    }
    
    [self.loginButton setHidden:YES];
    [self.statsButton setHidden:YES];
    [self performSelector:@selector(reappearText) withObject:nil afterDelay:1.0];
}

-(IBAction)statsButtonPressed:(id)sender
{
    if (currentUserData)
    {
        [self showUserStats];
        [self.loginButton setHidden:YES];
        [self.statsButton setHidden:YES];
        [self performSelector:@selector(reappearText) withObject:nil afterDelay:1.0];
    }else
    {
        [self.view makeToast:@"You need to be logged in to do that"];
    }
}

-(void)showUserStats
{
    if (!userStatsViewController) {
        userStatsViewController=[[UserStatsViewController alloc]init];
        [self.navigationController pushViewController:userStatsViewController animated:YES];
    }else
    {
        [self.navigationController pushViewController:userStatsViewController animated:YES];
    }
}

#pragma mark -
#pragma mark - Signup Delegate

-(void)userCreated:(NSDictionary*)dict
{
    currentUserData=dict;
    self.navigationItem.title=[currentUserData valueForKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:[currentUserData valueForKey:@"username"] forKey:@"currentusername"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [_delegate loginSuccess];
}

-(void)userSignedIn:(NSDictionary*)dict
{
    currentUserData=dict;
    self.navigationItem.title=[currentUserData valueForKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:[currentUserData valueForKey:@"username"] forKey:@"currentusername"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [_delegate loginSuccess];
}

-(void)updateUserStats:(Session*)asession
{
    [userStatsViewController updateUserStats:asession];
}
@end
