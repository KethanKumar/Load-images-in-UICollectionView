//
//  ViewController.m
//  ImageLoad
//
//  Created by Software on 10/05/16.
//  Copyright © 2016 Software. All rights reserved.
//

#import "ViewController.h"

static NSString * const reuseIdentifier = @"Cell";

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [collectionViewImage registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    _imageCache = [[NSCache alloc]init];
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 150;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell* cell1 = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell1.isRed) {
        [UIView transitionWithView:cell1.contentView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                                cell1.isRed = NO;
                                cell1.backSideView.hidden=NO;
                                cell1.imageView.hidden = YES;
                            
                        } completion:nil];
    }
    else{
    [UIView transitionWithView:cell1.contentView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                            cell1.isRed = YES;
                            cell1.backSideView.hidden=YES;
                            cell1.imageView.hidden = NO;
                        
                    } completion:nil];
    }
}

-(CollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.robots.ox.ac.uk/~vgg/research/flowers_demo/images/flower_%ld.jpg",indexPath.row%10+1];
    
    CollectionViewCell *cell = (CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    CGRect finalCellFrame = cell.frame;
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    CGPoint translation = [collectionView.panGestureRecognizer translationInView:collectionView.superview];
    if (translation.x > 0) {
        cell.frame = CGRectMake(finalCellFrame.origin.x - 1000, - 500.0f, 0, 0);
    } else {
        cell.frame = CGRectMake(finalCellFrame.origin.x + 1000, - 500.0f, 0, 0);
    }
    
    [UIView animateWithDuration:0.5f animations:^(void){
        cell.frame = finalCellFrame;
    }];
    
//    [UIView transitionWithView:cell.contentView
//                      duration:0.5
//                       options:UIViewAnimationOptionTransitionFlipFromRight
//                    animations:^{
//                        cell.isRed = YES;
//                        cell.backSideView.hidden=YES;
//                        cell.imageView.hidden = NO;
//                        
//                    } completion:nil];
    
    UIImage *image = [_imageCache objectForKey:urlString];
    
    if (image)
    {
        // if we have an cachedImage sitting in memory already, then use it
        cell.imageView.image = image;
        NSLog(@"Cached");
    }
    else
    {
        NSLog(@"Not cached");
        [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, NSData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([collectionViewImage.indexPathsForVisibleItems containsObject:indexPath]) {
                    if (succeeded) {
                        cell.imageView.image = [[UIImage alloc] initWithData:data];
                        cell.imageNameLbl.text = [[[url absoluteString] lastPathComponent] stringByDeletingPathExtension];
                    }
                }
            });
            
            [_imageCache setObject:[UIImage imageWithData:data] forKey:[url absoluteString]];
            
        }];
        
    }
    
    return cell;
    
}


- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock
{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            completionBlock(YES, data);
        } else {
            completionBlock(NO, nil);
        }
    }];
    [dataTask resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
