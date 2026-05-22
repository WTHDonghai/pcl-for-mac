//
//  LocaleUtils.swift
//  PCL.Mac
//
//  Created by AnemoFlower on 2026/2/4.
//

import Foundation

public enum LocaleUtils {
    /// 判断系统地区设置是否为中国大陆。
    public static func isSystemLocaleChinese() -> Bool {
        return Locale.current.identifier == "zh_CN"
    }
}
