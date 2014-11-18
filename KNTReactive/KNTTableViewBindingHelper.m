//
//  KNTTableViewBindingHelper.m
//
//  Created by Kien Nguyen Trung on 25/04/2014.
//  Borrow idea from
//  https://github.com/ColinEberhardt/ReactiveFlickrSearch/blob/master/RWTFlickrSearch/Util/CETableViewBindingHelper.m
//

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveViewModel/ReactiveViewModel.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "KNTReactiveView.h"
#import "KNTTableViewBindingHelper.h"


@interface KNTTableViewBindingHelper () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation KNTTableViewBindingHelper {
    UITableView *_tableView;
    NSArray *_data;
    UITableViewCell *_templateCell;
    RACCommand *_selection;
    RVMViewModel *_parentViewModel;
}

#pragma  mark - initialization

- (instancetype)initWithTableView:(UITableView *)tableView
                  parentViewModel:(RVMViewModel *)parentViewModel
                     sourceSignal:(RACSignal *)source
                 selectionCommand:(RACCommand *)selection
                     templateCell:(NSString *)nibName {
    
    if (self = [super init]) {
        _tableView = tableView;
        _data = [NSArray array];
        _selection = selection;
        _parentViewModel = parentViewModel;
        
        // each time the view model updates the array property, store the latest
        // value and reload the table view
        [source subscribeNext:^(id x) {
            self->_data = x;
            [self->_tableView reloadData];
        }];
        
        // create an instance of the template cell and register with the table view
        UINib *templateCellNib = [UINib nibWithNibName:nibName bundle:nil];
        _templateCell = [[templateCellNib instantiateWithOwner:nil options:nil] firstObject];
        [_tableView registerNib:templateCellNib forCellReuseIdentifier:_templateCell.reuseIdentifier];
        
        // use the template cell to set the row height
        _tableView.rowHeight = _templateCell.bounds.size.height;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return self;
}

+ (instancetype)bindingHelperForTableView:(UITableView *)tableView
                          parentViewModel:(RVMViewModel *)parentViewModel
                             sourceSignal:(RACSignal *)source
                         selectionCommand:(RACCommand *)selection
                             templateCell:(NSString *)nibName {
    
    return [[KNTTableViewBindingHelper alloc] initWithTableView:tableView
                                               parentViewModel:parentViewModel
                                                  sourceSignal:source
                                              selectionCommand:selection
                                                  templateCell:nibName];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<KNTReactiveView> cell = [tableView dequeueReusableCellWithIdentifier:_templateCell.reuseIdentifier];
    [cell bindViewModel:_data[indexPath.row] parentViewModel:_parentViewModel];
    
    UITableViewCell *tableViewCell = (UITableViewCell *)cell;
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableViewCell;
}

#pragma mark = UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // execute the command
    [_selection execute:_data[indexPath.row]];
    
    // forward the delegate method
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark = UITableViewDelegate forwarding

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
