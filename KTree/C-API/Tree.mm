//
//  Tree.m
//  KTree
//
//  Created by Kyle Burns on 8/29/21.
//  Copyright © 2021 Kyle Burns. All rights reserved.
//

#import "Tree.h"
#include <map>
#define PRIMARY_INDEX_KEY @"key_index"

IndexEntry * initialize_index_entry(size_t key, long data_address, long data_length) {
    IndexEntry *result = static_cast<IndexEntry *>( malloc(STRIDE));
    result->key = key;
    result->left = result->right = result->parent = -1;
    result->weight = DEFAULT_WEIGHT;
    result->creation_time = time(NULL);
    result->data_address = data_address;
    result->data_length = data_length;
    return result;
}

void print_entry(IndexEntry *entry) {
    printf("%lu, %li, %li, %li, %f, %f, %li, %li\n", entry->key, entry->left, entry->right, entry->parent, entry->weight, entry->creation_time, entry->data_address, entry->data_length);
}

@implementation Tree

std::map<NSString *, FILE *> indexFiles;

- (void) readFromFile:(FILE *)file
                 into:(void *)data
                start:(long)start
                bytes:(long)bytes {
    fseek(file, start, SEEK_SET);
    fread(data, bytes, 1, file);
}


- (void) writeToFile:(FILE *)file
            fromData:(const void *)data
               start:(long)start
               bytes:(long)bytes {
    fseek(file, start, SEEK_SET);
    printf("start: %li bytes: %li\n", start, bytes);
    printf("about to write data: %s at %li\n", data, start);
//    fwrite(data, bytes, 1, file);
    fwrite(data, bytes, 1, file);
}

- (void) updateCount {
    fseek(metadata, COUNT_ADDRESS, SEEK_SET);
    fwrite(&_count, sizeof(long), 1, metadata);
}

- (void) rotateRightAtNode:(long)index {
    
}

- (void) rotateLeftAtNode:(long)index {
    
}

- (NSData *)searchUtilForKey:(size_t)key
                 current:(IndexEntry *)current
               rootIndex:(long)index
               indexFile:(FILE *)indexFile {
    if (index == UNASSIGNED) { return nil; }
    [self readFromFile:indexFile into:current start:index * STRIDE bytes:STRIDE];
    if (current->key == key) {
        void *data = malloc(current->data_length);
        [self readFromFile:dataFile into:data start:current->data_address bytes:current->data_length];
        return [[NSData alloc] initWithBytes:data length:current->data_length];
    } else if (key < current->key) {
        return [self searchUtilForKey:key current:current rootIndex:current->left indexFile:indexFile];
    } else {
        return [self searchUtilForKey:key current:current rootIndex:current->right indexFile:indexFile];
    }
}

- (void) insertUtilWithIndexEntry:(IndexEntry *)entry          current:(IndexEntry *)current
                            data:(const void *)data
                           bytes:(long)bytes
                       rootIndex:(long)index
                       indexFile:(FILE *)indexFile {
    if (self.count == 0) {
        printf("inserting at root\n");
        [self writeToFile:indexFile fromData:entry start: _count++ * STRIDE bytes:STRIDE];
        [self writeToFile:dataFile fromData:data start:dataCursor bytes:bytes];
        dataCursor += bytes;
        [self updateCount];
    } else {
        [self readFromFile:indexFile into:current start: index * STRIDE bytes:STRIDE];
        if (entry->key < current->key) {
            if (current->left == UNASSIGNED) {
                printf("inserting at left child\n");
                current->left = _count;
                [self writeToFile:indexFile fromData:current start:index * STRIDE bytes:STRIDE];
                print_entry(current);
                entry->parent = index;
                [self writeToFile:indexFile fromData:entry start: _count++ * STRIDE bytes:STRIDE];
                [self writeToFile:dataFile fromData:data start:dataCursor bytes:bytes];
                dataCursor += bytes;
            } else {
                [self insertUtilWithIndexEntry:entry current:current data:data bytes:bytes rootIndex:current->left indexFile:indexFile];
            }
        } else if (entry->key > current->key) {
            if (current->right == UNASSIGNED) {
                printf("inserting at right child\n");
                current->right = _count;
                [self writeToFile:indexFile fromData:current start:_count * STRIDE bytes:STRIDE];
                print_entry(current);
                entry->parent = index;
                [self writeToFile:indexFile fromData:entry start: _count++ * STRIDE bytes:STRIDE];
                [self writeToFile:dataFile fromData:data start:dataCursor bytes:bytes];
                dataCursor += bytes;
            } else {
                [self insertUtilWithIndexEntry:entry current:current data:data bytes:bytes rootIndex:current->right indexFile:indexFile];
            }
        } else {
            perror("Duplicates not allowed");
        }
    }
}

- (size_t) hash:(char *)str {
    size_t hash = 5381;
    int c;

    while ((c = *str++))
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

    return hash;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        _count = 0;
        dataCursor = 0;
    }
    return self;
}

- (void) dealloc {
    for (std::map<NSString *, FILE *>::iterator it = indexFiles.begin(); it != indexFiles.end(); it++) {
        fclose(it->second);
    }
    fclose(metadata);
    fclose(dataFile);
}

- (void) setStoragePathWithUrl:(NSURL *)url {
    const char *indexFilename = [[url path] stringByAppendingString:@"_key_index.bin"].UTF8String;
    const char *dataFilename = [[url path] stringByAppendingString:@"_data.bin"].UTF8String;
    const char *metadataFilename = [[url path] stringByAppendingString:@"_metadata.bin"].UTF8String;
    FILE *indexFile = fopen(indexFilename, "rb+");
    indexFiles[PRIMARY_INDEX_KEY] = indexFile;
    dataFile = fopen(dataFilename, "rb+");
    metadata = fopen(metadataFilename, "rb+");
//    printf("%s\n", [[url path] stringByAppendingString:@"_data.bin"].UTF8String);
    if (!dataFile && !indexFilename && !metadata) {
        indexFile = fopen(indexFilename, "wb+");
        indexFiles[PRIMARY_INDEX_KEY] = indexFile;
        dataFile = fopen(dataFilename, "wb+");
        metadata = fopen(metadataFilename, "wb+");
    }
    
    if (!dataFile || !indexFile || !metadata) {
        printf("houston we got a problem: %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }
    
    // read metadata
    [self readFromFile:metadata into:&_count start:COUNT_ADDRESS bytes:sizeof(long)];
    printf("count: %li\n", _count);
}

- (void) addDocumentFrom:(NSData *)data forKeyPath:(NSString *)path {
    IndexEntry *current = static_cast<IndexEntry *>( malloc(STRIDE));
    IndexEntry *entry = initialize_index_entry([path hash], dataCursor, [data length]);
    print_entry(entry);
    [self insertUtilWithIndexEntry:entry current:current data:[data bytes] bytes:entry->data_length rootIndex:0 indexFile:indexFiles[PRIMARY_INDEX_KEY]];
    free(entry);
    free(current);
}

- (NSData *) getDocumentAtKeyPath:(NSString *)path {
    IndexEntry *current = static_cast<IndexEntry *>(malloc(STRIDE));
    NSData *result = [self searchUtilForKey:[path hash] current:current rootIndex:0 indexFile:indexFiles[PRIMARY_INDEX_KEY]];
    free(current);
    return result;
}

@end
