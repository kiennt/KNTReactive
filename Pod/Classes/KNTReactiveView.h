//
//  KNTReactiveView.h
//
//  Created by Kien Nguyen Trung on 25/04/2014.
//  Borrow idea from
//  https://github.com/ColinEberhardt/ReactiveFlickrSearch/blob/master/RWTFlickrSearch/Util/CEReactiveView.h
//

#import <Foundation/Foundation.h>
#import <ReactiveViewModel/ReactiveViewModel.h>

@protocol KNTReactiveView <NSObject>

- (void)bindViewModel:(id)viewModel parentViewModel:(RVMViewModel *)parentViewModel;

@end
