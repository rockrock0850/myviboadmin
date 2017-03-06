package com.tstar.utility;

import org.apache.log4j.FileAppender;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;
import org.apache.log4j.RollingFileAppender;
public class LoggerUtil {
   
    public static Logger getLoggerByName(String name) {
        // 生成新的Logger
        // 如果已經有了一個Logger實例返回現有的
        Logger logger = Logger.getLogger(name);
        // 清空Appender。特別是不想使用現存實例時一定要初期化
        logger.removeAllAppenders();
        // 設定Logger級別。
        logger.setLevel(Level.DEBUG);
        // 設定是否繼承父Logger。
        // 默認為true。繼承root輸出。
        // 設定false後將不輸出root。
        logger.setAdditivity(true);
        // 生成新的Appender
        FileAppender appender = new RollingFileAppender();
        PatternLayout layout = new PatternLayout();
        // log的輸出形式
        String conversionPattern = "[%p]%d{yyyy-MM-dd HH:mm:ss}[%C-%L] %m%n";
        layout.setConversionPattern(conversionPattern);
        appender.setLayout(layout);
        // log輸出路徑
        // 這裡使用了環境變量[catalina.home]，只有在tomcat環境下才可以取到
        String tomcatPath = java.lang.System.getProperty("catalina.home");
        appender.setFile(tomcatPath + "/logs/" + name + ".log");
        // log的文字碼
        appender.setEncoding("UTF-8");
        // true:在已存在log文件後面追加 false:新log覆蓋以前的log
        appender.setAppend(true);
        // 適用當前配置
        appender.activateOptions();
        // 將新的Appender加到Logger中
        logger.addAppender(appender);
        return logger;
    }
}