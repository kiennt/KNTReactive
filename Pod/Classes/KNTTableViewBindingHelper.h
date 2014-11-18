//
//  KNTTableViewBindingHelper.h
//
//  Created by Kien Nguyen Trung on 25/04/2014.
//
//  Borrow idea from
//  https://github.com/ColinEberhardt/ReactiveFlickrSearch/blob/master/RWTFlickrSearch/Util/CETableViewBindingHelper.h
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface KNTTableViewBindingHelper : NSObject

@property (weak, nonatomic) id<UITableViewDelegate> delegate;

- (instancetype) initWithTableView:(UITableView *)tableView
                   parentViewModel:(RVMViewModel *)parentViewModel
                      sourceSignal:(RACSignal *)source
                  selectionCommand:(RACCommand *)selection
                      templateCell:(NSString *)nibName;

+ (instancetype) bindingHelperForTableView:(UITableView *)tableView
                           parentViewModel:(RVMViewModel *)parentViewModel
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)selection
                              templateCell:(NSString *)nibName;

@end
