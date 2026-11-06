#!/usr/bin/env python3
import os
import hashlib
from pathlib import Path

def uuid_for(seed: str) -> str:
    h = hashlib.md5(seed.encode('utf-8')).hexdigest().upper()
    return h[:24]

def main():
    base_dir = Path("/Users/ratnamsmac/Documents/Projects/LabLearn")
    app_dir = base_dir / "LabLearn"
    proj_dir = base_dir / "LabLearn.xcodeproj"
    proj_dir.mkdir(exist_ok=True)
    scheme_dir = proj_dir / "xcshareddata" / "xcschemes"
    scheme_dir.mkdir(parents=True, exist_ok=True)
    
    # Collect all swift files
    swift_files = []
    for root, _, files in os.walk(app_dir):
        for f in files:
            if f.endswith(".swift"):
                rel_path = os.path.relpath(os.path.join(root, f), base_dir)
                swift_files.append((f, rel_path))
    
    swift_files.sort(key=lambda x: x[1])
    
    # Main project UUIDs
    proj_uuid = uuid_for("PROJECT")
    target_uuid = uuid_for("TARGET_LABLEARN")
    main_group_uuid = uuid_for("GROUP_MAIN")
    products_group_uuid = uuid_for("GROUP_PRODUCTS")
    app_group_uuid = uuid_for("GROUP_LABLEARN")
    app_product_uuid = uuid_for("PRODUCT_LABLEARN_APP")
    
    sources_phase_uuid = uuid_for("PHASE_SOURCES")
    resources_phase_uuid = uuid_for("PHASE_RESOURCES")
    frameworks_phase_uuid = uuid_for("PHASE_FRAMEWORKS")
    
    proj_cfg_list_uuid = uuid_for("CFGLIST_PROJECT")
    proj_cfg_debug_uuid = uuid_for("CFG_PROJ_DEBUG")
    proj_cfg_release_uuid = uuid_for("CFG_PROJ_RELEASE")
    
    target_cfg_list_uuid = uuid_for("CFGLIST_TARGET")
    target_cfg_debug_uuid = uuid_for("CFG_TARGET_DEBUG")
    target_cfg_release_uuid = uuid_for("CFG_TARGET_RELEASE")
    
    assets_rel = "LabLearn/Resources/Assets.xcassets"
    assets_file_uuid = uuid_for("FILE_" + assets_rel)
    assets_build_uuid = uuid_for("BUILD_" + assets_rel)
    
    info_plist_rel = "LabLearn/Resources/Info.plist"
    info_plist_file_uuid = uuid_for("FILE_" + info_plist_rel)
    
    # Dynamically detect directories inside LabLearn
    detected_subdirs = set()
    for _, rel_path in swift_files:
        parts = rel_path.split("/")
        # LabLearn/<group>/...
        if len(parts) >= 3 and parts[0] == "LabLearn":
            # If parts[1] == "Views", it could be Views/Common or Views/<something>
            if parts[1] == "Views" and len(parts) >= 4:
                detected_subdirs.add(f"Views/{parts[2]}")
            else:
                detected_subdirs.add(parts[1])
    
    subgroups = {k: [] for k in sorted(detected_subdirs)}
    subgroups["Resources"] = []
    
    file_objs = []
    build_objs = []
    
    for filename, rel_path in swift_files:
        f_uuid = uuid_for("FILE_" + rel_path)
        b_uuid = uuid_for("BUILD_" + rel_path)
        file_objs.append((f_uuid, filename, rel_path))
        build_objs.append((b_uuid, f_uuid, filename))
        
        for key in subgroups.keys():
            if f"LabLearn/{key}/" in rel_path or (key == "App" and "LabLearn/App" in rel_path):
                subgroups[key].append((f_uuid, filename))
                break
    
    subgroup_uuids = {k: uuid_for("GROUP_" + k) for k in subgroups.keys()}
    views_group_uuid = uuid_for("GROUP_Views")
    
    pbx = []
    pbx.append("// !$*UTF8*$!")
    pbx.append("{")
    pbx.append("\tarchiveVersion = 1;")
    pbx.append("\tclasses = {")
    pbx.append("\t};")
    pbx.append("\tobjectVersion = 56;")
    pbx.append("\tobjects = {")
    
    # PBXBuildFile
    pbx.append("/* Begin PBXBuildFile section */")
    for b_uuid, f_uuid, filename in build_objs:
        pbx.append(f"\t\t{b_uuid} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {f_uuid} /* {filename} */; }};")
    pbx.append(f"\t\t{assets_build_uuid} /* Assets.xcassets in Resources */ = {{isa = PBXBuildFile; fileRef = {assets_file_uuid} /* Assets.xcassets */; }};")
    pbx.append("/* End PBXBuildFile section */\n")
    
    # PBXFileReference
    pbx.append("/* Begin PBXFileReference section */")
    pbx.append(f"\t\t{app_product_uuid} /* LabLearn.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = LabLearn.app; sourceTree = BUILT_PRODUCTS_DIR; }};")
    for f_uuid, filename, rel_path in file_objs:
        pbx.append(f"\t\t{f_uuid} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = \"{filename}\"; sourceTree = \"<group>\"; }};")
    pbx.append(f"\t\t{assets_file_uuid} /* Assets.xcassets */ = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = \"<group>\"; }};")
    pbx.append(f"\t\t{info_plist_file_uuid} /* Info.plist */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = \"<group>\"; }};")
    pbx.append("/* End PBXFileReference section */\n")
    
    # PBXFrameworksBuildPhase
    pbx.append("/* Begin PBXFrameworksBuildPhase section */")
    pbx.append(f"\t\t{frameworks_phase_uuid} /* Frameworks */ = {{")
    pbx.append("\t\t\tisa = PBXFrameworksBuildPhase;")
    pbx.append("\t\t\tbuildActionMask = 2147483647;")
    pbx.append("\t\t\tfiles = (")
    pbx.append("\t\t\t);")
    pbx.append("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
    pbx.append("\t\t};")
    pbx.append("/* End PBXFrameworksBuildPhase section */\n")
    
    # PBXGroup
    pbx.append("/* Begin PBXGroup section */")
    
    # Main Group
    pbx.append(f"\t\t{main_group_uuid} = {{")
    pbx.append("\t\t\tisa = PBXGroup;")
    pbx.append("\t\t\tchildren = (")
    pbx.append(f"\t\t\t\t{app_group_uuid} /* LabLearn */,")
    pbx.append(f"\t\t\t\t{products_group_uuid} /* Products */,")
    pbx.append("\t\t\t);")
    pbx.append("\t\t\tsourceTree = \"<group>\";")
    pbx.append("\t\t};")
    
    # Products Group
    pbx.append(f"\t\t{products_group_uuid} /* Products */ = {{")
    pbx.append("\t\t\tisa = PBXGroup;")
    pbx.append("\t\t\tchildren = (")
    pbx.append(f"\t\t\t\t{app_product_uuid} /* LabLearn.app */,")
    pbx.append("\t\t\t);")
    pbx.append("\t\t\tname = Products;")
    pbx.append("\t\t\tsourceTree = \"<group>\";")
    pbx.append("\t\t};")
    
    # App Group (LabLearn root folder)
    top_level_subgroups = [k for k in subgroups.keys() if not k.startswith("Views/")]
    has_views = any(k.startswith("Views/") for k in subgroups.keys())
    
    pbx.append(f"\t\t{app_group_uuid} /* LabLearn */ = {{")
    pbx.append("\t\t\tisa = PBXGroup;")
    pbx.append("\t\t\tchildren = (")
    for k in top_level_subgroups:
        pbx.append(f"\t\t\t\t{subgroup_uuids[k]} /* {k} */,")
    if has_views:
        pbx.append(f"\t\t\t\t{views_group_uuid} /* Views */,")
    pbx.append("\t\t\t);")
    pbx.append("\t\t\tpath = LabLearn;")
    pbx.append("\t\t\tsourceTree = \"<group>\";")
    pbx.append("\t\t};")
    
    # Views Group
    if has_views:
        view_subkeys = [k for k in subgroups.keys() if k.startswith("Views/")]
        pbx.append(f"\t\t{views_group_uuid} /* Views */ = {{")
        pbx.append("\t\t\tisa = PBXGroup;")
        pbx.append("\t\t\tchildren = (")
        for vk in view_subkeys:
            sub_name = vk.split("/")[1]
            pbx.append(f"\t\t\t\t{subgroup_uuids[vk]} /* {sub_name} */,")
        pbx.append("\t\t\t);")
        pbx.append("\t\t\tpath = Views;")
        pbx.append("\t\t\tsourceTree = \"<group>\";")
        pbx.append("\t\t};")
    
    # Subgroups
    for k, files in subgroups.items():
        sg_uuid = subgroup_uuids[k]
        display_name = k.split("/")[-1]
        path_name = display_name
        pbx.append(f"\t\t{sg_uuid} /* {display_name} */ = {{")
        pbx.append("\t\t\tisa = PBXGroup;")
        pbx.append("\t\t\tchildren = (")
        for f_uuid, fname in files:
            pbx.append(f"\t\t\t\t{f_uuid} /* {fname} */,")
        if k == "Resources":
            pbx.append(f"\t\t\t\t{assets_file_uuid} /* Assets.xcassets */,")
            pbx.append(f"\t\t\t\t{info_plist_file_uuid} /* Info.plist */,")
        pbx.append("\t\t\t);")
        pbx.append(f"\t\t\tpath = {path_name};")
        pbx.append("\t\t\tsourceTree = \"<group>\";")
        pbx.append("\t\t};")
    
    pbx.append("/* End PBXGroup section */\n")
    
    # PBXNativeTarget
    pbx.append("/* Begin PBXNativeTarget section */")
    pbx.append(f"\t\t{target_uuid} /* LabLearn */ = {{")
    pbx.append("\t\t\tisa = PBXNativeTarget;")
    pbx.append(f"\t\t\tbuildConfigurationList = {target_cfg_list_uuid} /* Build configuration list for PBXNativeTarget \"LabLearn\" */;")
    pbx.append("\t\t\tbuildPhases = (")
    pbx.append(f"\t\t\t\t{sources_phase_uuid} /* Sources */,")
    pbx.append(f"\t\t\t\t{frameworks_phase_uuid} /* Frameworks */,")
    pbx.append(f"\t\t\t\t{resources_phase_uuid} /* Resources */,")
    pbx.append("\t\t\t);")
    pbx.append("\t\t\tbuildRules = (")
    pbx.append("\t\t\t);")
    pbx.append("\t\t\tdependencies = (")
    pbx.append("\t\t\t);")
    pbx.append("\t\t\tname = LabLearn;")
    pbx.append("\t\t\tproductName = LabLearn;")
    pbx.append(f"\t\t\tproductReference = {app_product_uuid} /* LabLearn.app */;")
    pbx.append("\t\t\tproductType = \"com.apple.product-type.application\";")
    pbx.append("\t\t};")
    pbx.append("/* End PBXNativeTarget section */\n")
    
    # PBXProject
    pbx.append("/* Begin PBXProject section */")
    pbx.append(f"\t\t{proj_uuid} /* Project object */ = {{")
    pbx.append("\t\t\tisa = PBXProject;")
    pbx.append("\t\t\tattributes = {")
    pbx.append("\t\t\t\tBuildIndependentTargetsInParallel = 1;")
    pbx.append("\t\t\t\tLastUpgradeCheck = 1520;")
    pbx.append("\t\t\t\tTargetAttributes = {")
    pbx.append(f"\t\t\t\t\t{target_uuid} = {{")
    pbx.append("\t\t\t\t\t\tCreatedOnToolsVersion = 15.2;")
    pbx.append("\t\t\t\t\t};")
    pbx.append("\t\t\t\t};")
    pbx.append("\t\t\t};")
    pbx.append(f"\t\t\tbuildConfigurationList = {proj_cfg_list_uuid} /* Build configuration list for PBXProject \"LabLearn\" */;")
    pbx.append("\t\t\tcompatibilityVersion = \"Xcode 14.0\";")
    pbx.append("\t\t\tdevelopmentRegion = en;")
    pbx.append("\t\t\thasScannedForEncodings = 0;")
    pbx.append("\t\t\tknownRegions = (")
    pbx.append("\t\t\t\ten,")
    pbx.append("\t\t\t\tBase,")
    pbx.append("\t\t\t);")
    pbx.append(f"\t\t\tmainGroup = {main_group_uuid};")
    pbx.append(f"\t\t\tproductRefGroup = {products_group_uuid} /* Products */;")
    pbx.append("\t\t\tprojectDirPath = \"\";")
    pbx.append("\t\t\tprojectRoot = \"\";")
    pbx.append("\t\t\ttargets = (")
    pbx.append(f"\t\t\t\t{target_uuid} /* LabLearn */,")
    pbx.append("\t\t\t);")
    pbx.append("\t\t};")
    pbx.append("/* End PBXProject section */\n")
    
    # PBXResourcesBuildPhase
    pbx.append("/* Begin PBXResourcesBuildPhase section */")
    pbx.append(f"\t\t{resources_phase_uuid} /* Resources */ = {{")
    pbx.append("\t\t\tisa = PBXResourcesBuildPhase;")
    pbx.append("\t\t\tbuildActionMask = 2147483647;")
    pbx.append("\t\t\tfiles = (")
    pbx.append(f"\t\t\t\t{assets_build_uuid} /* Assets.xcassets in Resources */,")
    pbx.append("\t\t\t);")
    pbx.append("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
    pbx.append("\t\t};")
    pbx.append("/* End PBXResourcesBuildPhase section */\n")
    
    # PBXSourcesBuildPhase
    pbx.append("/* Begin PBXSourcesBuildPhase section */")
    pbx.append(f"\t\t{sources_phase_uuid} /* Sources */ = {{")
    pbx.append("\t\t\tisa = PBXSourcesBuildPhase;")
    pbx.append("\t\t\tbuildActionMask = 2147483647;")
    pbx.append("\t\t\tfiles = (")
    for b_uuid, _, filename in build_objs:
        pbx.append(f"\t\t\t\t{b_uuid} /* {filename} in Sources */,")
    pbx.append("\t\t\t);")
    pbx.append("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
    pbx.append("\t\t};")
    pbx.append("/* End PBXSourcesBuildPhase section */\n")
    
    # XCBuildConfiguration
    pbx.append("/* Begin XCBuildConfiguration section */")
    
    # Project Debug
    pbx.append(f"\t\t{proj_cfg_debug_uuid} /* Debug */ = {{")
    pbx.append("\t\t\tisa = XCBuildConfiguration;")
    pbx.append("\t\t\tbuildSettings = {")
    pbx.append("\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;")
    pbx.append("\t\t\t\tCLANG_ANALYZER_NONNULL = YES;")
    pbx.append("\t\t\t\tCLANG_ENABLE_MODULES = YES;")
    pbx.append("\t\t\t\tCOPY_PHASE_STRIP = NO;")
    pbx.append("\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;")
    pbx.append("\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;")
    pbx.append("\t\t\t\tENABLE_TESTABILITY = YES;")
    pbx.append("\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;")
    pbx.append("\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;")
    pbx.append("\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;")
    pbx.append("\t\t\t\tGCC_PREPROCESSOR_DEFINITIONS = (")
    pbx.append("\t\t\t\t\t\"DEBUG=1\",")
    pbx.append("\t\t\t\t\t\"$(inherited)\",")
    pbx.append("\t\t\t\t);")
    pbx.append("\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 16.0;")
    pbx.append("\t\t\t\tMTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;")
    pbx.append("\t\t\t\tONLY_ACTIVE_ARCH = YES;")
    pbx.append("\t\t\t\tSDKROOT = iphoneos;")
    pbx.append("\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;")
    pbx.append("\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = \"-Onone\";")
    pbx.append("\t\t\t};")
    pbx.append("\t\t\tname = Debug;")
    pbx.append("\t\t};")
    
    # Project Release
    pbx.append(f"\t\t{proj_cfg_release_uuid} /* Release */ = {{")
    pbx.append("\t\t\tisa = XCBuildConfiguration;")
    pbx.append("\t\t\tbuildSettings = {")
    pbx.append("\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;")
    pbx.append("\t\t\t\tCLANG_ANALYZER_NONNULL = YES;")
    pbx.append("\t\t\t\tCLANG_ENABLE_MODULES = YES;")
    pbx.append("\t\t\t\tCOPY_PHASE_STRIP = NO;")
    pbx.append("\t\t\t\tDEBUG_INFORMATION_FORMAT = \"dwarf-with-dsym\";")
    pbx.append("\t\t\t\tENABLE_NS_ASSERTIONS = NO;")
    pbx.append("\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;")
    pbx.append("\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;")
    pbx.append("\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 16.0;")
    pbx.append("\t\t\t\tMTL_ENABLE_DEBUG_INFO = NO;")
    pbx.append("\t\t\t\tSDKROOT = iphoneos;")
    pbx.append("\t\t\t\tSWIFT_COMPILATION_MODE = \"wholemodule\";")
    pbx.append("\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = \"-O\";")
    pbx.append("\t\t\t\tVALIDATE_PRODUCT = YES;")
    pbx.append("\t\t\t};")
    pbx.append("\t\t\tname = Release;")
    pbx.append("\t\t};")
    
    # Target Debug
    pbx.append(f"\t\t{target_cfg_debug_uuid} /* Debug */ = {{")
    pbx.append("\t\t\tisa = XCBuildConfiguration;")
    pbx.append("\t\t\tbuildSettings = {")
    pbx.append("\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;")
    pbx.append("\t\t\t\tASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;")
    pbx.append("\t\t\t\tCODE_SIGN_STYLE = Automatic;")
    pbx.append("\t\t\t\tCURRENT_PROJECT_VERSION = 1;")
    pbx.append("\t\t\t\tGENERATE_INFOPLIST_FILE = NO;")
    pbx.append("\t\t\t\tINFOPLIST_FILE = LabLearn/Resources/Info.plist;")
    pbx.append("\t\t\t\tINFOPLIST_KEY_CFBundleDisplayName = LabLearn;")
    pbx.append("\t\t\t\tINFOPLIST_KEY_LSApplicationCategoryType = \"public.app-category.education\";")
    pbx.append("\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 16.0;")
    pbx.append("\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (")
    pbx.append("\t\t\t\t\t\"$(inherited)\",")
    pbx.append("\t\t\t\t\t\"@executable_path/Frameworks\",")
    pbx.append("\t\t\t\t);")
    pbx.append("\t\t\t\tMARKETING_VERSION = 1.0.0;")
    pbx.append("\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.lablearn.app;")
    pbx.append("\t\t\t\tPRODUCT_NAME = \"$(TARGET_NAME)\";")
    pbx.append("\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;")
    pbx.append("\t\t\t\tSWIFT_VERSION = 5.0;")
    pbx.append("\t\t\t\tTARGETED_DEVICE_FAMILY = \"1,2\";")
    pbx.append("\t\t\t};")
    pbx.append("\t\t\tname = Debug;")
    pbx.append("\t\t};")
    
    # Target Release
    pbx.append(f"\t\t{target_cfg_release_uuid} /* Release */ = {{")
    pbx.append("\t\t\tisa = XCBuildConfiguration;")
    pbx.append("\t\t\tbuildSettings = {")
    pbx.append("\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;")
    pbx.append("\t\t\t\tASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;")
    pbx.append("\t\t\t\tCODE_SIGN_STYLE = Automatic;")
    pbx.append("\t\t\t\tCURRENT_PROJECT_VERSION = 1;")
    pbx.append("\t\t\t\tGENERATE_INFOPLIST_FILE = NO;")
    pbx.append("\t\t\t\tINFOPLIST_FILE = LabLearn/Resources/Info.plist;")
    pbx.append("\t\t\t\tINFOPLIST_KEY_CFBundleDisplayName = LabLearn;")
    pbx.append("\t\t\t\tINFOPLIST_KEY_LSApplicationCategoryType = \"public.app-category.education\";")
    pbx.append("\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 16.0;")
    pbx.append("\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (")
    pbx.append("\t\t\t\t\t\"$(inherited)\",")
    pbx.append("\t\t\t\t\t\"@executable_path/Frameworks\",")
    pbx.append("\t\t\t\t);")
    pbx.append("\t\t\t\tMARKETING_VERSION = 1.0.0;")
    pbx.append("\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.lablearn.app;")
    pbx.append("\t\t\t\tPRODUCT_NAME = \"$(TARGET_NAME)\";")
    pbx.append("\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;")
    pbx.append("\t\t\t\tSWIFT_VERSION = 5.0;")
    pbx.append("\t\t\t\tTARGETED_DEVICE_FAMILY = \"1,2\";")
    pbx.append("\t\t\t};")
    pbx.append("\t\t\tname = Release;")
    pbx.append("\t\t};")
    
    pbx.append("/* End XCBuildConfiguration section */\n")
    
    # XCConfigurationList
    pbx.append("/* Begin XCConfigurationList section */")
    pbx.append(f"\t\t{proj_cfg_list_uuid} /* Build configuration list for PBXProject \"LabLearn\" */ = {{")
    pbx.append("\t\t\tisa = XCConfigurationList;")
    pbx.append("\t\t\tbuildConfigurations = (")
    pbx.append(f"\t\t\t\t{proj_cfg_debug_uuid} /* Debug */,")
    pbx.append(f"\t\t\t\t{proj_cfg_release_uuid} /* Release */,")
    pbx.append("\t\t\t);")
    pbx.append("\t\t\tdefaultConfigurationIsVisible = 0;")
    pbx.append("\t\t\tdefaultConfigurationName = Release;")
    pbx.append("\t\t};")
    
    pbx.append(f"\t\t{target_cfg_list_uuid} /* Build configuration list for PBXNativeTarget \"LabLearn\" */ = {{")
    pbx.append("\t\t\tisa = XCConfigurationList;")
    pbx.append("\t\t\tbuildConfigurations = (")
    pbx.append(f"\t\t\t\t{target_cfg_debug_uuid} /* Debug */,")
    pbx.append(f"\t\t\t\t{target_cfg_release_uuid} /* Release */,")
    pbx.append("\t\t\t);")
    pbx.append("\t\t\tdefaultConfigurationIsVisible = 0;")
    pbx.append("\t\t\tdefaultConfigurationName = Release;")
    pbx.append("\t\t};")
    pbx.append("/* End XCConfigurationList section */\n")
    
    pbx.append("\t};")
    pbx.append(f"\trootObject = {proj_uuid} /* Project object */;")
    pbx.append("}")
    
    pbx_path = proj_dir / "project.pbxproj"
    with open(pbx_path, "w", encoding="utf-8") as f:
        f.write("\n".join(pbx) + "\n")
    print(f"Generated {pbx_path}")

if __name__ == "__main__":
    main()
