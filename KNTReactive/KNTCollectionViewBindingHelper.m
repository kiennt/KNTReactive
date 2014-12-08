//
//  KNTCollectionViewBindingHelper.m
//
//  Created by Kien Nguyen on 9/12/14.
//

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveViewModel/ReactiveViewModel.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "KNTReactiveView.h"
#import "KNTCollectionViewBindingHelper.h"

@interface KNTCollectionViewBindingHelper () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation KNTCollectionViewBindingHelper {
    UICollectionView *_collectionView;
    NSArray *_data;
    UITableViewCell *_templateCell;
    RACCommand *_selection;
    RVMViewModel *_parentViewModel;
}

#pragma  mark - initialization

- (instancetype) initWithCollectionView:(UICollectionView *)collectionView
                        parentViewModel:(RVMViewModel *)parentViewModel
                           sourceSignal:(RACSignal *)source
                       selectionCommand:(RACCommand *)selection
                           templateCell:(NSString *)nibName {
    
    if (self = [super init]) {
        _collectionView = collectionView;
        _data = [NSArray array];
        _selection = selection;
        _parentViewModel = parentViewModel;
        
        // each time the view model updates the array property, store the latest
        // value and reload the table view
        [source subscribeNext:^(id x) {
            self->_data = x;
            [self->_collectionView reloadData];
        }];
        
        // create an instance of the template cell and register with the table view
        UINib *templateCellNib = [UINib nibWithNibName:nibName bundle:nil];
        _templateCell = [[templateCellNib instantiateWithOwner:nil options:nil] firstObject];
        [_collectionView registerNib:templateCellNib forCellWithReuseIdentifier:_templateCell.reuseIdentifier];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return self;
}

+ (instancetype)bindingHelperForCollectionView:(UICollectionView *)collectionView
                               parentViewModel:(RVMViewModel *)parentViewModel
                                  sourceSignal:(RACSignal *)source
                              selectionCommand:(RACCommand *)selection
                                  templateCell:(NSString *)nibName {
    
    return [[KNTCollectionViewBindingHelper alloc] initWithCollectionView:collectionView
                                                          parentViewModel:parentViewModel
                                                             sourceSignal:source
                                                         selectionCommand:selection
                                                             templateCell:nibName];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id<KNTReactiveView> cell = [collectionView dequeueReusableCellWithReuseIdentifier:_templateCell.reuseIdentifier forIndexPath:indexPath];
    [cell bindViewModel:_data[indexPath.row] parentViewModel:_parentViewModel];
    return (UICollectionViewCell *)cell;
}

#pragma mark = UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // execute the command
    [_selection execute:_data[indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!cell || !indexPath)
        return;
    if ([cell respondsToSelector:@selector(didEndDisplay)]) {
        [cell performSelector:@selector(didEndDisplay)];
    }
}

@end
