/*
 * 
 * Copyright (c) CFCA. All Rights Reserved.
 * 
 */
package cfca;
/**
 * BOCServerDecryption
 * 
 * decrypt PWD which is uploaded from client
 * 
 * @version:1.0
 * 
 * @author:Feng Lin
 */


public class BOCServerDecryption {

	/**
	 * @param args
	 */

    public static void main(String[] args) {
		// args[0] - pfx file full path
		// args[1] - pfx PWD
		// args[2] - RSA encrypted data (base64) [The encrypted content is RC]
        // args[3] - RS(base64)
		// args[4] - 3DES encrypted data (base64) [The encrypted content is the password(base64)]
		
		int nArgumentsNumber = args.length;
		System.out.println("Arguments Number:" + nArgumentsNumber);

		// print arguments
		for (int i = 0; i < nArgumentsNumber; i++) 
		{
			System.out.println("Arguments[" + i + "]:" + args[i]);
		}
		
		if(5!=nArgumentsNumber)
		{
			System.out.println("Error arguments");
			return;
		}
		
		String pfxFileName = args[0];
		String pfxPassword = args[1];
		String RSAEncryptedDataBase64 = args[2];
		String RSBase64 = args[3];
		String tripleDESEncryptedDataBase64 = args[4];
		
		byte[] plainRCBinary = PKCS12.RSADecrypt(pfxFileName, pfxPassword, RSAEncryptedDataBase64);
		
		byte[] plainPWDBase64Binary = TripleDES.DecryptCipher(RSBase64, plainRCBinary, tripleDESEncryptedDataBase64);
		
		String plainPWDBase64 = new String(plainPWDBase64Binary);
		
		System.out.println("Base64 Password:"+plainPWDBase64);	
		
		byte[] plainPWDBinary = Base64.DecodeBase64(plainPWDBase64);
		
		String plainPWD = new String(plainPWDBinary);
		
		System.out.println("Password/or Hash Password:"+plainPWD);
	}

}

