//
//  LaunchPrecheck.swift
//  PCL.Mac
//
//  Created by AnemoFlower on 2026/2/2.
//

import Foundation

public enum LaunchPrecheck {
    public static func check(
        for instance: MinecraftInstance,
        with options: LaunchOptions
    ) -> [Entry] {
        var entries: [Entry] = []
        entries += checkJava(instance: instance, currentJava: options.javaRuntime)
        return entries
    }

    private static func checkJava(instance: MinecraftInstance, currentJava: JavaRuntime) -> [Entry] {
        var entries: [Entry] = []
        let minVersion: Int = instance.manifest.javaVersion.majorVersion
        let actualVersion: Int = currentJava.majorVersion
        if actualVersion < minVersion {
            log("当前 Java 版本（\(actualVersion)）低于最低 Java 版本（\(minVersion)）")
            entries.append(.javaVersionTooLow(min: minVersion))
        }
        return entries
    }

    public enum Entry {
        case javaVersionTooLow(min: Int)
    }
}
