
/**
 * @author bhaskar kalia
 */

/**
 * This class is used to calculate hash of given string data ..
 *
 * Methods :
 *
 * constructor : public hashAlgo() , no arguments .. public String
 * execute(String ) , to calculate hash of string argument ..
 *
 *
 * Classes imported are below in imports section ..
 */
import java.io.FileInputStream;
import java.security.MessageDigest;
import org.apache.commons.codec.binary.Hex;

public class hashAlgo {

    public hashAlgo() {
    }

    public String execute(String arg) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-512");

        byte[] bytestr = arg.getBytes();

        md.update(bytestr);
        byte[] mdbytes = md.digest();

	//convert byte array to hex ..
        return (Hex.encodeHexString(mdbytes)).toUpperCase();
    }
}
