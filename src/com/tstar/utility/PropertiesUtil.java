package com.tstar.utility;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

@Service
public class PropertiesUtil {
	
	private final Logger logger = Logger.getLogger(PropertiesUtil.class);

	private Properties props;
	private URI uri;
	
	public PropertiesUtil() {
		readProperties("/sys.properties");
	}
	
	public PropertiesUtil(String path) {
		readProperties(path);
	}
	
	private void readProperties(String fileName) {
		try {
			props = new Properties();
			InputStream fis = getClass().getResourceAsStream(fileName);
			props.load(fis);
//			uri = this.getClass().getResource("/sys.properties").toURI();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 獲取某個屬性
	 */
	public String getProperty(String key) {
		logger.debug("PropertiesUtil.getProperty key:" + key + " value: " + props.getProperty(key));
		return props.getProperty(key);
	}

	/**
	 * 獲取所有屬性，返回一個map,不常用 可以試試props.putAll(t)
	 */
	public Map getAllProperty() {
		Map map = new HashMap();
		Enumeration enu = props.propertyNames();
		while (enu.hasMoreElements()) {
			String key = (String) enu.nextElement();
			String value = props.getProperty(key);
			map.put(key, value);
		}
		return map;
	}

	/**
	 * 在控制台上打印出所有屬性，調試時用。
	 */
	public void printProperties() {
		props.list(System.out);
	}

	/**
	 * 寫入properties信息
	 */
	public void writeProperties(String key, String value) {
		try {
			OutputStream fos = new FileOutputStream(new File(uri));
			props.setProperty(key, value);
			// 將此 Properties 表中的屬性列表（鍵和元素對）寫入輸出流
			props.store(fos, "『comments'Update key：" + key);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
