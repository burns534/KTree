//
//  Tree.m
//  KTree
//
//  Created by Kyle Burns on 8/29/21.
//  Copyright © 2021 Kyle Burns. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_WEIGHT 10.0
#define UNASSIGNED -1
#define STRIDE sizeof(IndexEntry)
#define COUNT_ADDRESS 0

typedef struct {
    size_t key; // hash of username
    long left, right, parent; // line #s
    double weight, creation_time;
    long data_address, data_length;
} IndexEntry;

IndexEntry * _Nonnull initialize_index_entry(size_t, long, long);
void print_entry(IndexEntry * _Nullable);

@interface Tree : NSObject {
//    FILE *indexFile, *dataFile;
    FILE *dataFile, *metadata;
    long dataCursor;
}
@property (nonatomic) size_t count;
- (nonnull instancetype) init;
- (void) dealloc;
- (void) setStoragePathWithUrl:(nonnull NSURL *)url;
- (void) addDocumentFrom:(nonnull NSData *)data forKeyPath:(nonnull NSString *)path;
- (nonnull NSData *) getDocumentAtKeyPath:(nonnull NSString *)path;

@end


