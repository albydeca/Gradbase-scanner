//
//  ViewController.m
//  Gradbase-scanner
//
//  Created by Alberto De Capitani on 02/11/2017.
//  Copyright © 2017 Alberto De Capitani. All rights reserved.
//

#import "ViewController.h"
#import <QRCodeReaderDelegate.h>
#import <QRCodeReaderViewController.h>
#import <QRCodeReader.h>
#import <SafariServices/SafariServices.h>
@interface ViewController ()<QRCodeReaderDelegate, UIAlertViewDelegate, SFSafariViewControllerDelegate>

@end

@implementation ViewController
bool appeared = false;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the presentation style
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpQrReader {
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!appeared) {
        [self setUpQrReader];
        appeared = true;
    }
    
}
#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:NO completion:^{
        NSLog(result);
        NSURL *url = [NSURL URLWithString:result];
        NSString *host = [url host];
        if([host containsString:@"www.gradba.se"]) {
//            WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
//            UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
//            webView.delegate = self;
//            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//            [webView loadRequest:urlRequest];
//            [self.view addSubview:webView];
            SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:url];
            svc.delegate = self;
            [self presentViewController:svc animated:YES completion:nil];
            
        } else {
            NSLog(result);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid code" message:@"This QR Code does not correspond to a Gradcode" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel", nil];
            [alert show];
        }
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
}
-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setUpQrReader];
}
-(IBAction)close:(id)sender
{
    
}
//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button addTarget:self
//               action:@selector(close:)
//     forControlEvents:UIControlEventTouchDown];
//    [button setTitle:@"Close" forState:UIControlStateNormal];
//    button.frame = CGRectMake(20, 20, 109, 60);
//    [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//    [webView addSubview:button];
//}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self dismissViewControllerAnimated:true completion:nil];
    [self setUpQrReader];
}

@end

