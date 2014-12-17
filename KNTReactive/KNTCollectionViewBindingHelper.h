//
//  KNTCollectionViewBindingHelper.h
//
//  Created by Kien Nguyen on 9/12/14.
//
//

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveViewModel/ReactiveViewModel.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Foundation/Foundation.h>

@interface KNTCollectionViewBindingHelper : NSObject

@property (weak, nonatomic) id<UICollectionViewDelegate> delegate;

- (instancetype) initWithCollectionView:(UICollectionView *)collectionView
                        parentViewModel:(RVMViewModel *)parentViewModel
                           sourceSignal:(RACSignal *)source
                       selectionCommand:(RACCommand *)selection
                           templateCell:(NSString *)nibName;

+ (instancetype) bindingHelperForCollectionView:(UICollectionView *)collectionView
                                parentViewModel:(RVMViewModel *)parentViewModel
                                   sourceSignal:(RACSignal *)source
                               selectionCommand:(RACCommand *)selection
                                   templateCell:(NSString *)nibName;
@end
