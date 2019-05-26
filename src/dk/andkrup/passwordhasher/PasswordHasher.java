package dk.andkrup.passwordhasher;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.cli.PosixParser;

import dk.andkrup.hash.Hasher;
import dk.andkrup.hash.MD5Hash;
import dk.andkrup.util.ClipboardManager;

public class PasswordHasher{

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String domain = null;
		String salt = null;
		
		CommandLineParser parser = new PosixParser();
		Options options = new Options();
		// parse domain parameter
		@SuppressWarnings("static-access")
		Option domainOpt = OptionBuilder.withArgName("domain").hasArg().withDescription("use given domain").create("domain");
		options.addOption(domainOpt);
		// parse salt parameter
		@SuppressWarnings("static-access")
		Option saltOpt = OptionBuilder.withArgName("salt").hasArg().withDescription("use given salt").create("salt");
		options.addOption(saltOpt);
		// parse length parameter (optional)
		@SuppressWarnings("static-access")
		Option lengthOpt = OptionBuilder.withArgName("length").hasArg().withDescription("use only length").create("length");
		options.addOption(lengthOpt);
		
		CommandLine line = null;
		try {
			line = parser.parse(options, args);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		if(null!=line){
			if(line.hasOption("domain")) {
				domain = line.getOptionValue("domain");
			}
			if(line.hasOption("salt")) {
				salt = line.getOptionValue("salt");
			}
		
			if(null==domain){
				String cb = ClipboardManager.getClipboardContents();
				if(null!=cb){
					domain = cb;
				}
				else{
					domain = readDomain();
				}
			}
			if(null!=salt && null!=domain){
				// TODO: look-up domain to see if there is any additional rules for the password hashing
				Hasher hasher;
				// do the hashing
				hasher = new MD5Hash();
				String result = hasher.hashIt(domain + salt);
				// trim to length, if required
				if(line.hasOption("length")) {
					int len = Integer.parseInt(line.getOptionValue("length"));
					if(len < result.length()){
						result = result.substring(0, len);
					}
				}
				// put result where it is needed
				ClipboardManager.setClipboardContents(result);
				System.out.println("passphrase added to clipboard");
			}
		}
	}
	
	private static String readDomain(){
		String domain = "";
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		System.out.println("input domain: ");
		try{
			domain = br.readLine();
		}
		catch (IOException ioe) {
			System.out.println("IO error reading domain");
			System.exit(1);
		}
		return domain;
	}
}
