package com.tstar.utility;

public class SspException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String code;

	public SspException() {
		super();
	}
	
	public SspException(String code, String message, Throwable cause) {
		super(message, cause);
		this.code = code;
	}

	public SspException(String message, Throwable cause) {
		super(message, cause);
	}

	public SspException(Throwable cause) {
		super(cause);
	}
	
	public String getCode() {
		return code;
	}

	public String toString() {
		String s = "本程式執行無效\n" + "錯誤代碼為 " + code + " \n" + "請將此代碼告知管理人員\n";
		return s;
	}
}