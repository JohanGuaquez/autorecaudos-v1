package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FotosPlanilla {
    private String id;
    private String idPlanilla;
    private String rutaFoto;

    public FotosPlanilla() {
    }

    public FotosPlanilla(String idPlanilla, String rutaFoto) {
        this.idPlanilla = idPlanilla;
        this.rutaFoto = rutaFoto;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdPlanilla() {
        return idPlanilla;
    }

    public void setIdPlanilla(String idPlanilla) {
        this.idPlanilla = idPlanilla;
    }

    public String getRutaFoto() {
        return rutaFoto;
    }

    public void setRutaFoto(String rutaFoto) {
        this.rutaFoto = rutaFoto;
    }

    public boolean grabar() {
        String sql = "INSERT INTO FotosPlanilla (idPlanilla, rutaFoto) VALUES (" +
                idPlanilla + ", '" + rutaFoto + "')";
        return ConectorBD.ejecutarQuery(sql);
    }

    public boolean eliminar() {
        String sql = "DELETE FROM FotosPlanilla WHERE id=" + id;
        return ConectorBD.ejecutarQuery(sql);
    }

    public static List<FotosPlanilla> getFotosPorPlanilla(int idPlanilla) {
        List<FotosPlanilla> lista = new ArrayList<>();
        String sql = "SELECT id, idPlanilla, rutaFoto FROM FotosPlanilla WHERE idPlanilla=" + idPlanilla;
        ResultSet datos = ConectorBD.consultar(sql);
        try {
            while (datos.next()) {
                FotosPlanilla foto = new FotosPlanilla();
                foto.setId(datos.getString("id"));
                foto.setIdPlanilla(datos.getString("idPlanilla"));
                foto.setRutaFoto(datos.getString("rutaFoto"));
                lista.add(foto);
            }
        } catch (SQLException ex) {
            Logger.getLogger(FotosPlanilla.class.getName()).log(Level.SEVERE, null, ex);
        }
        return lista;
    }
    public static List<FotosPlanilla> obtenerFotosPorPlanilla(String idPlanilla) {
        List<FotosPlanilla> listaFotos = new ArrayList<>();
        ConectorBD conector = new ConectorBD(); // Crear instancia del conector

        try {
            conector.conectar();
            String sql = "SELECT rutaFoto FROM FotosPlanilla WHERE idPlanilla = '" + idPlanilla + "'";
            ResultSet rs = conector.consultar(sql);

            while (rs.next()) {
                FotosPlanilla foto = new FotosPlanilla();
                foto.setIdPlanilla(idPlanilla);
                foto.setRutaFoto(rs.getString("rutaFoto"));
                listaFotos.add(foto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            conector.desconectar(); // Cerrar conexión
        }
        return listaFotos;
    }
}

