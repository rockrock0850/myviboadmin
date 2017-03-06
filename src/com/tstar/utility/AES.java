package com.tstar.utility;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

@Service
@Scope("prototype")
public class AES {
	
	public String decrypt(String iv, String key, String encrypted) {
		
		String decryptedStr = "";
		try {
			decryptedStr = decryptAES(iv, key, encrypted);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return decryptedStr;
	}
	
	
	/**
	* Aes
	* @param iv
	* @param key
	* @param text
	* @return
	*/
	public String decryptAES(String iv, String key, String text) throws Exception {
		try {
			IvParameterSpec ivSpec = new IvParameterSpec(iv.getBytes("UTF-8"));
			SecretKeySpec mSecretKeySpec = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
			Cipher mCipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
			mCipher.init(Cipher.DECRYPT_MODE, mSecretKeySpec, ivSpec);
			byte[] bytes = text.getBytes("UTF-8");
			return new String(mCipher.doFinal(Base64.decodeBase64(bytes)), "UTF-8");
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new SspException("10001", "解密失敗", ex.getCause());
		}
	}
	
	public String decrypt4AES(String iv, String key, String text) throws Exception {
		try {
			byte[] decryptFrom = Base64.decodeBase64(text.getBytes("UTF-8"));
			IvParameterSpec zeroIv = new IvParameterSpec(iv.getBytes());
			SecretKeySpec key1 = new SecretKeySpec(key.getBytes(), "AES");
			Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
			
			cipher.init(Cipher.DECRYPT_MODE, key1, zeroIv);
			byte decryptedData[] = cipher.doFinal(decryptFrom);
			return new String(decryptedData, "UTF-8"); // 加密
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new SspException("10001", "解密失敗", ex.getCause());
		}
	}

}
