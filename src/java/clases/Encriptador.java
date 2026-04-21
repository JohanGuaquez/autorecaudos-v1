
package clases;
import java.nio.charset.StandardCharsets;



import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Encriptador {

    public static String encriptar(String clave) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(clave.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error al encriptar la clave", e);
        }
    }
}
