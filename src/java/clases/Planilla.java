/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clases;

import clasesGenericas.ConectorBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author DELL
 */
public class Planilla {
    private String id;
    private String numeroPlanilla;
    private String codigoVendedor;
    private String nombreVendedor;
    private String fecha;
    private String numeroSemana;
    private String poblacion;
    private int estado;
    private String nota;

    public Planilla() {
    }
    public Planilla(String id) {
        String cadenaSQL = "select numeroPlanilla, codigoVendedor, nombreVendedor, numeroPlanilla, fecha, numeroSemana, poblacion, estado, nota From Planilla where id=" + id;
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                this.id = id;
                numeroPlanilla = resultado.getString("numeroPlanilla");
                codigoVendedor = resultado.getString("codigoVendedor");
                nombreVendedor = resultado.getString("nombreVendedor");
                fecha = resultado.getString("fecha");
                numeroSemana = resultado.getString("numeroSemana");
                poblacion = resultado.getString("poblacion");
                estado = resultado.getInt("estado");
                nota = resultado.getString("nota");
                
                
            }
        } catch (SQLException ex) {
            Logger.getLogger(Planilla.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    
    public String getCodigoVendedor() {
        return codigoVendedor;
    }

    public void setCodigoVendedor(String codigoVendedor) {
        this.codigoVendedor = codigoVendedor;
    }

    public String getNombreVendedor() {
        return nombreVendedor;
    }

    public void setNombreVendedor(String nombreVendedor) {
        this.nombreVendedor = nombreVendedor;
    }

    public String getNumeroPlanilla() {
        return numeroPlanilla;
    }

    public void setNumeroPlanilla(String numeroPlanilla) {
        this.numeroPlanilla = numeroPlanilla;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getNumeroSemana() {
        return numeroSemana;
    }

    public void setNumeroSemana(String numeroSemana) {
        this.numeroSemana = numeroSemana;
    }

    public String getPoblacion() {
        return poblacion;
    }

    public void setPoblacion(String poblacion) {
        this.poblacion = poblacion;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

    public String getNota() {
        return nota;
    }

    public void setNota(String nota) {
        this.nota = nota;
    }
    
    

     public String getNombreV() {
        Persona persona = new Persona(nombreVendedor);
        return persona.getNombres();
    }
     @Override
    public String toString() {
        return "Planilla{" +
                "id='" + id + '\'' +
                ", nomeroPlanilla='" + numeroPlanilla + '\'' +
                ", codigoVendedor='" + codigoVendedor + '\'' +
                ", nombreVendedor='" + nombreVendedor + '\'' +
                ", fecha='" + fecha + '\'' +
                ", numeroSemna='" + numeroSemana + '\'' +
                ", poblacion='" + poblacion + '\'' +
                ", estado='" + estado + '\'' +
                ", nota='" + nota + '\'' +
                '}';
    }
    
   public boolean grabar() {
    String sql = "INSERT INTO planilla (numeroPlanilla, codigoVendedor, nombreVendedor, fecha, numeroSemana, poblacion, estado, nota) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    
    boolean resultado = ConectorBD.ejecutarQuery(sql, numeroPlanilla, codigoVendedor, nombreVendedor, fecha, numeroSemana, poblacion, estado, nota);
    
    if (resultado) {
        System.out.println("Planilla guardada correctamente.");
        
        // Obtener el ID generado
        String consultaId = "SELECT LAST_INSERT_ID()";
        ResultSet rs = new ConectorBD().ejecutarConsultaConParametros(consultaId);
        try {
            if (rs.next()) {
                this.id = rs.getString(1); // Asigna el ID generado
                System.out.println("ID generado: " + this.id);
            }
        } catch (SQLException e) {
            System.out.println("Error al recuperar el ID generado: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar ResultSet: " + e.getMessage());
            }
        }
    } else {
        System.out.println("Error al guardar la planilla.");
    }
        return false;
   }


    /* Método para modificar una persona
    public boolean modificar() {
        String cadenaSQL = "UPDATE Planilla SET numeroPlanilla='" + numeroPlanilla +
                "', codigoVendedor='" + codigoVendedor + 
                "', nombreVendedor='" + nombreVendedor +
                "', fecha='" + fecha +
                "', numeroSemana='" + numeroSemana +
                "' WHERE id=" + id ;
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }
    */
    // Método para eliminar una persona
    public boolean eliminar() {
        String cadenaSQL = "DELETE FROM Planilla WHERE id ='" + id + "'";
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }
    
    
    
        // Métodos para obtener listas de personas
    public static ResultSet getLista(String filtro, String orden) {
        if (filtro != null && !filtro.isEmpty()) {
            filtro = " WHERE " + filtro;
        } else {
            filtro = "";
        }
        if (orden != null && !orden.isEmpty()) {
            orden = " ORDER BY " + orden;
        } else {
            orden = "";
        }
        String cadenaSQL = "SELECT id, numeroPlanilla, codigoVendedor, nombreVendedor, fecha, numeroSemana, poblacion, estado, nota FROM Planilla " + filtro + orden;
        return ConectorBD.consultar(cadenaSQL);
    }

    public static List<Planilla> getListaEnObjetos(String filtro, String orden) {
        List<Planilla> lista = new ArrayList<>();
        ResultSet datos = Planilla.getLista(filtro, orden);
        if (datos != null) {
            try {
                while (datos.next()) {
                    Planilla planilla = new Planilla();
                    planilla.setId(datos.getString("id"));
                    planilla.setNumeroPlanilla(datos.getString("numeroPlanilla"));
                    planilla.setCodigoVendedor(datos.getString("codigoVendedor"));                    
                    planilla.setNombreVendedor(datos.getString("nombreVendedor"));
                    planilla.setFecha(datos.getString("fecha"));
                    planilla.setNumeroPlanilla(datos.getString("numeroPlanilla"));
                    planilla.setNumeroSemana(datos.getString("numeroSemana"));
                    planilla.setPoblacion(datos.getString("poblacion"));
                    planilla.setEstado(datos.getInt("estado"));
                    planilla.setNota(datos.getString("nota"));
                    lista.add(planilla);
                }
            } catch (SQLException ex) {
                Logger.getLogger(Planilla.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lista;
    }
    
    public void cargarPorId(String id) {
    String cadenaSQL = "SELECT numeroPlanilla, codigoVendedor, nombreVendedor, fecha, numeroSemana, poblacion, estado, nota FROM Planilla WHERE id=" + id;
    ResultSet resultado = ConectorBD.consultar(cadenaSQL);
    try {
        if (resultado.next()) {
            this.id = id;
            this.numeroPlanilla = resultado.getString("numeroPlanilla");
            this.codigoVendedor = resultado.getString("codigoVendedor");
            this.nombreVendedor = resultado.getString("nombreVendedor");
            this.fecha = resultado.getString("fecha");
            this.numeroSemana = resultado.getString("numeroSemana");
            this.poblacion = resultado.getString("poblacion");
            this.estado = resultado.getInt("estado");
            this.nota = resultado.getString("nota");
        }
    } catch (SQLException ex) {
        Logger.getLogger(Planilla.class.getName()).log(Level.SEVERE, null, ex);
    }
}
       
public boolean cambiarEstado(int nuevoEstado) {
    String sql = "UPDATE Planilla SET estado = " + nuevoEstado + " WHERE id = " + this.id;

    System.out.println("Intentando ejecutar: " + sql);
    
    boolean resultado = ConectorBD.ejecutarQuery(sql);

    System.out.println("Resultado: " + resultado);
    return resultado;
}

}


