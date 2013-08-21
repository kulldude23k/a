

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController<UIAlertViewDelegate> {
     IBOutlet UIImageView *registerView_por,*registerView_lan;
    IBOutlet UIView *portraitView;
    IBOutlet UIView *landscapView;
    
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString;

@end
