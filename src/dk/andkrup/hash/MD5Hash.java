package dk.andkrup.hash;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MD5Hash implements Hasher {
	public static String getMD5Digest(String input){
		String rtString = "";
		MessageDigest md5 = null;
		byte[] bytes = null;
		byte[] digest = null;
		
		try {
			bytes = input.getBytes("UTF-8");
		}
		catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		try {
			md5 = MessageDigest.getInstance("MD5");
		}
		catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		if(null!=md5 && null!=bytes){
			md5.reset();
			md5.update(bytes);
			digest = md5.digest();
			
			StringBuffer hexString = new StringBuffer();
			for (int i=0;i<digest.length;i++) {
				String hex = Integer.toHexString(0xFF & digest[i]);
				if (hex.length() == 1){
					hexString.append('0');
				}
				hexString.append(hex);
			}
			rtString = hexString.toString();
		}
		return rtString;
	}

	@Override
	public String hashIt(String phrase) {
		return MD5Hash.getMD5Digest(phrase);
	}

}
