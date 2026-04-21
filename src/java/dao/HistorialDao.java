/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import clasesGenericas.ConectorBD;

/**
 *
 * @author DELL
 */


public class HistorialDao {
    public static void registrar(String idUsuario, String accion, int idPlanilla) {
        ConectorBD conector = new ConectorBD();
        conector.conectar();
        String sql = "INSERT INTO HistorialAcciones (idUsuario, accion, idPlanilla) VALUES ('"
                      + idUsuario + "', '" + accion + "', " + idPlanilla + ")";
        conector.ejecutarQuery(sql);
        conector.desconectar();
    }
    public static void eliminarTodo() throws Exception {
    ConectorBD conector = new ConectorBD();
    String sql = "DELETE FROM HistorialAcciones";
    conector.conectar();
    conector.ejecutarQuery(sql);
    conector.desconectar();
}

}
