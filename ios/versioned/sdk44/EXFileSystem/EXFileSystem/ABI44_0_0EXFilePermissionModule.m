// Copyright 2015-present 650 Industries. All rights reserved.
#import <ABI44_0_0EXFileSystem/ABI44_0_0EXFilePermissionModule.h>
#import <ABI44_0_0ExpoModulesCore/ABI44_0_0EXFileSystemInterface.h>

@interface ABI44_0_0EXFilePermissionModule ()

@property (nonatomic, weak) ABI44_0_0EXModuleRegistry *moduleRegistry;

@end

@implementation ABI44_0_0EXFilePermissionModule

ABI44_0_0EX_REGISTER_MODULE();

+ (const NSArray<Protocol *> *)exportedInterfaces
{
  return @[@protocol(ABI44_0_0EXFilePermissionModuleInterface)];
}

- (ABI44_0_0EXFileSystemPermissionFlags)getPathPermissions:(NSString *)path
{
  ABI44_0_0EXFileSystemPermissionFlags permissionsForInternalDirectories = [self getInternalPathPermissions:path];
  if (permissionsForInternalDirectories != ABI44_0_0EXFileSystemPermissionNone) {
    return permissionsForInternalDirectories;
  } else {
    return [self getExternalPathPermissions:path];
  }
}

- (ABI44_0_0EXFileSystemPermissionFlags)getInternalPathPermissions:(NSString *)path
{
  id<ABI44_0_0EXFileSystemInterface> fileSystem = [_moduleRegistry getModuleImplementingProtocol:@protocol(ABI44_0_0EXFileSystemInterface)];
  NSArray<NSString *> *scopedDirs = @[fileSystem.cachesDirectory, fileSystem.documentDirectory];
  NSString *standardizedPath = [path stringByStandardizingPath];
  for (NSString *scopedDirectory in scopedDirs) {
    if ([standardizedPath hasPrefix:[scopedDirectory stringByAppendingString:@"/"]] ||
        [standardizedPath isEqualToString:scopedDirectory]) {
      return ABI44_0_0EXFileSystemPermissionRead | ABI44_0_0EXFileSystemPermissionWrite;
    }
  }

  NSString *bundleDirectory = fileSystem.bundleDirectory;
  if (bundleDirectory != nil && [path hasPrefix:[bundleDirectory stringByAppendingString:@"/"]]) {
    return ABI44_0_0EXFileSystemPermissionRead;
  }

  return ABI44_0_0EXFileSystemPermissionNone;
}

- (ABI44_0_0EXFileSystemPermissionFlags)getExternalPathPermissions:(NSString *)path
{
  ABI44_0_0EXFileSystemPermissionFlags filePermissions = ABI44_0_0EXFileSystemPermissionNone;
  if ([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
    filePermissions |= ABI44_0_0EXFileSystemPermissionRead;
  }

  if ([[NSFileManager defaultManager] isWritableFileAtPath:path]) {
    filePermissions |= ABI44_0_0EXFileSystemPermissionWrite;
  }

  return filePermissions;
}

- (void)setModuleRegistry:(ABI44_0_0EXModuleRegistry *)moduleRegistry {
  _moduleRegistry = moduleRegistry;
}

@end
